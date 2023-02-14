import SwiftUI
import PrepDataTypes
import SwiftUISugar

public struct DiaryView<PageContent: View>: View {

//    @StateObject var controller: DiaryController
//    @StateObject var pagerController: DiaryPagerController
    @ObservedObject var pagerController: DiaryPagerController

    @ViewBuilder let pageContentBuilder: (Date, Int, Int) -> PageContent
    
    @Binding var setToToday: Bool
    @Binding var currentDate: Date
    
    @State var showingDatePicker = false
    
    @Binding var showingWeekPager: Bool
    
    @Binding var simultaneousDragging: Bool
    let includeDepthEffect: Bool
    @Binding var allowsDragging: Bool
    
    let didChangeDateOutsideDiaryView = NotificationCenter.default.publisher(for: .didChangeDateOutsideDiaryView)
    
    public init(
        currentDate: Binding<Date>,
        setToToday: Binding<Bool>,
        pagerController: DiaryPagerController,
        showingWeekPager: Binding<Bool>? = nil,
        simultaneousDragging: Binding<Bool>,
        includeDepthEffect: Bool,
        allowsDragging: Binding<Bool>,
//        pagerDelegate: DiaryPagerDelegate,
//        actionHandler: @escaping ((DiaryPagerAction) -> ()),
        @ViewBuilder pageContentBuilder: @escaping (Date, Int, Int) -> PageContent
    ) {
        _setToToday = setToToday
        _currentDate = currentDate
        _allowsDragging = allowsDragging
        self.pageContentBuilder = pageContentBuilder
        
//        let pagerController = DiaryPagerController(
//            delegate: pagerDelegate
//        )
//        _pagerController = StateObject(wrappedValue: pagerController)
        self.pagerController = pagerController

//        _controller = StateObject(wrappedValue: DiaryController(pagerController: pagerController))
        
        if let showingWeekPager {
            _showingWeekPager = showingWeekPager
        } else {
            _showingWeekPager = .constant(true)
        }
        
        _simultaneousDragging = simultaneousDragging
        self.includeDepthEffect = includeDepthEffect
    }
    
    public var body: some View {
        navigationView
            .onChange(of: pagerController.currentDate) { newValue in
                currentDate = newValue
            }
            .onChange(of: setToToday) { newValue in
                changeDate(to: Date())
//                NotificationCenter.sendNotificationThatDiaryDateWillChange(to: Date().startOfDay)
//                pagerController.changeDate(to: Date().startOfDay)
            }
            .onReceive(didChangeDateOutsideDiaryView, perform: didChangeDateOutsideDiaryView)
    }
    
    func didChangeDateOutsideDiaryView(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let date = userInfo[Notification.Keys.date] as? Date
        else { return }
        changeDate(to: date)
    }
    
    func changeDate(to newDate: Date) {
        NotificationCenter.sendNotificationThatDiaryDateWillChange(to: newDate.startOfDay)
        pagerController.changeDate(to: newDate.startOfDay)
    }
    
    var navigationView: some View {
        VStack(spacing: 0) {
//            if showingWeekPager {
//                weekDatePicker
//                    .background(.thinMaterial)
//                Divider()
//            }
            pager
        }
        .sheet(isPresented: $showingDatePicker) { datePicker }
    }
    
    var datePicker: some View {
        DatePickerView(date: pagerController.currentDate) { pickedDate in
            NotificationCenter.default.post(
                name: .didPickDateOnDayView,
                object: nil,
                userInfo: [Notification.Keys.date: pickedDate])
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
    }
    
    var weekDatePicker: some View {
        WeekDatePicker(
            currentDate: pagerController.currentDate,
            didTapDayButton: {
                showingDatePicker = true
            },
            willChangeDate: { date in
//                cprint("willChangeDate(to: \(date)")
            },
            didChangeDate: { date in
//                cprint("didChangeDate(to: \(date)")
            }
        )
    }

    var pager: some View {
        DiaryPager(
            allowsDragging: $allowsDragging,
            simultaneousDragging: $simultaneousDragging,
            includeDepthEffect: includeDepthEffect,
            pageContentBuilder: pageContentBuilder
        )
//        .environmentObject(controller)
        .environmentObject(pagerController)
        .onChange(of: pagerController.currentDate) { newValue in
            //TODO: Send this as a notification if not doing so already and update meter
//            updateMeter()
        }
    }
}

