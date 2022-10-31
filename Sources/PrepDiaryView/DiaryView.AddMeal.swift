import SwiftUI
import SwiftHaptics
import NamePicker
import SwiftUISugar

extension DiaryView {
    struct AddMeal: View {
        enum Route: Hashable {
            case name
            case time
        }
        
        @Environment(\.dismiss) var dismiss

        @EnvironmentObject var diaryController: DiaryView.Controller
        @EnvironmentObject var pagerController: DiaryView.Pager.Controller
        
//        @State var showingTimePicker = false
//        @State var showingNamePicker = false
        
        @State var name = ""
        @State var time = Date()
        
        @State var path: [Route] = []
        
        let didTapAddMealButton = NotificationCenter.default.publisher(for: .didTapAddMealButton)
    }
}

extension DiaryView.AddMeal {
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                form
                Spacer()
                if !name.isEmpty {
                    addButton
                    addTemplateButton
                }
            }
            .background(Color(.systemGroupedBackground))
                .navigationTitle("Add Meal")
                .navigationBarTitleDisplayMode(.inline)
//                .toolbar { bottomToolbarContent }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .name:
                        namePicker
                    case .time:
                        timePicker
                    }
                }
        }
        .task {
            assignDefaultTime()
        }
        .onReceive(didTapAddMealButton, perform: didTapAddMealButton)
    }
    
    var addButton: some View {
        Button {
            tappedAdd()
        } label: {
            Text("Add")
                .bold()
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.accentColor)
                )
                .padding(.horizontal)
                .padding(.horizontal)
        }
    }
    
    var addTemplateButton: some View {
        Button {
            
        } label: {
            Text("Add Preset Meal")
                .bold()
                .foregroundColor(.accentColor)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.clear)
                )
                .padding(.horizontal)
                .padding(.horizontal)
                .contentShape(Rectangle())
        }
    }
    
    var bottomToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                tappedAdd()
            } label: {
                Text("Add")
            }
        }
    }
    
    var form: some View {
        Form {
            Section("Name") {
                Button {
                    path.append(.name)
                } label: {
                    if name.isEmpty {
                        Text("Required")
                            .foregroundColor(.secondary)
                    } else {
                        Text(name)
                            .foregroundColor(.primary)
                    }
                }
            }
            Section("Time") {
                Button {
                    path.append(.time)
                } label: {
                    Text(timeString)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    var timePicker: some View {
        DiaryView.AddMeal.Time(name: name, time: $time)
            .environmentObject(diaryController)
            .environmentObject(pagerController)
    }
    
    var namePicker: some View {
        Text("NamePicker goes here")
//        NamePicker(name: $name,
//                   showClearButton: true,
//                   recentStrings: Store.recentMealNames.sorted{$0<$1},
//                   presetStrings: PresetMealNameSuggestions)
        .navigationTitle("Meal Name")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var timeString: String {
        return "Time String goes here"
        if time.startOfDay == Date().startOfDay {
            return "Today \(time.shortTimeString)"
        } else {
            return time.shortString
        }
    }
    
    var addButtonSection: some View {
        Text("Add Button goes here")
//        FormButtonSection(isValid: .constant(true)) {
//            Label("Add", systemImage: "plus")
//        } onTap: {
//        }
    }
    
    //MARK: - Actions
    func didTapAddMealButton(notification: Notification) {
        tappedAdd()
    }
    
    func tappedAdd() {
        //TODO: CoreData
//        Store.createMeal(at: time, named: name)
        Haptics.feedback(style: .soft)
        dismiss()
    }
    
    func assignDefaultTime() {
        time = pagerController.currentDate
    }
}

//extension Store {
//    static func createMeal(at date: Date, named name: String) {
//        let day = Store.shared.dayCreatingIfNeeded(forDate: date)
//        let meal = Meal(context: mainContext)
//        meal.id = UUID()
//        meal.user = Store.user
//        meal.name = name
//        meal.time = Int64(date.timeIntervalSince1970)
//        meal.day = day
//        meal.createdAt = Int64(Date().timeIntervalSince1970)
//        meal.updatedAt = Int64(Date().timeIntervalSince1970)
//
//        saveMainContext()
//    }
//}
