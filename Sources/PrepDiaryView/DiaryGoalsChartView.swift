import SwiftUI
import PrepDataTypes
//import Charts

enum ChartComponent: String {
    case bmr = "BMR"
    case workouts = "Workouts"
    case nree = "NREE"
    case carb = "Carbohydrate"
    case fat = "Fat"
    case protein = "Protein"
}

extension Macro {
    var chartComponent: ChartComponent {
        switch self {
        case .carb: return .carb
        case .fat: return .fat
        case .protein: return .protein
        }
    }
}

struct TdeeSegment {
    let component: ChartComponent
    let value: Int
}

struct DiaryGoalsChartView: View {
    
    @Binding var data: MacrosData
    @Binding var tdeeSegments: TdeeSegments

    let bmr = 1590
    
    var body: some View {
        chart
    }
    
    var chart: some View {
        Color.cyan
//        Chart {
//            ForEach(tdeeSegments.array, id: \.self.component.rawValue) { component in
//                Plot {
//                    BarMark(
//                        x: .value("Data Size", component.value),
//                        y: .value("Type", "TDEE")
//                    )
//                    .foregroundStyle(by: .value("", component.component.rawValue))
//                }
//            }
//            ForEach(data.macros, id: \.self.macro.rawValue) { element in
//                Plot {
//                    BarMark(
//                        x: .value("Data Size", element.kcal),
//                        y: .value("Type", "Goal")
//                    )
//                    .foregroundStyle(by: .value("Data Category", element.macro.chartComponent.rawValue))
//                }
//            }
//        }
//        //TODO: Make this a chart component enum and have macros in addition to BMR, workouts, estimated NREE
//        .chartForegroundStyleScale([
//            ChartComponent.bmr.rawValue : Color.accentColor.gradient,
//            ChartComponent.workouts.rawValue: Color.blue.gradient,
//            ChartComponent.nree.rawValue: Color.cyan.gradient,
//            ChartComponent.carb.rawValue : Macro.carb.color.gradient,
//            ChartComponent.fat.rawValue : Macro.fat.color.gradient,
//            ChartComponent.protein.rawValue : Macro.protein.color.gradient
//        ])
//        .chartPlotStyle { plotArea in
//            plotArea
////                .background(Color(.systemFill))
////                .frame(width: 300)
//                .frame(maxWidth: .infinity)
//        }
//        .frame(height: 150)
//        .chartXScale(domain: 0...max(data.kcal, tdeeSegments.kcal))
//        .chartLegend(.visible)
//        .chartXAxis {
//            AxisMarks(preset: .aligned, values: .automatic(desiredCount: 6)) { value in
//                if let intValue = value.as(Int.self) {
//                    if intValue % 1000 == 0 {
//                        AxisTick(stroke: .init(lineWidth: 1))
//                            .foregroundStyle(.gray)
//                        AxisValueLabel() {
//                            Text("\(intValue)")
//                        }
//                        AxisGridLine(stroke: .init(lineWidth: 1))
//                            .foregroundStyle(.gray)
//                    } else {
//                        AxisTick(stroke: .init(lineWidth: 1))
//                            .foregroundStyle(.gray.opacity(0.25))
//                        AxisGridLine(stroke: .init(lineWidth: 1))
//                            .foregroundStyle(.gray.opacity(0.25))
//                    }
//                }
//            }
//        }
    }
}

struct MacrosData {
    
    var macros: [MacroData]
    
    var kcal: Int {
        Int(macros.reduce(0) { $0 + $1.kcal })
    }
    
    static let example: MacrosData = MacrosData(macros: [
        .init(macro: .carb, kcal: 1200),
        .init(macro: .fat, kcal: 810),
        .init(macro: .protein, kcal: 880)
    ])

    static let example2: MacrosData = MacrosData(macros: [
        .init(macro: .carb, kcal: 300),
        .init(macro: .fat, kcal: 310),
        .init(macro: .protein, kcal: 280)
    ])

    struct MacroData: Identifiable {
        let macro: Macro
        let kcal: Double
        var id: String { macro.initial }
        
        var grams: Double {
            if macro == .fat {
                return kcal / 9.0
            } else {
                return kcal / 4.0
            }
        }
    }
}

extension MacrosData: Equatable {
    static func ==(lhs: MacrosData, rhs: MacrosData) -> Bool {
        lhs.macros == rhs.macros
    }
}

extension MacrosData.MacroData: Equatable {
    static func ==(lhs: MacrosData.MacroData, rhs: MacrosData.MacroData) -> Bool {
        lhs.macro == rhs.macro
        && lhs.kcal == rhs.kcal
    }
}

struct DataUsageData {
    static let example: [Series] = [
        .init(category: "Carbs", size: 1200),
        .init(category: "Fat", size: 810),
        .init(category: "Protein", size: 880)
    ]

//    static let example: [Series] = [
//        .init(category: "Carbs", size: 320),
//        .init(category: "Fat", size: 210),
//        .init(category: "Protein", size: 450)
//    ]

    /// A data series for the bars.
    struct Series: Identifiable {
        /// Data Group.
        let category: String
        
        /// Size of data in gigabytes?
        let size: Double
        
        /// The identifier for the series.
        var id: String { category }
    }
}

struct DiaryGoalsChartView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryGoalsChartView(data: .constant(macrosDataRecomposition),
                            tdeeSegments: .constant(TdeeSegments(array: tdeeSegmentsWithWorkouts)))
    }
}


var tdeeSegmentsWithWorkouts: [TdeeSegment] = [
    TdeeSegment(component: .bmr, value: 1590),
    TdeeSegment(component: .workouts, value: 530)
]

var tdeeSegmentsWithoutWorkouts: [TdeeSegment] = [
    TdeeSegment(component: .bmr, value: 1590)
]
