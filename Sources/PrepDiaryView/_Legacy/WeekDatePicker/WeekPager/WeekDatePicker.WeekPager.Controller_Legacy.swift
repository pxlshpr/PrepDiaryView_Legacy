import SwiftUI
import SwiftUIPager

//MARK: - Legacy
extension WeekDatePicker.WeekPager.Controller {
    
    //TODO: Possibly remove as we're not using this anymore
    func pageWillChange(to pageIndex: Int) {
        guard let newDate = date(at: pageIndex) else { return }
        
        let userInfo = [Notification.Keys.date: newDate]
        NotificationCenter.default.post(name: .weekPagerWillChangeDate, object: nil, userInfo: userInfo)
        
//        highlightedDate = newDate

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.highlightedDate = newDate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentDate = newDate
            if pageIndex == 2 {
                self.slideWindowForward()
            } else if pageIndex == 0 {
                self.slideWindowBackward()
            }
        }
    }
    
    //TODO: Remove this to a legacy file, leaving it as a legacy code block that we may learn from later
    func changeWeek_legacy(toWeekContaining newDate: Date) {
        guard !currentWeek.contains(newDate) else { return }
        
        let newWeekDelta = newDate.numberOfWeeksFrom(currentDate)
        
        /// First filter out cases where we're changing to the next or previous day and call those handlers instead, as this is for day changes greater than 1 hop
        if newWeekDelta == 1 {
            pageToNextWeek(for: newDate)
            return
        }
        if newWeekDelta == -1 {
            pageToPreviousWeek(for: newDate)
            return
        }
        
        //TODO: Rewrite this
//        let newDayIndex = newDate.numberOfDaysFrom(Date())
        if newDate > currentDate {
            let newWeekIndex = indices[2] + newWeekDelta

            /// first append that date to the end of the array
            indices.append(newWeekIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    /// now move the index there (we’ll be traversing two pages forwards)
                    self.currentDate = newDate
                    self.highlightedDate = newDate
                    self.page.update(.new(index: 3))
                }
                
                /// Once the transition animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the first three pages (leaving us with only the current `newWeekIndex` that we're on)
                    self.indices.removeFirst(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newWeekIndex - 1, at: 0)
                    self.indices.append(newWeekIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the `indices` array
                    self.page.update(.new(index: 1))
                }
            }
        } else {
            let newWeekIndex = indices[0] + newWeekDelta

            /// first insert that date to the start of the array
            indices.insert(newWeekIndex, at: 0)
            /// move the page index forward by 1 so that we're still pointing to the correct day before the animation occurs
            page.update(.next)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    /// now move the index there (we’ll be traversing two pages backwards)
                    self.currentDate = newDate
                    self.highlightedDate = newDate
                    self.page.update(.new(index: 0))
                }
                
                /// Once the transition animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    /// Remove the last three pages (leaving us with only the current `newWeekIndex` that we're on)
                    self.indices.removeLast(3)
                    
                    /// Insert the true neighbours to the `dayIndices` array
                    self.indices.insert(newWeekIndex - 1, at: 0)
                    self.indices.append(newWeekIndex + 1)
                    
                    /// Reset the index back to 1 as we've changed the `indices` array
                    self.page.update(.new(index: 1))
                }
            }
        }
    }
}
