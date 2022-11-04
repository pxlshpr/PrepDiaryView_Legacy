import SwiftUI
import SwiftUIPager
import SwiftHaptics
import PrepDataTypes

class DiaryPagerController: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var page: Page = .withIndex(1)
    @Published var dayIndices = [-1, 0, 1]
    @Published var isTransitioning = false
    
    //TODO: CoreData
    @Published var currentDay: Day? = nil
    
    let didPageForwards: EmptyHandler?
    let didPageBackwards: EmptyHandler?
    let willMoveToDate: ((Date, Int) -> ())?
    let didMoveToDate: ((Date, Int) -> ())?
    let onChangePageOffset: ((Int) -> ())?
    
    init(
        didPageForwards: EmptyHandler? = nil,
        didPageBackwards: EmptyHandler? = nil,
        onChangePageOffset: ((Int) -> ())? = nil,
        willMoveToDate: ((Date, Int) -> ())? = nil,
        didMoveToDate: ((Date, Int) -> ())? = nil
    ) {
        self.didPageForwards = didPageForwards
        self.didPageBackwards = didPageBackwards
        self.onChangePageOffset = onChangePageOffset
        self.willMoveToDate = willMoveToDate
        self.didMoveToDate = didMoveToDate
    }
    
    var currentDateIsToday: Bool {
        currentDate.startOfDay == Date().startOfDay
    }

    func position(of dayIndex: Int) -> Int {
        dayIndices.firstIndex(of: dayIndex)!
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didPickDateOnDayView), name: .didPickDateOnDayView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dayPagerWillChangeDate), name: .dayPagerWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(weekPagerWillChangeDate), name: .weekPagerWillChangeDate, object: nil)
    }
    
    @objc func didPickDateOnDayView(notification: Notification) {
        handleDateChange(notification: notification)
    }
    @objc func dayPagerWillChangeDate(notification: Notification) {
        handleDateChange(notification: notification)
    }
    @objc func weekPagerWillChangeDate(notification: Notification) {
        handleDateChange(notification: notification)
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
        didPageForwards?()
    }
    
    func slideWindowBackward() {
        guard let first = dayIndices.first else { return }
        dayIndices.insert(first - 1 , at: 0)
        dayIndices.removeLast()
        page.update(.next)
        isTransitioning = false
        didPageBackwards?()
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
        print("⚪️ 📆 DiaryPager tappedPreviousDay()")
        guard !isTransitioning else { return }

        withAnimation {
            isTransitioning = true
            page.update(.previous)
        }
        
        /// Let the animation complete first, so that we don't interrupt it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentDate = self.currentDate.moveDayBy(-1)
            self.slideWindowBackward()
        }
    }
    
    func tappedNextDay() {
        print("⚪️ 📆 DiaryPager tappedNextDay()")
        guard !isTransitioning else { return }

        withAnimation {
            isTransitioning = true
            page.update(.next)
        }
        
        /// Let the animation complete first, so that we don't interrupt it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentDate = self.currentDate.moveDayBy(1)
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
                
                /// Indicate that the pager index will be offset by the date delta
                /// before carrying out the page action, so that the correct view is fetched
//                self.onChangePageOffset?(newDateDelta + 1)

                self.onChangePageOffset?(newDateDelta - 2)

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
                    
                    /// Let any interested parties know that the page action completed
                    self.didMoveToDate?(newDate, newDateDelta)
                }
            }
        } else {
            
            /// Indicate that the pager index will be offset by 1 before inserting the extra index at the start
            /// (so that the correct view is still fetched)
            onChangePageOffset?(-1)
            
            
            /// first insert that date at the start of the array
            dayIndices.insert(newDayIndex, at: 0)
            
            /// move the page index forward by 1 so that we're still pointing to the correct day before the animation occurs
            page.update(.next)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {

                /// Indicate that the pager index will be offset by the date delta + 1
                /// (to account for the extra element added at the start) before inserting the extra index at the start
                /// before carrying out the page action, so that the correct view is fetched
                self.onChangePageOffset?(newDateDelta + 1)

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

                    /// Let any interested parties know that the page action completed
                    self.didMoveToDate?(newDate, newDateDelta)
                }
            }
        }
    }
}
