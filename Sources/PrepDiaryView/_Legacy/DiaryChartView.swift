import SwiftUI
//import Charts

struct DiaryChartView: View {

    @State var data = DataUsageData.example
    @Binding var date: Date
    
    var body: some View {
        chart
            .onChange(of: date) { newValue in
                getData()
            }
            .onAppear { getData() }
    }
    
    func getData() {
//        cprint("📊 Getting data for: \(date)")
    }
    
    var chart: some View {
        Color.cyan
//        Chart(data, id: \.category) { element in
//            Plot {
//                BarMark(
//                    x: .value("Data Size", element.size)
//                )
//                .foregroundStyle(by: .value("Data Category", element.category))
//                .cornerRadius(8)
//            }
////            .accessibilityLabel(element.category)
////            .accessibilityValue("\(element.size, specifier: "%.1f") GB")
////            .accessibilityHidden(true)
//        }
//        .chartForegroundStyleScale([
//            "Carbs": Macro.carb.color.gradient,
//            "Fat": Macro.fat.color.gradient,
//            "Protein": Macro.protein.color.gradient
//        ])
//        .chartPlotStyle { plotArea in
//            plotArea
//                .background(Color(.systemFill))
//                .cornerRadius(8)
//                .frame(width: 250)
//        }
////        .accessibilityChartDescriptor(self)
//        .chartXAxis(.hidden)
//        .chartYAxis(.hidden)
//        .frame(height: 20)
//        .chartXScale(range: 0...122.8)
////        .chartYScale(range: .plotDimension(padding: -8))
//        .chartLegend(.hidden)
////        .background(.red)
    }
}
