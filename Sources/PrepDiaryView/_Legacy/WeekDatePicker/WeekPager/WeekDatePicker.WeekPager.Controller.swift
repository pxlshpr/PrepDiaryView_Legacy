import SwiftUI
import SwiftUIPager

extension WeekDatePicker.WeekPager {
    class Controller: ObservableObject {
        
        @Published var highlightedDate: Date = Date()
        @Published var currentDate: Date = Date()
        @Published var page: Page = .withIndex(1)
        @Published var indices = [-1, 0, 1]
        @Published var isTransitioning = false
        
        let didTapDayButton: () -> ()
        let willChangeDate: ((Date) -> ())?
        let didChangeDate: ((Date) -> ())?

        init(
            didTapDayButton: @escaping () -> (),
            willChangeDate: ((Date) -> ())? = nil,
            didChangeDate: ((Date) -> ())? = nil
        ) {
            self.didTapDayButton = didTapDayButton
            self.willChangeDate = willChangeDate
            self.didChangeDate = didChangeDate
            
            addNotificationObservers()
        }
    }
}

extension WeekDatePicker.WeekPager.Controller {
    
    //MARK: - Date Change Observer
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .diaryWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .dayPagerWillChangeDate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .didPickDateOnDayView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateChange), name: .weekPagerWillChangeDate, object: nil)
    }
    
    @objc func handleDateChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let newDate = userInfo[Notification.Keys.date] as? Date else {
            return
        }
        
        /// If this notification was sent by this `WeekPager` itself, ignore it
        if let sender = userInfo[Notification.Keys.sender] as? WeekDatePicker.WeekPager.Controller,
            sender === self {
            return
        }
        
        if currentWeek.contains(newDate.startOfDay) {
            currentDate = newDate
            highlightedDate = newDate
        } else {
            changeWeek(toWeekContaining: newDate)
        }
    }
    
    //MARK: - Pager Related
    
    func pageChanged(to pageIndex: Int) {
        guard let newDate = date(at: pageIndex) else { return }
        
        let userInfo: [String: Any] = [
            Notification.Keys.date: newDate,
            Notification.Keys.sender: self
        ]
        NotificationCenter.default.post(name: .weekPagerWillChangeDate, object: nil, userInfo: userInfo)
        didChangeDate?(newDate)
        
        highlightedDate = newDate
        currentDate = newDate
        
        if pageIndex == 2 {
            slideWindowForward()
        } else if pageIndex == 0 {
            slideWindowBackward()
        }
    }
    
    //MARK: - Helpers
    
    func week(for index: Int) -> [Date] {
        let daysToAdd = relativeIndex(of: index) * 7
        return currentWeek.compactMap {
            Calendar.autoupdatingCurrent.date(byAdding: .day, value: daysToAdd, to: $0)
        }
    }
    
    /// Gives the relative index of the provided index from the `indices` array
    func relativeIndex(of index: Int) -> Int {
        /// Subtract the index from the middle index in the `indices` array (which gives us the relative position of it within the array
        index - indices[1]
    }
    
    func date(at pageIndex: Int) -> Date? {
        
        let relativeIndex: Int
        switch pageIndex {
        case 0:
            relativeIndex = -1
        case 2:
            relativeIndex = 1
        default:
            relativeIndex = 0
        }
        
        let daysToAdd = relativeIndex * 7
        return Calendar.autoupdatingCurrent.date(
            byAdding: .day,
            value: daysToAdd,
            to: currentDate
        )
    }
    
    var currentWeek: [Date] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 2 /// Start on Monday (or 1 for Sunday)
        var week: [Date] = []
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: currentDate) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        return week
    }
    
    //MARK: - Pager Actions
    func pageToPreviousWeek(for newDate: Date) {
        guard !isTransitioning else { return }
        isTransitioning = true
        
        withAnimation {
            currentDate = newDate
            highlightedDate = currentDate
            page.update(.previous)
        }
        
        self.slideWindowBackward()
    }
    
    func pageToNextWeek(for newDate: Date) {
        guard !isTransitioning else { return }
        isTransitioning = true
        
        withAnimation {
            currentDate = newDate
            highlightedDate = currentDate
            page.update(.next)
        }
        
        self.slideWindowForward()
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
    
    func slideWindowForward(by numberOfPages: Int) {
        for _ in 0..<numberOfPages {
            guard let last = indices.last else { return }
            indices.append(last + 1)
            indices.removeFirst()
        }
        page.update(.previous)
        isTransitioning = false
    }
    
    func slideWindowBackward(by numberOfPages: Int) {
        for _ in 0..<numberOfPages {
            guard let first = indices.first else { return }
            indices.insert(first - 1 , at: 0)
            indices.removeLast()
        }
        page.update(.next)
        isTransitioning = false
    }
    
    //TODO: See if using the pager this way work for the DiaryPager without any issues, and if so—use it
    func changeWeek(toWeekContaining newDate: Date) {
        guard !currentWeek.contains(newDate) else { return }
        let newWeekDelta = newDate.numberOfWeeksFrom(currentDate)
        guard !isTransitioning else { return }
        isTransitioning = true
        
        withAnimation {
            currentDate = newDate
            highlightedDate = currentDate
            if newWeekDelta < 0 {
                page.update(.previous)
            } else {
                page.update(.next)
            }
        }
        
        if newWeekDelta < 0 {
            slideWindowBackward(by: -newWeekDelta)
        } else {
            slideWindowForward(by: newWeekDelta)
        }
    }
}
