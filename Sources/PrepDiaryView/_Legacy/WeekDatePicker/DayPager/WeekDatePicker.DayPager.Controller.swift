import SwiftUI
import SwiftUIPager
import SwiftHaptics
import PrepDataTypes

extension WeekDatePicker.DayPager {
    
    class Controller: ObservableObject {

        @Published var currentDate: Date = Date()
        @Published var page: Page = .withIndex(1)
        @Published var indices = [-1, 0, 1]
        @Published var isTransitioning = false

        let willChangeDate: ((Date) -> ())?
        
        var isHandlingDateChange: Bool = false
        var isChangingDate: Bool = false

        let initialDate: Date
        
        init(
            currentDate: Date,
            willChangeDate: ((Date) -> ())? = nil
        ) {
            initialDate = Date()
            self.willChangeDate = willChangeDate
            addNotificationObservers()
            self.setDate(to: currentDate)
        }
    }
}

extension WeekDatePicker.DayPager.Controller {
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .diaryWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .weekPagerWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .didPickDateOnDayView, object: nil)
    }
    
    @objc func handleDateChange(notification: Notification) {
        func unlockAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isHandlingDateChange = false
            }
        }
        
        guard !isHandlingDateChange else { return }
        isHandlingDateChange = true
        
        guard let userInfo = notification.userInfo,
              let date = userInfo[Notification.Keys.date] as? Date else {
            unlockAfterDelay()
            return
        }
        
        changeDate(to: date)
     
        unlockAfterDelay()
    }
}

//TODO: Move this
extension NotificationCenter {
    static func sendNotificationThatDiaryDateWillChange(to newDate: Date) {
        let userInfo = [Notification.Keys.date: newDate]
        NotificationCenter.default.post(name: .diaryWillChangeDate, object: nil, userInfo: userInfo)
    }
}

extension WeekDatePicker.DayPager.Controller {

    func pageWillChange(to pageIndex: Int) {
        let newDate = dateForDayIndex(indices[pageIndex])

        let userInfo = [Notification.Keys.date: newDate]
        NotificationCenter.default.post(name: .dayPagerWillChangeDate, object: nil, userInfo: userInfo)
        willChangeDate?(newDate)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentDate = newDate
            
            if pageIndex == 2 {
                cprint("4️⃣ Sliding window forward because pageIndex == 2")
                self.slideWindowForward()
            } else if pageIndex == 0 {
                cprint("4️⃣ Sliding window backward because pageIndex == 1")
                self.slideWindowBackward()
            } else {
                cprint("4️⃣ Not Sliding window because pageIndex == \(pageIndex)")
            }
        }
    }
    
    //TODO: Remove this if we don't need it anymore
    func pageChanged(to pageIndex: Int) {
//        updateInternalState(to: dateForDayIndex(indices[pageIndex]))
    }
    
    func slideWindowForward() {
        guard let last = indices.last else { return }
        indices.append(last + 1)
        indices.removeFirst()
        page.update(.previous)
        isTransitioning = false
    }
    
    func slideWindowBackward() {
        guard let first = indices.first else { return }
        indices.insert(first - 1 , at: 0)
        indices.removeLast()
        page.update(.next)
        isTransitioning = false
    }
    
    //MARK: Helpers
    
    func dateForDayIndex(_ dayIndex: Int) -> Date {
        /// Using `initialDate` (set at init) instead so that passing midnight doesn't mess things up
//        let date = Date().moveDayBy(dayIndex)
        let date = initialDate.moveDayBy(dayIndex)
        return date
    }
    
    //MARK: - Pager Actions
    
    /// Removed this due to it being inconsistent (seems like we're doubling up with DiaryPager)
    func tappedPreviousDay() {
        cprint("⚪️ 🗓 WeekDatePicker tappedPreviousDay()")
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
        cprint("⚪️ 🗓 WeekDatePicker tappedNextDay()")
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
    
    func changeDate(to newDate: Date) {
        guard !isChangingDate else { return }
        isChangingDate = true

        guard newDate.startOfDay != dateForDayIndex(indices[page.index]).startOfDay else {
            isChangingDate = false
            return
        }
        
        let newDateDelta = newDate.numberOfDaysFrom(currentDate)
        
//        Haptics.feedback(style: .soft)
        
        /// First filter out cases where we're changing to the next or previous day and call those handlers instead, as this is for day changes greater than 1 hop
        if newDateDelta == 1 {
            tappedNextDay()
            isChangingDate = false
            return
        }
        if newDateDelta == -1 {
            tappedPreviousDay()
            isChangingDate = false
            return
        }
        
        let newDayIndex = newDate.numberOfDaysFrom(Date())
        if newDate > currentDate {
            /// first append that date to the end of the array
            indices.append(newDayIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    /// now move the index there (we’ll be traversing two pages forwards)
                    self.currentDate = newDate
                    self.page.update(.new(index: 3))
                }
                
                /// Once the transition animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the first three pages (leaving us with only the current `newDayIndex` that we're on)
                    self.indices.removeFirst(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newDayIndex - 1, at: 0)
                    self.indices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                    
                    self.isChangingDate = false
                }
            }
        } else {
            /// first insert that date to the start of the array
            indices.insert(newDayIndex, at: 0)
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
                    self.indices.removeLast(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newDayIndex - 1, at: 0)
                    self.indices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                    
                    self.isChangingDate = false
                }
            }
        }
    }
    
    /// Has the same effect as `changeDate(to:)` without the animations or delays
    func setDate(to newDate: Date) {

        guard newDate.startOfDay != dateForDayIndex(indices[page.index]).startOfDay else {
            return
        }
        
        let newDateDelta = newDate.numberOfDaysFrom(currentDate)
        
        /// First filter out cases where we're changing to the next or previous day and call those handlers instead, as this is for day changes greater than 1 hop
        if newDateDelta == 1 {
            page.update(.next)
            currentDate = currentDate.moveDayBy(1)
            slideWindowForward()
            return
        }
        if newDateDelta == -1 {
            page.update(.previous)
            currentDate = currentDate.moveDayBy(-1)
            slideWindowBackward()
            return
        }
        
        let newDayIndex = newDate.numberOfDaysFrom(Date())
        if newDate > currentDate {
            /// first append that date to the end of the array
            indices.append(newDayIndex)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                withAnimation {
                    /// now move the index there (we’ll be traversing two pages forwards)
                    self.currentDate = newDate
                    self.page.update(.new(index: 3))
//                }
                
                /// Once the transition animation completes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the first three pages (leaving us with only the current `newDayIndex` that we're on)
                    self.indices.removeFirst(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newDayIndex - 1, at: 0)
                    self.indices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                    
                    self.isChangingDate = false
//                }
//            }
        } else {
            /// first insert that date to the start of the array
            indices.insert(newDayIndex, at: 0)
            /// move the page index forward by 1 so that we're still pointing to the correct day before the animation occurs
            page.update(.next)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//                withAnimation {
                    /// now move the index there (we’ll be traversing two pages backwards)
                    self.currentDate = newDate
                    self.page.update(.new(index: 0))
//                }
                
                /// Once the transition animation completes
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the last three pages (leaving us with only the current `newDayIndex` that we're on)
                    self.indices.removeLast(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newDayIndex - 1, at: 0)
                    self.indices.append(newDayIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the dayIndices array
                    self.page.update(.new(index: 1))
                    
                    self.isChangingDate = false
//                }
//            }
        }
    }
}
