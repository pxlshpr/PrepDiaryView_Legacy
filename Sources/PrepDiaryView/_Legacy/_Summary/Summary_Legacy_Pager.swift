//import SwiftUI
//import SwiftUIPager
//
//struct SummaryPager: View {
//    @EnvironmentObject var summaryController: Summary_Legacy.Controller
//    @ObservedObject var diaryPagerController: DiaryPagerController
////        @EnvironmentObject var controller: Controller
//    
////        @Environment(\.managedObjectContext) private var viewContext
////        @EnvironmentObject var diaryController: DiaryController
//    
//    var body: some View {
////        Color.red
//        Pager(page: diaryPagerController.page,
//              data: diaryPagerController.dayIndices,
//              id: \.self,
//              content: { dayIndex in
//            Summary_Legacy.PageView(date: diaryPagerController.dateForDayIndex(dayIndex))
//                .environmentObject(summaryController)
//        })
//        .sensitivity(.high)
//        .pagingPriority(.high)
////        .itemSpacing(10)
////        .interactive(rotation: true)
////        .interactive(scale: 0.7)
////        .interactive(opacity: 0.4)
//        .onPageChanged(diaryPagerController.pageChanged(to:))
//        .onPageWillChange(diaryPagerController.pageWillChange(to:))
//    }
//}
