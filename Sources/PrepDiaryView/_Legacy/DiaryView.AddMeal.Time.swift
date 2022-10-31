//import SwiftUI
//import SwiftHaptics
//import Timeline
//import SwiftSugar
//import PrepDataTypes
//
//extension DiaryView.AddMeal {
//    struct Time: View {
//        
//        @Environment(\.presentationMode) var presentation
//        @Environment(\.dismiss) var dismiss
//
//        @EnvironmentObject var diaryController: DiaryView.Controller
//        @EnvironmentObject var pagerController: DiaryView.Pager.Controller
//
//        @StateObject var viewModel = ViewModel()
//        
//        let name: String
//        @Binding var time: Date
//        @State var pickerTime: Date
//        @StateObject var newMeal: TimelineItem
//
//        init(name: String, time: Binding<Date>) {
//            self.name = name
//            _time = time
//            _pickerTime = State(initialValue: time.wrappedValue)
//            
//            let newMeal = TimelineItem(id: UUID().uuidString,
//                                       name: name,
//                                       date: time.wrappedValue,
//                                       type: .meal,
//                                       isNew: true)
//            _newMeal = StateObject(wrappedValue: newMeal)
//        }
//    }
//}
//
//extension DiaryView.AddMeal.Time {
//    
//    var body: some View {
//        timeline
////            .background(Color(.tertiarySystemGroupedBackground))
//            .toolbar { bottomToolbarContent }
////            .toolbar { navigationTrailingContent }
//            .toolbar { navigationLeadingContent }
////            .navigationTitle("Time:")
////            .toolbar { navigationTitleContent }
//            .navigationBarTitleDisplayMode(.inline)
//            .onChange(of: pickerTime) { newValue in
//                attemptToChangeTimeTo(newValue)
//            }
//            .onChange(of: time) { newValue in
//                withAnimation {
//                    newMeal.date = newValue
//                }
//            }
//            .onChange(of: viewModel.time) { newValue in
//                attemptToChangeTimeTo(newValue)
//                Haptics.feedback(style: .soft)
////                time = newValue
//            }
//    }
//    
//    var currentDate: Date {
//        pagerController.currentDate
//    }
//    
//    func attemptToChangeTimeTo(_ time: Date) {
//        
//        //TODO: CoreData
////        let meals = Store.meals(onDate: currentDate)
////
////        var newTime = time
////
////        for meal in meals {
////
////            /// If it is less than 5 minutes before another meal, choose either 5 minutes before that meal, or 5 minutes after it if that makes it out of bounds for the day
////            /// Keep doing this until we're not conflicting with any other meals
////            if meal.isLessThanOrEqualTo5MinutesAfter(time) {
////                newTime = meal.timeDate.minus5Minutes
////                var goBackwards = true
////                if newTime.isOutOfBoundsFrom(currentDate) {
////                    goBackwards = false
////                }
////                while meals.containsMealWithin5MinutesOf(newTime) {
////                    if goBackwards {
////                        newTime = newTime.minus5Minutes
////                        if newTime.isOutOfBoundsFrom(currentDate) {
////                            goBackwards = false
////                        }
////                    } else {
////                        newTime = newTime.plus5Minutes
////                        if newTime.isOutOfBoundsFrom(currentDate) {
////                            //TODO: Handle cases where we can't go any further (day is completely full)
////                            return
////                        }
////                    }
////                }
////                break
////            }
////
////            /// Otherwise, if it is less than 5 minutes after another meal, choose either 5 minutes after that meal, or 5 minutes before it if that makes it out of bounds for the day
////            /// Keep doing this until we're not conflicting with any other meals
////            else if meal.isLessThanOrEqualTo5MinutesBefore(time) {
////                newTime = meal.timeDate.plus5Minutes
////                var goForwards = true
////                if newTime.isOutOfBoundsFrom(currentDate) {
////                    goForwards = false
////                }
////                while meals.containsMealWithin5MinutesOf(newTime) {
////                    if goForwards {
////                        newTime = newTime.plus5Minutes
////                        if newTime.isOutOfBoundsFrom(currentDate) {
////                            goForwards = false
////                        }
////                    } else {
////                        newTime = newTime.minus5Minutes
////                        if newTime.isOutOfBoundsFrom(currentDate) {
////                            //TODO: Handle cases where we can't go any further (day is completely full)
////                            return
////                        }
////                    }
////                }
////                break
////            }
////        }
////
////        /// If it is out of bounds for the day by being less than 12 am, set it at 12 am—unles we have a meal existing there—in which case keep increasing this by 5 minutes until we find an empty slot
////        if time.isLessThanBoundsFrom(currentDate) {
////            newTime = date(hour: 0, of: currentDate)
////            while meals.containsMealWithin5MinutesOf(newTime) {
////                newTime = newTime.plus5Minutes
////                if newTime.isOutOfBoundsFrom(currentDate) {
////                    return
////                }
////            }
////        }
////        /// If it is out of bounds now by being greater than 6am the next day, set it at 5:55 am—unles we have a meal existing there—in which case keep decreasing this by 5 minutes until we find an empty slot
////        else if time.isGreaterThanBoundsFrom(currentDate) {
////            newTime = date(hour: 5, minute: 55, of: currentDate.moveDayBy(1))
////            while meals.containsMealWithin5MinutesOf(newTime) {
////                newTime = newTime.minus5Minutes
////                if newTime.isOutOfBoundsFrom(currentDate) {
////                    return
////                }
////            }
////        }
////
////        /// Make sure we set viewModel.time manually here as well to keep it in sync
////        /// Make sure we test for recursion here
////        self.time = newTime
//////        viewModel.time = newTime
////        pickerTime = newTime
//    }
//    
//    var timelineItems: [TimelineItem] {
//        //TODO: CoreData
//        []
////        Store.timelineItems(for: pagerController.currentDate)
//    }
//    
//    var timeline: some View {
//        Timeline(items: timelineItems, newItem: newMeal, delegate: viewModel)
//            .background(Color(.systemGroupedBackground))
//    }
//    
//    //MARK: - UI Components
////    var navigationTrailingContent: some ToolbarContent {
////        ToolbarItemGroup(placement: .navigationBarTrailing) {
////            if pagerController.currentDateIsToday {
////                nowButton
////            }
////        }
////    }
//    
//    var navigationTitleContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .principal) {
//            datePicker
//        }
//    }
//
//    var navigationLeadingContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarLeading) {
//            timePicker
//        }
//    }
//    
//    var navigationTrailingContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            Button("Done") {
//                dismiss()
//            }
////            timePicker
//        }
//    }
//
//    var bottomToolbarContent: some ToolbarContent {
//        ToolbarItemGroup(placement: .bottomBar) {
////            ZStack {
////                HStack {
////                    button(decrement: 60)
////                    button(decrement: 15)
////                    Spacer()
////                }
////                HStack {
////                    Spacer()
////                    button(increment: 15)
////                    button(increment: 60)
////                }
////                HStack {
////                    Spacer()
////                    Button("Now") {
////                        attemptToChangeTimeTo(Date())
////                    }
////                    Spacer()
////                }
////            }
//            button(decrement: 60)
//            button(decrement: 15)
//            Text("•")
//                .foregroundColor(Color(.quaternaryLabel))
//            button(increment: 15)
//            button(increment: 60)
//            Spacer()
//            nowButton
////            addButton
//        }
//    }
//    
//    var addButton: some View {
//        Button {
//            NotificationCenter.default.post(name: .didTapAddMealButton, object: nil)
//        } label: {
//            Text("Add")
//                .bold()
//                .foregroundColor(.white)
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//                .background(
//                    Capsule(style: .continuous)
//                        .foregroundColor(.accentColor)
//                )
//        }
//
//    }
//
//    var nowButton: some View {
//        Button("Now") {
//            attemptToChangeTimeTo(Date())
//        }
////        Button {
////            attemptToChangeTimeTo(Date())
//////            time = Date()
//////            viewModel.time = time
////            Haptics.feedback(style: .soft)
////        } label: {
////            Text("Now")
//////            Image(systemName: "clock")
//////                .font(.title2)
//////                .padding(.horizontal, 7)
////        }
////        .buttonStyle(BorderlessButtonStyle())
//    }
//    
//    func button(increment: Int? = nil, decrement: Int? = nil) -> some View {
//        Button {
//            let interval: TimeInterval
//            if let increment = increment {
//                interval = TimeInterval(increment)
//            } else if let decrement = decrement {
//                interval = TimeInterval(-decrement)
//            } else {
//                interval = 0
//            }
//            attemptToChangeTimeTo(time.addingTimeInterval(interval * 60))
////            time = time.addingTimeInterval(interval * 60)
////            viewModel.time = time
//            Haptics.feedback(style: .soft)
//        } label: {
//            let systemName: String
//            if let increment = increment {
//                systemName = "goforward.\(increment)"
//            } else if let decrement = decrement {
//                systemName = "gobackward.\(decrement)"
//            } else {
//                systemName = "questionmark.circle"
//            }
//            return Image(systemName: systemName)
//                .font(.title2)
//                .padding(.horizontal, 7)
////                .padding(3)
//        }
//        .buttonStyle(BorderlessButtonStyle())
//    }
//    
//    var datePicker: some View {
//        let start = pagerController.currentDate.startOfDay
//        let end = pagerController.currentDate.moveDayBy(1).atEndOfWeeHours
//        let range = start...end
//        return DatePicker(
//            "",
//            selection: $pickerTime,
//            in: range,
//            displayedComponents: [.date]
//        )
//        .datePickerStyle(.compact)
//        .labelsHidden()
//    }
//    
//    var timePicker: some View {
//        let start = pagerController.currentDate.startOfDay
//        let end = pagerController.currentDate.moveDayBy(1).atEndOfWeeHours
//        let range = start...end
//        return DatePicker("",
//                   selection: $pickerTime,
//                   in: range,
//                   displayedComponents: [.date, .hourAndMinute])
//            .datePickerStyle(.compact)
//            .labelsHidden()
//    }
//}
//
////MARK: - ViewModel
//
//extension DiaryView.AddMeal.Time {
//    class ViewModel: ObservableObject {
//        @Published var time: Date = Date()
//    }
//}
//
//extension DiaryView.AddMeal.Time.ViewModel: TimelineDelegate {
//    func shouldRegisterTapsOnIntervals() -> Bool {
//        true
//    }
//    
//    func didTapInterval(between item1: TimelineItem, and item2: TimelineItem) {
//        guard !(item1.isNew || item2.isNew) else {
//            return
//        }
//        guard item2.date > item1.date else {
//            return
//        }
//        let midPoint = ((item2.date.timeIntervalSince1970 - item1.date.timeIntervalSince1970) / 2.0) + item1.date.timeIntervalSince1970
//        let midPointDate = Date(timeIntervalSince1970: midPoint)
//        withAnimation {
//            time = midPointDate
//        }
//    }
//    
//    func didTapNow() {
//        time = Date()
//    }
//}
//
////MARK: - Extensions
//
////TODO: CoreData
////extension Store {
////    static func timelineItems(for date: Date) -> [TimelineItem] {
////        /// get meals
////        let meals = Self.shared.meals(on: date)
////        var timelineItems = meals.map { meal in
////            TimelineItem(id: (meal.id ?? UUID()).uuidString,
////                         name: meal.nameString,
////                         date: meal.timeDate,
////                         emojis: meal.timelineEmojis,
////                         type: .meal)
////        }
////
////        /// Get and create TimelineItems from workouts
////        let workouts = Self.workouts(onDate: date)
////        timelineItems.append(contentsOf: workouts.map({ workout in
////            TimelineItem(id: (workout.id ?? UUID()).uuidString,
////                         name: workout.name ?? "Workout",
////                         date: workout.startDate,
////                         duration: TimeInterval(workout.duration),
////                         emojiStrings: [workout.emoji],
////                         type: .workout)
////        }))
////
////        return timelineItems
////    }
////}
//
//extension Array where Element == Meal {
//    func containsMealWithin5MinutesOf(_ time: Date) -> Bool {
//        contains { meal in
//            meal.isLessThanOrEqualTo5MinutesAfter(time) || meal.isLessThanOrEqualTo5MinutesBefore(time)
//        }
//    }
//}
//
//extension Date {
//    var minus5Minutes: Date {
//        addingTimeInterval(-5 * 60)
//    }
//    
//    var plus5Minutes: Date {
//        addingTimeInterval(5 * 60)
//    }
//    
//    func isLessThanBoundsFrom(_ date: Date) -> Bool {
//        startOfDay < date.startOfDay
//    }
//    
//    func isGreaterThanBoundsFrom(_ date: Date) -> Bool {
//        if startOfDay > date.startOfDay {
//            if timeIntervalSince(date.startOfDay) > 48 * 3600 {
//                return true
//            }
//            if hour > 5 {
//                return true
//            }
//        }
//        return false
//    }
//    
//    func isOutOfBoundsFrom(_ date: Date) -> Bool {
//        isLessThanBoundsFrom(date) || isGreaterThanBoundsFrom(date)
//    }
//}
//
//extension Meal {
//    
//    var timelineEmojis: [Emoji] {
//        //TODO: CoreData
//        []
////        itemsArray.compactMap {
////            Emoji(id: $0.id?.uuidString ?? "", emoji: $0.emojiString ?? "")
////        }
//    }
//    
//    var emojis: [String] {
//        //TODO: CoreData
//        []
////        itemsArray.compactMap {
////            $0.emojiString
////        }
//    }
//    
//    func isLessThanOrEqualTo5MinutesAfter(_ time: Date) -> Bool {
//        //TODO: CoreData
//        false
////        time <= self.timeDate && self.timeDate.timeIntervalSince(time) < (5 * 60)
//    }
//    func isLessThanOrEqualTo5MinutesBefore(_ time: Date) -> Bool {
//        //TODO: CoreData
//        false
////        time >= self.timeDate && time.timeIntervalSince(self.timeDate) < (5 * 60)
//    }
//}
