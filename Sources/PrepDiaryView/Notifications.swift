import Foundation

extension Notification.Name {
    static var dayPagerWillChangeDate: Notification.Name { return .init("dayPagerWillChangeDate") }
    static var weekPagerWillChangeDate: Notification.Name { return .init("weekPagerWillChangeDate") }
    static var weekPagerDidChangeDate: Notification.Name { return .init("weekPagerDidChangeDate") }
    
    static var diarySummaryDetentChangedToMedium: Notification.Name { return .init("diarySummaryDetentChangedToMedium") }

    /// To move to PrepDataTypes
    static var dateDidChange: Notification.Name { return .init("dateDidChange") }
    static var diaryWillChangeDate: Notification.Name { return .init("diaryWillChangeDate") }
    static var didPickDateOnDayView: Notification.Name { return .init("didPickDateOnDayView") }
    static var didAddFoodItemToMeal: Notification.Name { return .init("didAddFoodItemToMeal") }
    static var summaryViewTypeChanged: Notification.Name { return .init("summaryViewTypeChanged") }
    
    static var foodItemCompletionDidChange: Notification.Name { return .init("foodItemCompletionDidChange") }
    static var didPickDateForMealDuplication: Notification.Name { return .init("didPickDateForMealDuplication") }
    
    static var didTapAddMealButton: Notification.Name { return .init("didTapAddMealButton") }
}

extension Notification {
    struct Keys {
        static let foodItem = "foodItem"
        static let date = "date"
        static let summaryViewTypeRawValue = "summaryViewTypeRawValue"
        static let sender = "sender"
        static let url = "url"
        static let meal = "meal"
    }
}
