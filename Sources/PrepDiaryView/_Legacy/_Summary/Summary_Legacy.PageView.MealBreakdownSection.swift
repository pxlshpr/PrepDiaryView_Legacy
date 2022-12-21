//import SwiftUI
////import Charts
//import PrepDataTypes
//
//extension Summary_Legacy.PageView {
//    struct MealBreakdownSection: View {
//        @EnvironmentObject var controller: Summary_Legacy.Controller
//        
//        //TODO: CoreData
//        var day: Day
////        @ObservedObject var day: Day
//    }
//}
//
//extension Summary_Legacy.PageView.MealBreakdownSection {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(alignment: .firstTextBaseline) {
////                Text("With Most")
////                macroTypeMenu
////                breakdownTypeMenu
//                //TODO: Rewrite this with SummaryViewType
////                Text("\(controller.showingEaten ? "Eaten " : "")Meal With Most")
//                Text("TODO")
//                    .foregroundStyle(.secondary)
//                    .alignmentGuide(.chartTitleAlignmentGuide) { context in
//                        context[.firstTextBaseline]
//                    }
//                breakdownMenu
//            }
//            Text(sortedMeals.first?.name ?? "")
//                .font(.title2.bold())
//                .offset(y: -10)
//            Spacer().frame(height: 10)
//            mealBreakdownChart
//        }
//    }
//    
//    var sortedMeals: [Meal] {
//        []
////        day.meals.sorted(by: { $0.time < $1.time })
//    }
//    
//    //TODO: Make this a separate view with the modal picker with search
//    var breakdownMenu: some View {
//        Menu {
//            Section {
//                Button("Energy") { }
//                Button("Carbohydrate") { }
//                Button("Fat") { }
//                Button("Protein") { }
//            }
//            Section {
//                ForEach(NutrientTypeGroup.allCases, id: \.self) { group in
//                    Menu {
//                        Button("Micros go here") {
//                            
//                        }
//                    } label: {
//                        Text(group.description)
//                    }
//                }
//            }
//        } label: {
//            HStack {
//                Text("Energy")
//                Image(systemName: "chevron.up.chevron.down")
//            }
//            .alignmentGuide(.chartTitleAlignmentGuide) { context in
//                context[.firstTextBaseline]
//            }
//        }
//        .padding(.bottom, 15)
//    }
//    
//    var mealBreakdownChart: some View {
//        Color.cyan
////        Chart {
////            ForEach(sortedMeals, id: \.self.id) { meal in
////                ForEach(meal.macrosData.macros, id: \.self.macro.description) { element in
////                    Plot {
////                        //TODO: Next—Work on plottable
////                        BarMark(
////                            x: .value("Data Size", element.kcal),
////                            y: .value("Food", meal.plottable),
//////                            y: .value("Food", "\(item.emojiString ?? "")\(item.emojiString == nil ? "" : " ")\(item.nameString)"),
////                            width: 20
////                        )
////                        .foregroundStyle(by: .value("Data Category", element.macro.chartComponent.rawValue))
////                    }
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
////                .frame(height: CGFloat(day.mealsArray.count * 45))
////        }
////        .chartXScale(domain: 0...day.largestMealEnergy)
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
////        .chartOverlay { proxy in
////            GeometryReader { nthGeometryItem in
////                Rectangle().fill(.clear).contentShape(Rectangle())
////                    .gesture(
////                        SpatialTapGesture()
////                            .onEnded { value in
////                                //TODO: Bring this back
//////                                selectedMeal(findFoodItem(location: value.location, proxy: proxy, geometry: nthGeometryItem))
////                            }
////                            .exclusively(
////                                before: DragGesture()
////                                    .onChanged { value in
////                                        //TODO: Bring this back
//////                                        selectedMeal(findFoodItem(location: value.location, proxy: proxy, geometry: nthGeometryItem))
////                                    }
////                            )
////                    )
////            }
////        }
//    }
//}
