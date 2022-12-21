import SwiftUI
import PrepDataTypes

public struct DiaryView<PageContent: View>: View {

    @StateObject var controller: DiaryController
    @StateObject var pagerController: DiaryPagerController
    
    @ViewBuilder let pageContentBuilder: (Date, Int, Int) -> PageContent
    
    @Binding var setToToday: Bool
    @Binding var currentDate: Date
    
    @State var showingDatePicker = false
    
    public init(
        currentDate: Binding<Date>,
        setToToday: Binding<Bool>,
        actionHandler: ((DiaryPagerAction) -> ())? = nil,
//        didPageForwads: EmptyHandler? = nil,
//        didPageBackwards: EmptyHandler? = nil,
//        onChangePageOffset: ((Int) -> ())? = nil,
//        willMoveToDate: ((Date, Int) -> ())? = nil,
//        didMoveToDate: ((Date, Int) -> ())? = nil,
        @ViewBuilder pageContentBuilder: @escaping (Date, Int, Int) -> PageContent
    ) {
        _setToToday = setToToday
        _currentDate = currentDate
        self.pageContentBuilder = pageContentBuilder
        
        let pagerController = DiaryPagerController(
            actionHandler: actionHandler
//            didPageForwards: didPageForwads,
//            didPageBackwards: didPageBackwards,
//            onChangePageOffset: onChangePageOffset,
//            willMoveToDate: willMoveToDate,
//            didMoveToDate: didMoveToDate
        )
        _pagerController = StateObject(wrappedValue: pagerController)
        _controller = StateObject(wrappedValue: DiaryController(pagerController: pagerController))
    }
    
    public var body: some View {
        navigationView
            .onChange(of: pagerController.currentDate) { newValue in
                currentDate = newValue
            }
            .onChange(of: setToToday) { newValue in
                NotificationCenter.sendNotificationThatDiaryDateWillChange(to: Date().startOfDay)
                pagerController.changeDate(to: Date().startOfDay)
            }
    }
    
    var navigationView: some View {
        VStack(spacing: 0) {
            weekDatePicker
                .background(.thinMaterial)
            Divider()
            pager
        }
        .sheet(isPresented: $showingDatePicker) { datePicker }
    }
    
    var datePicker: some View {
        DatePickerView(date: pagerController.currentDate)
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
    }
    
    var weekDatePicker: some View {
        WeekDatePicker(
            didTapDayButton: {
                showingDatePicker = true
            },
            willChangeDate: { date in
//                print("willChangeDate(to: \(date)")
            },
            didChangeDate: { date in
//                print("didChangeDate(to: \(date)")
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
