//import SwiftUI
//
//struct TodayButton: View {
//    @EnvironmentObject var diaryPagerController: DiaryPagerController
//    @State var currentDate: Date = Date()
//    
//    let diaryWillChangeDate = NotificationCenter.default.publisher(for: .diaryWillChangeDate)
//    let dayPagerWillChangeDate = NotificationCenter.default.publisher(for: .dayPagerWillChangeDate)
//    let weekPagerWillChangeDate = NotificationCenter.default.publisher(for: .weekPagerWillChangeDate)
//    let didPickDateOnDayView = NotificationCenter.default.publisher(for: .didPickDateOnDayView)
//}
//
//extension TodayButton {
//
//    var body: some View {
//        Group {
//            if !currentDateIsToday {
//                Button {
//                    NotificationCenter.sendNotificationThatDiaryDateWillChange(to: Date().startOfDay)
//                    diaryPagerController.changeDate(to: Date().startOfDay)
//                } label: {
//                    Text("Today")
//                }
//            }
//        }
//        .onReceive(diaryWillChangeDate, perform: handleDateChange)
//        .onReceive(dayPagerWillChangeDate, perform: handleDateChange)
//        .onReceive(weekPagerWillChangeDate, perform: handleDateChange)
//        .onReceive(didPickDateOnDayView, perform: handleDateChange)
//    }
//    
//    func handleDateChange(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let date = userInfo[Notification.Keys.date] as? Date else {
//            return
//        }
//        currentDate = date
//    }
//    
//    var currentDateIsToday: Bool {
//        currentDate.startOfDay == Date().startOfDay
//    }
//}
