import SwiftUI
import PrepDataTypes

public struct DiaryView<PageContent: View>: View {

    @StateObject var controller: DiaryController
    @StateObject var pagerController: DiaryPagerController
    
    @ViewBuilder let pageContentBuilder: (Date, Int) -> PageContent
    
    @Binding var currentDate: Date
    
    @State var showingDatePicker = false
    
    public init(
        currentDate: Binding<Date>,
        @ViewBuilder pageContentBuilder: @escaping (Date, Int) -> PageContent
    ) {
        _currentDate = currentDate
        self.pageContentBuilder = pageContentBuilder
        
        let pagerController = DiaryPagerController()
        _pagerController = StateObject(wrappedValue: pagerController)
        _controller = StateObject(wrappedValue: DiaryController(pagerController: pagerController))
    }
    
    public var body: some View {
        navigationView
            .onChange(of: pagerController.currentDate) { newValue in
                currentDate = newValue
            }
    }
    
    var navigationView: some View {
        VStack(spacing: 0) {
            weekDatePicker
            Divider()
            pager
        }
        .sheet(isPresented: $showingDatePicker) { datePicker }
    }
    
    var datePicker: some View {
        DatePickerView(date: pagerController.currentDate)
            .presentationDetents([.medium, .large])
    }
    
    var weekDatePicker: some View {
        WeekDatePicker(
            didTapDayButton: {
                showingDatePicker = true
            },
            willChangeDate: { date in
                print("willChangeDate(to: \(date)")
            },
            didChangeDate: { date in
                print("didChangeDate(to: \(date)")
            }
        )
    }

    var pager: some View {
        DiaryPager(pageContentBuilder: pageContentBuilder)
            .environmentObject(controller)
            .environmentObject(pagerController)
            .onChange(of: pagerController.currentDate) { newValue in
                //TODO: Send this as a notification if not doing so already and update meter
//                updateMeter()
            }
    }
}
