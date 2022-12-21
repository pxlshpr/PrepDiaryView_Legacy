//import SwiftUI
//import PrepViews
//import PrepDataTypes
//
//extension Summary_Legacy {
//    struct PageView: View {
//        @EnvironmentObject var summaryController: Summary_Legacy.Controller
//        @State var hasAppeared = false
//        @StateObject var viewModel: ViewModel
//        
//        //TODO: Move to viewModel
//        @StateObject var nutrientBreakdownViewModel: NutrientBreakdown.ViewModel = NutrientBreakdown.ViewModel.empty
//        
//        init(date: Date) {
//            _viewModel = StateObject(wrappedValue: ViewModel(date: date))
//        }
//    }
//}
//
//extension Summary_Legacy.PageView {
////    //TODO: Try initializing with day instead?
////    init(date: Date = Date()) {
//////        self.date = date
//////        self.daysViewModel = daysViewModel
////
////        let predicate: NSPredicate
////        if let day = Store.shared.day(forDate: date) {
////            predicate = NSPredicate(format: "day = %@", day)
////        } else {
////            predicate = NSPredicate(format: "time = 0")
////        }
////
////        _day = FetchRequest<Meal>(
////            sortDescriptors: [NSSortDescriptor(keyPath: \Meal.time, ascending: true)],
////            predicate: predicate,
////            animation: .default
////        )
////    }
//    
//    var body: some View {
//        form
//            .task {
//                
//                viewModel.fetchData()
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    withAnimation {
//                        hasAppeared = true
//                    }
//                }
//            }
//            .onAppear {
//                updateNutrientBreakdown()
//            }
////            .onChange(of: summaryController.diaryPagerController.currentDate) { newValue in
////                updateNutrientBreakdown()
////            }
//    }
//    
//    func updateNutrientBreakdown() {
////        withAnimation(.interactiveSpring()) {
////            guard let day = Store.shared.day(forDate: viewModel.date) else {
////                //TODO: Reset values
////                return
////            }
////
////            nutrientBreakdownViewModel.energyViewModel.burned = day.workoutsEnergy
////            nutrientBreakdownViewModel.energyViewModel.goal = day.goalEnergy
////            nutrientBreakdownViewModel.energyViewModel.food = day.energyPlanned
////            nutrientBreakdownViewModel.energyViewModel.eaten = day.energyConsumed
////
////            nutrientBreakdownViewModel.carbViewModel.burned = day.workoutsCarb
////            nutrientBreakdownViewModel.carbViewModel.goal = day.goalCarb
////            nutrientBreakdownViewModel.carbViewModel.food = day.carbPlanned
////            nutrientBreakdownViewModel.carbViewModel.eaten = day.carbConsumed
////
////            nutrientBreakdownViewModel.fatViewModel.burned = day.workoutsFat
////            nutrientBreakdownViewModel.fatViewModel.goal = day.goalFat
////            nutrientBreakdownViewModel.fatViewModel.food = day.fatPlanned
////            nutrientBreakdownViewModel.fatViewModel.eaten = day.fatConsumed
////
////            nutrientBreakdownViewModel.proteinViewModel.burned = day.workoutsProtein
////            nutrientBreakdownViewModel.proteinViewModel.goal = day.goalProtein
////            nutrientBreakdownViewModel.proteinViewModel.food = day.proteinPlanned
////            nutrientBreakdownViewModel.proteinViewModel.eaten = day.proteinConsumed
////
////        }
//
//    }
//    
//    var breakdownSectionHeader: some View {
//        Text("breakdownSectionHeader")
////        var detailsButton: some View {
////            let titleString = "\(nutrientBreakdownViewModel.showingDetails ? "Hide" : "Show") Details"
////            return Button {
////                withAnimation {
////                    nutrientBreakdownViewModel.showingDetails.toggle()
////                }
////            } label: {
////                Text(titleString)
////                    .font(.subheadline)
////                    .textCase(.none)
////            }
////        }
////
////        return Group {
////            HStack {
////                Spacer()
////                detailsButton
////            }
////        }
//    }
//    
//
//    var form: some View {
//        Form {
//            Section {
//                goalLink
//                workoutsLink
//            }
////            Section {
////                goalDescription
////            }
//            Section(header: breakdownSectionHeader) {
//                NutrientBreakdown(viewModel: nutrientBreakdownViewModel)
//            }
////            GaugesGrid(date: viewModel.date, summaryController: summaryController)
//            Section {
//                gaugesDescription
//            }
////            Section {
////                macroBreakdown
////            }
////            if showingMealBreakdown {
////                MealBreakdownSection(day: day)
////                    .environmentObject(summaryController)
////                    .transition(.opacity)
////            }
////            Section {
////                mealBreakdown
////            }
//        }
//    }
//    
//    //MARK: - Components
//    var workoutsLink: some View {
//        NavigationLink(destination: Text("Workouts")) {
//            LabeledContent {
//                VStack(alignment: .trailing) {
//                    Text("482 kcal")
//                }
//            } label: {
//                Label("Workouts", systemImage: "figure.run")
//            }
//        }
//    }
//    
//    var goalLink: some View {
//        NavigationLink(destination: goalPickerView) {
//            LabeledContent {
//                Text("Maintenance")
//            } label: {
//                Label("Goal", systemImage: "target")
//            }
////
////            LabeledContent("Goal", value: "Maintenance")
////                .padding(. vertical)
//        }
//    }
//    
//    var goalDescription: some View {
//        Text("""
//Your picked your **Maintenance** Goal for the day, which allows you 1,596 kcal. Your workouts totalling 482 kcal have been added this to this, giving you a total of 2,088 kcal to eat.
//
//You are 22g away from your protein target.
//""")
//    }
//
//    var gaugesDescription: some View {
//        Text("""
//You have eaten just under 50% of your goal for today, with 103g of carbs and 59g of fat left.
//
//You are 22g away from your protein target.
//""")
//    }
//    
//    var goalPickerView: some View {
//        DiaryGoalsView()
//    }
//}
