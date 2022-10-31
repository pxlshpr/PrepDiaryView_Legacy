import SwiftUI
import SwiftUIPager
import SwiftHaptics
import PrepDataTypes

extension DiaryView.Pager {
    class Controller: ObservableObject {
        @Published var currentDate: Date = Date()
        @Published var page: Page = .withIndex(1)
        @Published var dayIndices = [-1, 0, 1]
        @Published var isTransitioning = false
        
        //TODO: CoreData
        @Published var currentDay: Day? = nil

        init() {
            addNotificationObservers()
        }
    }
}

extension DiaryView.Pager.Controller {
    func refreshAfterBackupRestoration() {
        /// Refresh the Pager by moving back 5 days and coming back to the current date
        let currentDate = currentDate
        changeDate(to: currentDate.moveDayBy(-5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.changeDate(to: currentDate)
        }
    }
}

extension DiaryView.Pager.Controller {
    var currentDateIsToday: Bool {
        currentDate.startOfDay == Date().startOfDay
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .didPickDateOnDayView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .dayPagerWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .weekPagerWillChangeDate, object: nil)
    }

    @objc func handleDateChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let date = userInfo[Notification.Keys.date] as? Date else {
            return
        }
        changeDate(to: date)
    }

    func goToToday() {
        changeDate(to: Date())
    }
    
    func pageWillChange(to newPageIndex: Int) {
        sendNotificationThatDateWillChange(to: dateForDayIndex(dayIndices[newPageIndex]))
    }
    
    func sendNotificationThatDateWillChange(to newDate: Date) {
        let userInfo = [Notification.Keys.date: newDate]
        NotificationCenter.default.post(name: .diaryWillChangeDate, object: nil, userInfo: userInfo)
    }
    
    func pageChanged(to newPageIndex: Int) {
//        let userInfo = [Notification.Keys.date: dateForDayIndex(dayIndices[newPageIndex])]
//        NotificationCenter.default.post(name: .diaryWillChangeDate, object: nil, userInfo: userInfo)

        currentDate = dateForDayIndex(dayIndices[newPageIndex])
        if newPageIndex == 2 {
            slideWindowForward()
        } else if newPageIndex == 0 {
            slideWindowBackward()
        }
    }
    
    func slideWindowForward() {
        guard let last = dayIndices.last else { return }
        dayIndices.append(last + 1)
        dayIndices.removeFirst()
        page.update(.previous)
        isTransitioning = false
    }
    
    func slideWindowBackward() {
        guard let first = dayIndices.first else { return }
        dayIndices.insert(first - 1 , at: 0)
        dayIndices.removeLast()
        page.update(.next)
        isTransitioning = false
    }
    
    func dateChanged(to newDate: Date) {
        /// Fire the notification so that `StatsView` (and any other interested parties) are notified
        let userInfo = [
            Notification.Keys.date: newDate
        ]
        NotificationCenter.default.post(name: .dateDidChange,
                                        object: nil,
                                        userInfo: userInfo)
    }
    
    //MARK: - Direct Actions
    func tappedPreviousDay() {
        guard !isTransitioning else { return }
        
        isTransitioning = true
        
        withAnimation {
            currentDate = currentDate.moveDayBy(-1)
            page.update(.previous)
        }
        /// Let the animation complete first, so that we don't interrupt it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.slideWindowBackward()
        }
    }
    
    func tappedNextDay() {
        guard !isTransitioning else { return }
        
        isTransitioning = true
        withAnimation {
            currentDate = currentDate.moveDayBy(1)
            page.update(.next)
        }
        /// Let the animation complete first, so that we don't interrupt it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.slideWindowForward()
        }
    }
    
    func dateForDayIndex(_ dayIndex: Int) -> Date {
        let date = Date().moveDayBy(dayIndex)
        return date
    }
    
    //MARK: - Helpers
    
    func changeDate(to newDate: Date) {
        guard newDate.startOfDay != dateForDayIndex(dayIndices[page.index]).startOfDay else { return }
        
        let newDateDelta = newDate.numberOfDaysFrom(currentDate)
        
        /// First filter out cases where we're changing to the next or previous day and call those handlers instead, as this is for day changes greater than 1 hop
        if newDateDelta == 1 {
            tappedNextDay()
            return
        }
        if newDateDelta == -1 {
            tappedPreviousDay()
            return
        }
        
        let newDayIndex = newDate.numberOfDaysFrom(Date())
        if newDate > currentDate {
            /// first append that date to the end of the array
            dayIndices.append(newDayIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    /// now move the index there (we’ll be traversing two pages forwards)
                    self.currentDate = newDate
                    self.page.update(.new(index: 3))
                }
                
                /// Once the transition animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the first three pages (leaving us with only the current `newDayIndex` that we're on)
                    self.dayIndices.removeFirst(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.dayIndices.insert(newDayIndex - 1, at: 0)
                    self.dayIndices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                }
            }
        } else {
            /// first insert that date to the start of the array
            dayIndices.insert(newDayIndex, at: 0)
            /// move the page index forward by 1 so that we're still pointing to the correct day before the animation occurs
            page.update(.next)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    /// now move the index there (we’ll be traversing two pages backwards)
                    self.currentDate = newDate
                    self.page.update(.new(index: 0))
                }
                
                /// Once the transition animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the last three pages (leaving us with only the current `newDayIndex` that we're on)
                    self.dayIndices.removeLast(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.dayIndices.insert(newDayIndex - 1, at: 0)
                    self.dayIndices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                }
            }
        }
    }
}
