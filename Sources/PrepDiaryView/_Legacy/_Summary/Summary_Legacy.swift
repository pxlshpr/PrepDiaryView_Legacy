//import SwiftUI
////import Charts
//import SwiftHaptics
//import PrepDataTypes
//
//struct Summary_Legacy: View {
//    
//    @ObservedObject var diaryPagerController: DiaryPagerController
//    //TODO: CoreData
////        @ObservedObject var day: Day
//    var day: Day
//    @StateObject var controller: Controller
//    
//    @State private var path: [Route] = []
//    @State var chartType: ChartType = .overview
//    @State var showingDatePicker = false
//    @State var hasAppeared = false
//    
//    let summaryDetentCollapsed = NotificationCenter.default.publisher(for: .summaryDetentCollapsed)
//
//    //TODO: Why are we loading 'day' here? Find a cleaner way of doing this
//    init(diaryPagerController: DiaryPagerController, day: Day, delegate: DiaryViewSummaryDelegate? = nil) {
//        self.diaryPagerController = diaryPagerController
//        self.day = day
//        _controller = StateObject(
//            wrappedValue:
//                Controller(diaryPagerController: diaryPagerController, delegate: delegate)
//        )
//    }
//    
//    var body: some View {
//        //TODO: Include path here once we make FoodItem and Meal reusable to show charts for both of them
//        NavigationStack(path: $path) {
//            content
////                .toolbar { navigationTitleToolbar }
//                .toolbar { navigationLeadingToolbar }
//                .toolbar { navigationTrailingToolbar }
//                .navigationTitle("Summary")
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationDestination(for: Route.self) { route in
//                    switch route {
//                    case let .meal(meal):
//                        Text("MealView goes here")
////                        MealView.Summary(meal: meal)
////                    case let .foodItem(foodItem):
////                        Text("Food Item")
//                    case .foodItem:
//                        Text("Food Item")
//                    }
//                }
//        }
//        .onChange(of: chartType) { newValue in
//            Haptics.feedback(style: .soft)
//        }
//        .onReceive(summaryDetentCollapsed, perform: summaryDetentCollapsed)
//        .task {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation {
//                    hasAppeared = true
//                }
//            }
//        }
//        .onChange(of: controller.viewType) { newViewType in
//            cprint("📨 Firing summaryViewTypeChanged notification")
//            let userInfo = [Notification.Keys.summaryViewTypeRawValue: controller.viewType.rawValue]
//            NotificationCenter.default.post(name: .summaryViewTypeChanged, object: nil, userInfo: userInfo)
//        }
//    }
//    
//    var content: some View {
//        
////        DiaryView(
////            pagerController: <#T##DiaryPagerController#>,
////            currentDate: <#T##Binding<Date>#>,
////            setToToday: <#T##Binding<Bool>#>,
////            actionHandler: <#T##((DiaryPagerAction) -> ())##((DiaryPagerAction) -> ())##(DiaryPagerAction) -> ()#>,
////            pageContentBuilder: <#T##(Date, Int, Int) -> View#>
////        )
//        
//        VStack(spacing: 0) {
//            if showingDatePicker {
//                datePicker
//                    .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            Divider()
//            if hasAppeared {
//                pager
//                    .transition(.opacity)
//            } else {
//                Spacer()
//            }
//        }
//    }
//    
//    var pager: some View {
//        SummaryPager(diaryPagerController: diaryPagerController)
//            .environmentObject(controller)
//    }
//    
//    func summaryDetentCollapsed(notification: Notification) {
//        withAnimation {
//            showingDatePicker = false
//        }
//    }
//    
//    var navigationLeadingToolbar: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarLeading) {
//            calendarButton
//        }
//    }
//    
//    var navigationTrailingToolbar: some ToolbarContent {
//        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            todayButton
//        }
//    }
//    
//    var navigationTitleToolbar: some ToolbarContent {
//        ToolbarItemGroup(placement: .principal) {
//            eatenPicker
//                .frame(maxWidth: 200.0)
//        }
//    }
//    
//    var todayButton: some View {
//        Text("Today Button")
////        TodayButton()
////            .environmentObject(diaryPagerController)
//    }
//    
//    var calendarButton: some View {
//        Button {
//            withAnimation {
//                showingDatePicker.toggle()
//            }
//            if showingDatePicker {
//                controller.delegate?.didShowDatePicker()
//            }
//        } label: {
//            Image(systemName: "calendar.circle\(showingDatePicker ? ".fill" : "")")
//        }
//    }
//
//    enum ChartType: CaseIterable, CustomStringConvertible {
//        case overview
//        case meals
//        
//        var description: String {
//            switch self {
//            case .overview:
//                return "Macros"
//            case .meals:
//                return "Meals"
//            }
//        }
//    }
//    
//    var eatenPicker: some View {
//        Picker("", selection: $controller.viewType.animation()) {
//            ForEach(SummaryViewType.allCases, id: \.self) { viewType in
//                Label(viewType.title, systemImage: viewType.systemImage).tag(viewType)
//            }
//        }
//        .pickerStyle(.segmented)
//    }
//    
//    var breakdownPicker: some View {
//        Picker("", selection: $chartType) {
//            ForEach(ChartType.allCases, id: \.self) { chartType in
//                Text(chartType.description).tag(chartType)
//            }
//        }
//        .pickerStyle(.segmented)
//    }
//    
//    
//    var datePicker: some View {
//        WeekDatePicker(
//            currentDate: diaryPagerController.currentDate,
//            didTapDayButton: {
//            },
//            willChangeDate: { date in
//            },
//            didChangeDate: { date in
//            }
//        )
//    }
//    
//    var macroBreakdown: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(alignment: .firstTextBaseline) {
////                breakdownTypeMenu
////                Text("With")
//                //TODO: Rewrite this
////                Text("\(showingEaten ? "Eaten " : "")Macro With")
//                Text("TODO")
//                    .foregroundStyle(.secondary)
//                    .alignmentGuide(.chartTitleAlignmentGuide) { context in
//                        context[.firstTextBaseline]
//                    }
//                macroBreakdownMenu
//            }
//            //TODO: Bring this back
////            HStack {
////                Text(largestMacro?.macro.description ?? "")
////                    .font(.title2.bold())
////                Text("\(Int(largestMacro?.grams ?? 0.0)) g")
////                    .font(.title3)
////                    .foregroundColor(Color(.tertiaryLabel))
////            }
////            .offset(y: -10)
//            Spacer().frame(height: 10)
//            macroBreakdownChart
//        }
//    }
//    
////    var largestMacro: MacrosData.MacroData? {
////        switch controller.viewType {
////        case .completed:
////            return day.largestEatenMacro
////        case .planned:
////            return day.largestMacro
////        }
////    }
//    
//    var breakdownTypeMenu: some View {
//        Menu {
//            Section {
//                Button("Macro") { }
//                Button("Meal") { }
//            }
//        } label: {
//            HStack {
//                Text("Macro")
//                Image(systemName: "chevron.up.chevron.down")
//            }
//            .alignmentGuide(.chartTitleAlignmentGuide) { context in
//                context[.firstTextBaseline]
//            }
//        }
//        .padding(.bottom, 15)
//    }
//    
//    var macroBreakdownMenu: some View {
//        Menu {
//            Section {
//                Button("Most Calories") { }
//                Button("Biggest Portion Of Goal") { }
//            }
//        } label: {
//            HStack {
//                Text("Most Calories")
//                Image(systemName: "chevron.up.chevron.down")
//            }
//            .alignmentGuide(.chartTitleAlignmentGuide) { context in
//                context[.firstTextBaseline]
//            }
//        }
//        .padding(.bottom, 15)
//    }
//    
//    //TODO: Bring back with Charts
////    func findFoodItem(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Meal? {
////        let relativeYPosition = location.y - geometry[proxy.plotAreaFrame].origin.y
////        if let stringValue = proxy.value(atY: relativeYPosition) as String? {
////            for meal in day.mealsArray {
////                if meal.plottable.primitivePlottable == stringValue {
////                    return meal
////                }
////            }
////        }
////
////        return nil
////    }
//    
//    func selectedMeal(_ meal: Meal?) {
//        guard let meal = meal else { return }
//        Haptics.feedback(style: .rigid)
//        path = [Route.meal(meal)]
//    }
//    
////    var sortedMacros: [MacrosData.MacroData] {
////        macrosData.macros.sorted(by: { $0.kcal > $1.kcal })
////    }
//    
////    var macrosData: MacrosData {
////        switch controller.viewType {
////        case .completed:
////            return day.eatenMacrosData
////        case .planned:
////            return day.macrosData
////        }
////    }
//    
//    //TODO: Bring back with Charts
//    var macroBreakdownChart: some View {
//        Color.cyan
////        Chart {
////            ForEach(sortedMacros, id: \.self.macro.description) { macro in
////                Plot {
////                    BarMark(
////                        x: .value("Data Size", macro.kcal),
////                        y: .value("Macro", macro.macro.description),
////                        width: 20
////                    )
////                    .foregroundStyle(by: .value("Data Category", macro.macro.chartComponent.rawValue))
////                }
////            }
////        }
////        .chartForegroundStyleScale([
////            ChartComponent.carb.rawValue : Macro.carb.color.gradient,
////            ChartComponent.fat.rawValue : Macro.fat.color.gradient,
////            ChartComponent.protein.rawValue : Macro.protein.color.gradient
////        ])
////        .chartPlotStyle { plotArea in
////            plotArea
////                .background(Color(.quaternarySystemFill))
////                .frame(maxWidth: .infinity)
////                .frame(height: CGFloat(3 * 45))
////        }
////        .chartXScale(domain: 0...((sortedMacros.first?.kcal ?? 0)))
////        .chartLegend(.visible)
////        .chartXAxis {
////            AxisMarks(preset: .automatic, values: .automatic(desiredCount: 3)) { value in
////                if let intValue = value.as(Int.self) {
////                    if intValue == 0 {
////                        AxisTick(stroke: .init(lineWidth: 1))
////                            .foregroundStyle(.gray)
////                        AxisValueLabel() {
////                            Text("\(intValue) kcal")
////                        }
////                        AxisGridLine(stroke: .init(lineWidth: 1))
////                            .foregroundStyle(.gray)
////                    } else if intValue % 2 == 0 {
////                        AxisTick(stroke: .init(lineWidth: 0.25))
////                            .foregroundStyle(.gray)
////                        AxisValueLabel() {
////                            Text("\(intValue)")
////                        }
////                        AxisGridLine(stroke: .init(lineWidth: 0.25, dash: [4.0, 3.0]))
////                            .foregroundStyle(.gray)
////                    } else {
////                        AxisTick(stroke: .init(lineWidth: 1))
////                            .foregroundStyle(.gray.opacity(0.25))
////                        AxisGridLine(stroke: .init(lineWidth: 1))
////                            .foregroundStyle(.gray.opacity(0.25))
////                    }
////                }
////            }
////        }
//    }
//}
//
////MARK: - Other Types
//
//extension Summary_Legacy {
//    enum Route: Hashable {
//        case meal(Meal)
//        case foodItem(FoodItem)
//    }
//}
//
//protocol DiaryViewSummaryDelegate: AnyObject {
//    func didShowDatePicker()
//}
//
////struct PlottableMeal: Plottable {
////
////    var meal: Meal
////    var primitivePlottable: String
////
////    init?(primitivePlottable: String) {
////        cprint("📐 Couldn't get a PlottableMeal from : \(primitivePlottable)")
////        return nil
//////        self.primitivePlottable = primitivePlottable
////    }
////
////    init(meal: Meal) {
////        self.meal = meal
////        self.primitivePlottable = "\(meal.timeString) – \(meal.nameString)"
////    }
////
////    typealias PrimitivePlottable = String
////}
//
////MARK: - Extensions
//
////TODO: Move these
//
////extension Meal {
////    var plottable: PlottableMeal {
////        PlottableMeal(meal: self)
////    }
////}
//
////extension Day {
////
////    var largestMealEnergy: Int {
////        Int(meals.sorted(by: { $0.energyAmount > $1.energyAmount }).first?.energyAmount ?? 0)
////    }
////
////    var carbAmount: Double {
////        meals.reduce(0) { $0 + $1.carbAmount }
////    }
////    var fatAmount: Double {
////        meals.reduce(0) { $0 + $1.fatAmount }
////    }
////    var proteinAmount: Double {
////        meals.reduce(0) { $0 + $1.proteinAmount }
////    }
////    var energyAmount: Double {
////        meals.reduce(0) { $0 + $1.energyAmount }
////    }
////
////    var eatenCarbAmount: Double {
////        meals.reduce(0) { $0 + $1.eatenCarbAmount }
////    }
////    var eatenFatAmount: Double {
////        meals.reduce(0) { $0 + $1.eatenFatAmount }
////    }
////    var eatenProteinAmount: Double {
////        meals.reduce(0) { $0 + $1.eatenProteinAmount }
////    }
////    var eatenEnergyAmount: Double {
////        meals.reduce(0) { $0 + $1.eatenEnergyAmount }
////    }
////
////    var carbAmountPercentage: Double {
////        guard totalMacrosAmount > 0 else { return 0 }
////        return carbAmount / totalMacrosAmount
////    }
////
////    var fatAmountPercentage: Double {
////        guard totalMacrosAmount > 0 else { return 0 }
////        return fatAmount / totalMacrosAmount
////    }
////
////    var proteinAmountPercentage: Double {
////        guard totalMacrosAmount > 0 else { return 0 }
////        return proteinAmount / totalMacrosAmount
////    }
////
////    var totalMacrosAmount: Double {
////        carbAmount + proteinAmount + fatAmount
////    }
////
////    var carbCalories: Double {
////        let weightedPercentage = carbAmountPercentage + carbEnergyPercentageDelta
////        return energyAmount * weightedPercentage
////    }
////
////    var fatCalories: Double {
////        let weightedPercentage = fatAmountPercentage + fatEnergyPercentageDelta
////        return energyAmount * weightedPercentage
////    }
////
////    var proteinCalories: Double {
////        let weightedPercentage = proteinAmountPercentage + proteinEnergyPercentageDelta
////        return energyAmount * weightedPercentage
////    }
////
////    var carbEnergyPercentageDelta: Double {
////        carbEnergyPercentage - equalMacroPercentage
////    }
////
////    var fatEnergyPercentageDelta: Double {
////        fatEnergyPercentage - equalMacroPercentage
////    }
////
////    var proteinEnergyPercentageDelta: Double {
////        proteinEnergyPercentage - equalMacroPercentage
////    }
////
////    var equalMacroPercentage: Double {
////        var numberOfMacros = 0
////        if carbAmount > 0 {
////            numberOfMacros += 1
////        }
////        if fatAmount > 0 {
////            numberOfMacros += 1
////        }
////        if proteinAmount > 0 {
////            numberOfMacros += 1
////        }
////        switch numberOfMacros {
////        case 1: return 1.0/1.0
////        case 2: return 1.0/2.0
////        case 3: return 1.0/3.0
////        default: return 0.0
////        }
////    }
////
////    var carbEnergyPercentage: Double {
////        guard carbAmount > 0 else { return 0 }
////        if fatAmount > 0 {
////            if proteinAmount > 0 {
////                return CarbCals/(CarbCals + FatCals + ProteinCals)
////            } else {
////                return CarbCals/(CarbCals + FatCals)
////            }
////        } else if proteinAmount > 0 {
////            return CarbCals/(CarbCals + ProteinCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var fatEnergyPercentage: Double {
////        guard fatAmount > 0 else { return 0 }
////        if carbAmount > 0 {
////            if proteinAmount > 0 {
////                return FatCals/(FatCals + CarbCals + ProteinCals)
////            } else {
////                return FatCals/(FatCals + CarbCals)
////            }
////        } else if proteinAmount > 0 {
////            return FatCals/(FatCals + ProteinCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var proteinEnergyPercentage: Double {
////        guard proteinAmount > 0 else { return 0 }
////        if carbAmount > 0 {
////            if fatAmount > 0 {
////                return ProteinCals/(ProteinCals + CarbCals + FatCals)
////            } else {
////                return ProteinCals/(ProteinCals + CarbCals)
////            }
////        } else if fatAmount > 0 {
////            return ProteinCals/(ProteinCals + FatCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var macrosData: MacrosData {
////        MacrosData(macros: [
////            MacrosData.MacroData(macro: .carb, kcal: carbCalories),
////            MacrosData.MacroData(macro: .fat, kcal: fatCalories),
////            MacrosData.MacroData(macro: .protein, kcal: proteinCalories),
////        ])
////    }
////
////    var eatenCarbAmountPercentage: Double {
////        guard totalEatenMacrosAmount > 0 else { return 0 }
////        return eatenCarbAmount / totalEatenMacrosAmount
////    }
////
////    var eatenFatAmountPercentage: Double {
////        guard totalEatenMacrosAmount > 0 else { return 0 }
////        return eatenFatAmount / totalEatenMacrosAmount
////    }
////
////    var eatenProteinAmountPercentage: Double {
////        guard totalEatenMacrosAmount > 0 else { return 0 }
////        return eatenProteinAmount / totalEatenMacrosAmount
////    }
////
////    var totalEatenMacrosAmount: Double {
////        eatenCarbAmount + eatenProteinAmount + eatenFatAmount
////    }
////
////    var eatenCarbEnergyPercentageDelta: Double {
////        eatenCarbEnergyPercentage - equalEatenMacroPercentage
////    }
////
////    var eatenFatEnergyPercentageDelta: Double {
////        eatenFatEnergyPercentage - equalEatenMacroPercentage
////    }
////
////    var eatenProteinEnergyPercentageDelta: Double {
////        eatenProteinEnergyPercentage - equalEatenMacroPercentage
////    }
////
////    var equalEatenMacroPercentage: Double {
////        var numberOfMacros = 0
////        if eatenCarbAmount > 0 {
////            numberOfMacros += 1
////        }
////        if eatenFatAmount > 0 {
////            numberOfMacros += 1
////        }
////        if eatenProteinAmount > 0 {
////            numberOfMacros += 1
////        }
////        switch numberOfMacros {
////        case 1: return 1.0/1.0
////        case 2: return 1.0/2.0
////        case 3: return 1.0/3.0
////        default: return 0.0
////        }
////    }
////
////    var eatenCarbEnergyPercentage: Double {
////        guard eatenCarbAmount > 0 else { return 0 }
////        if eatenFatAmount > 0 {
////            if eatenProteinAmount > 0 {
////                return CarbCals/(CarbCals + FatCals + ProteinCals)
////            } else {
////                return CarbCals/(CarbCals + FatCals)
////            }
////        } else if eatenProteinAmount > 0 {
////            return CarbCals/(CarbCals + ProteinCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var eatenFatEnergyPercentage: Double {
////        guard eatenFatAmount > 0 else { return 0 }
////        if eatenCarbAmount > 0 {
////            if eatenProteinAmount > 0 {
////                return FatCals/(FatCals + CarbCals + ProteinCals)
////            } else {
////                return FatCals/(FatCals + CarbCals)
////            }
////        } else if eatenProteinAmount > 0 {
////            return FatCals/(FatCals + ProteinCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var eatenProteinEnergyPercentage: Double {
////        guard eatenProteinAmount > 0 else { return 0 }
////        if eatenCarbAmount > 0 {
////            if eatenFatAmount > 0 {
////                return ProteinCals/(ProteinCals + CarbCals + FatCals)
////            } else {
////                return ProteinCals/(ProteinCals + CarbCals)
////            }
////        } else if eatenFatAmount > 0 {
////            return ProteinCals/(ProteinCals + FatCals)
////        } else {
////            return 1.0
////        }
////    }
////
////    var eatenCarbCalories: Double {
////        let weightedPercentage = eatenCarbAmountPercentage + eatenCarbEnergyPercentageDelta
////        return eatenEnergyAmount * weightedPercentage
////    }
////
////    var eatenFatCalories: Double {
////        let weightedPercentage = eatenFatAmountPercentage + eatenFatEnergyPercentageDelta
////        return eatenEnergyAmount * weightedPercentage
////    }
////
////    var eatenProteinCalories: Double {
////        let weightedPercentage = eatenProteinAmountPercentage + eatenProteinEnergyPercentageDelta
////        return eatenEnergyAmount * weightedPercentage
////    }
////
////    var eatenMacrosData: MacrosData {
////        MacrosData(macros: [
////            MacrosData.MacroData(macro: .carb, kcal: eatenCarbCalories),
////            MacrosData.MacroData(macro: .fat, kcal: eatenFatCalories),
////            MacrosData.MacroData(macro: .protein, kcal: eatenProteinCalories),
////        ])
////    }
////
////    var largestMacro: MacrosData.MacroData? {
////        macrosData.macros.sorted(by: { $0.kcal > $1.kcal }).first
////    }
////
////    var largestEatenMacro: MacrosData.MacroData? {
////        eatenMacrosData.macros.sorted(by: { $0.kcal > $1.kcal }).first
////    }
////
////    var dateString: String {
////        let formatter = DateFormatter()
////        formatter.dateFormat = "EEEE d MMM yyyy"
////        return formatter.string(from: date)
////    }
////}
//
//extension VerticalAlignment {
//    /// A custom alignment for chart titles.
//    private struct ChartTitleAlignment: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            // Default to bottom alignment if no guides are set.
//            context[VerticalAlignment.bottom]
//        }
//    }
//
//    /// A guide for aligning chart titles.
//    static let chartTitleAlignmentGuide = VerticalAlignment(
//        ChartTitleAlignment.self
//    )
//}
