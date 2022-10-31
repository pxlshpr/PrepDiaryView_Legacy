import SwiftUI
import SwiftHaptics
import PrepDataTypes

struct DatePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var date: Date
    @State var mealToDuplicate: Meal?
    
    init(date: Date, mealToDuplicate: Meal? = nil) {
        _date = State(initialValue: date)
        _mealToDuplicate = State(initialValue: mealToDuplicate)
    }

    var forMealDuplication: Bool {
        mealToDuplicate != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                datePicker
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var title: String {
        forMealDuplication ? "Pick a date to copy to" : "Pick a date"
    }
    
    var datePicker: some View {
        DatePicker(
            "Pick a date",
            selection: $date,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .onChange(of: date) { pickedDate in
            Haptics.feedback(style: .soft)
            sendDatePickedNotification(pickedDate: pickedDate)
            dismiss()
        }
    }
    
    func sendDatePickedNotification(pickedDate: Date) {
        var userInfo: [String: Any] = [Notification.Keys.date: pickedDate]
        if let meal = mealToDuplicate {
            userInfo[Notification.Keys.meal] = meal
        }
        NotificationCenter.default.post(
            name: forMealDuplication ? .didPickDateForMealDuplication : .didPickDateOnDayView,
            object: nil,
            userInfo: userInfo)
    }
}
