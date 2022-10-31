import SwiftUI
import SwiftHaptics
import SwiftUISugar
import PrepViews
import PrepMealForm
import Camera

public struct HomeView: View {
    
    @State var showingAddMenu = false
    @State var showingBarcodeScanner = false
    @State var showingAddMeal = false
    @State var showingSettings = false
    
    //TODO: Move to viewModel
    @StateObject var foodMeterViewModel = FoodMeter.ViewModel(component: .energy, goal: 0, burned: 0, food: 0, eaten: 0)
    
    //TODO: Move notification observer and updateMeter() function to viewModel
    let foodItemCompletionDidChange = NotificationCenter.default.publisher(for: .foodItemCompletionDidChange)

    public init() { }
    
    public var body: some View {
        content
            .onReceive(foodItemCompletionDidChange, perform: foodItemCompletionDidChange)
            .onAppear(perform: appeared)
            .sheet(isPresented: $showingBarcodeScanner) { barcodeScanner }
            .bottomMenu(isPresented: $showingAddMenu, menu: addBottomMenu)
//            .sheet(item: $controller.mealToAddFoodTo) { meal in
//                Text("PrepSearch(meal: meal)")
//                //                SearchFoodView(meal: meal)
//            }
//            .sheet(item: $controller.mealToEdit) { meal in
//                Text("Editing: \(meal.name)")
//                    .presentationDetents([.fraction(0.75), .large])
//            }
//            .sheet(item: $controller.mealToShowChartsFor) { meal in
//                MealView.Summary(meal: meal, embeddedInNavigationStack: true)
//                    .presentationDetents([.fraction(0.75), .large])
//            }
//            .sheet(item: $controller.dayToShowChartsFor) { day in
//                Summary(diaryPagerController: pagerController,
//                        day: day,
//                        delegate: controller)
//                .presentationDetents([.medium, .large], selection: $controller.selectedSummaryDetent)
//                .presentationDragIndicator(.hidden)
//            }
            .sheet(isPresented: $showingAddMeal) {
                MealForm(date: Date(), name: "Meal 1", recents: ["Recents"], presets: ["Presets"])
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showingSettings) { settingsView }
    }
    
    var content: some View {
        DiaryView(
            actionButton: addButton,
            menuButton: topMenu,
            bottomCenterView: foodMeter
        )
    }
    
    
    var settingsView: some View {
        Text("Settings View")
        //                SettingsView()
        //                    .presentationDetents([.medium, .large])
    }
    
    func appeared() {
        updateMeter()
    }
    
    var barcodeScanner: some View {
        BarcodeScanner { barcodes in
            print("Scanned \(barcodes)")
        }
    }

    func foodItemCompletionDidChange(notification: Notification) {
        updateMeter()
    }

    var addButton: some View {
        Button {
            Haptics.feedback(style: .soft)
            showingAddMenu = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    var topMenu: some View {
        Menu {
            
            Button {
//                NotificationCenter.default.post(name: .switchToLegacyUI, object: nil)
            } label: {
                Label("Switch to Legacy UI", systemImage: "rectangle.2.swap")
            }

            Divider()

            Button {
                showingSettings = true
            } label: {
                Label("Settings", systemImage: "gear")
            }

        } label: {
            Image(systemName: "ellipsis.circle")
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
    
    //MARK: - Add Menu
    
    var addBottomMenu: BottomMenu {
        BottomMenu(groups: [addMealGroup, addFoodGroup])
    }
    
    var addFoodGroup: BottomMenuActionGroup {
        var addFood: BottomMenuAction {
            BottomMenuAction(title: "Add food to a new meal", systemImage: "plus") {
            }
        }
        
        var scanFood: BottomMenuAction {
            BottomMenuAction(title: "Scan barcode", systemImage: "barcode.viewfinder") {
                showingBarcodeScanner = true
            }
        }

        var createFood: BottomMenuAction {
            BottomMenuAction(title: "Create a new food", systemImage: "carrot") {
            }
        }

        return BottomMenuActionGroup(actions: [createFood, scanFood, addFood])
    }

    var addMealGroup: BottomMenuActionGroup {
        var copyMealTemplate: BottomMenuAction {
            BottomMenuAction(title: "Copy a meal template", systemImage: "plus.square.on.square") {
            }
        }
        var addMeal: BottomMenuAction {
            BottomMenuAction(title: "Add a meal", systemImage: "rectangle.stack.badge.plus") {
                showingAddMeal = true
            }
        }

        return BottomMenuActionGroup(actions: [copyMealTemplate, addMeal])
    }
}
