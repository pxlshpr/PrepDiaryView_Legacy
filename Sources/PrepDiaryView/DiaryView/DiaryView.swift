import SwiftUI
import SwiftUIPager
import SwiftHaptics
import SwiftUISugar
import PrepViews
//import Charts

public struct DiaryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var controller: Controller
    @StateObject var pagerController: Pager.Controller
    
    //TODO: Move these to controller
    @State private var showingGoalPicker = false
    
    //TODO: Move to viewModel
    @StateObject var foodMeterViewModel = FoodMeter.ViewModel(component: .energy, goal: 0, burned: 0, food: 0, eaten: 0)
    
    //TODO: Move notification observer and updateMeter() function to viewModel
    let foodItemCompletionDidChange = NotificationCenter.default.publisher(for: .foodItemCompletionDidChange)

    public init() {
        let pagerController = Pager.Controller()
        _pagerController = StateObject(wrappedValue: pagerController)
        _controller = StateObject(wrappedValue: Controller(pagerController: pagerController))
    }
    
    public var body: some View {
        navigationView
    }
    
    var navigationView: some View {
        NavigationView {
            VStack(spacing: 0) {
                datePicker
                Divider()
                pager
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { bottomToolbarContent }
            .toolbar { navigationLeadingContent }
            .toolbar { navigationTrailingContent }
            .sheet(item: $controller.mealToAddFoodTo) { meal in
                Text("PrepSearch(meal: meal)")
//                SearchFoodView(meal: meal)
            }
            .sheet(item: $controller.mealToEdit) { meal in
                Text("Editing: \(meal.name)")
                    .presentationDetents([.fraction(0.75), .large])
            }
            .sheet(item: $controller.mealToShowChartsFor) { meal in
                DiaryView.ListPage.MealView.Summary(meal: meal, embeddedInNavigationStack: true)
                    .presentationDetents([.fraction(0.75), .large])
            }
            .sheet(item: $controller.dayToShowChartsFor) { day in
                DiaryView.Summary(diaryPagerController: pagerController,
                                  day: day,
                                  delegate: controller)
                    .presentationDetents([.medium, .large], selection: $controller.selectedSummaryDetent)
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $controller.showingDatePicker) {
                DatePickerView(date: pagerController.currentDate)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $controller.showingAddMeal) {
                DiaryView.AddMeal()
                    .environmentObject(controller)
                    .environmentObject(pagerController)
                    .presentationDetents([.medium, .large])
//                    .presentationDetents(controller.presentationDetents, selection: $controller.addMealDetent)
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $controller.showingSettings) {
                Text("Settings View")
//                SettingsView()
//                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                updateMeter()
            }
            .onReceive(foodItemCompletionDidChange, perform: foodItemCompletionDidChange)
        }
    }
    
    func foodItemCompletionDidChange(notification: Notification) {
        updateMeter()
    }
    
    var datePicker: some View {
        WeekDatePicker(delegate: controller)
            //TODO: DatePicker
//            .environmentObject(controller)
//            .environmentObject(pagerController)
    }
    
    var pager: some View {
        DiaryView.Pager()
            .environmentObject(controller)
            .environmentObject(pagerController)
            .onChange(of: pagerController.currentDate) { newValue in
                print("8️⃣ CurrentDate changed to: \(newValue)")
                updateMeter()
            }
    }
    
    func updateMeter() {
//        withAnimation(.interactiveSpring()) {
//            guard let day = Store.shared.day(forDate: pagerController.currentDate) else {
//                //TODO: Reset values
//                return
//            }
//            foodMeterViewModel.goal = day.energyGoal
//            foodMeterViewModel.burned = day.workoutsEnergy
//            foodMeterViewModel.food = day.energyPlanned
//            foodMeterViewModel.eaten = day.energyConsumed
//        }
    }
    
    func showSummary() {
//        Haptics.feedback(style: .soft)
//        guard let day = Store.shared.day(forDate: pagerController.currentDate) else {
//            return
//        }
//        controller.dayToShowChartsFor = day
    }
    
    var foodMeter: some View {
        Button {
            showSummary()
        } label: {
            FoodMeter(viewModel: foodMeterViewModel)
            .frame(width: 250)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
        }
    }
    
    var listViewButton: some View {
        Button {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            withAnimation() {
                controller.isListView.toggle()
            }
        } label: {
            Image(systemName: controller.viewChangeImageName)
        }
    }

    //MARK: - Toolbars
    
    var navigationTrailingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            TodayButton()
                .environmentObject(pagerController)
        }
    }
    
    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            menu
        }
    }
    
    var menu: some View {
        Menu {
            
            Button {
//                NotificationCenter.default.post(name: .switchToLegacyUI, object: nil)
            } label: {
                Label("Switch to Legacy UI", systemImage: "rectangle.2.swap")
            }

            Divider()

            Button {
                controller.showingSettings = true
            } label: {
                Label("Settings", systemImage: "gear")
            }

        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    
    var bottomToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            ZStack {
                HStack {
                    addMenu
                    Spacer()
                }
                HStack {
                    Spacer()
                    listViewButton
                }
                HStack {
                    Spacer()
                    foodMeter
                    Spacer()
                }
            }
        }
    }
    
    //MARK: - Add Menu
    
    var addMenu: some View {
        Menu {
            Button {
                controller.showingAddMeal = true
            } label: {
                Label("Add Meal", systemImage: "rectangle.stack.badge.plus")
            }
            Divider()
            Button {
                
            } label: {
                Label("Add Food to Meal 1", systemImage: "plus")
            }
            Divider()
            Button {
                
            } label: {
                Label("New Food", systemImage: "plus.viewfinder")
            }
            Button {
                
            } label: {
                Label("Scan Food Label", systemImage: "text.viewfinder")
            }
        } label: {
            Image(systemName: "plus")
        } primaryAction: {
            /// Not working on iOS 16 so we'll need to test this after the GM is released
            controller.showingAddMeal = true
        }
    }
}
