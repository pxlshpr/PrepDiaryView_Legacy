import SwiftUI
import SwiftUIPager

extension DiaryView.Summary {
    struct Pager: View {
        @EnvironmentObject var summaryController: DiaryView.Summary.Controller
        @ObservedObject var diaryPagerController: DiaryView.Pager.Controller
//        @EnvironmentObject var controller: Controller
        
//        @Environment(\.managedObjectContext) private var viewContext
//        @EnvironmentObject var diaryController: DiaryView.Controller
    }
}

extension DiaryView.Summary.Pager {
    var body: some View {
//        Color.red
        Pager(page: diaryPagerController.page,
              data: diaryPagerController.dayIndices,
              id: \.self,
              content: { dayIndex in
            DiaryView.Summary.PageView(date: diaryPagerController.dateForDayIndex(dayIndex))
                .environmentObject(summaryController)
        })
        .sensitivity(.high)
        .pagingPriority(.high)
//        .itemSpacing(10)
//        .interactive(rotation: true)
//        .interactive(scale: 0.7)
//        .interactive(opacity: 0.4)
        .onPageChanged(diaryPagerController.pageChanged(to:))
        .onPageWillChange(diaryPagerController.pageWillChange(to:))
    }
}
