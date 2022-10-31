import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline

extension DiaryView {
    struct Pager: View {
        @Namespace private var animation
        @Environment(\.managedObjectContext) private var viewContext
        @EnvironmentObject var controller: Controller
        @EnvironmentObject var diaryController: DiaryView.Controller
    }
}

extension DiaryView.Pager {
    var body: some View {
        Pager(page: controller.page,
              data: controller.dayIndices,
              id: \.self,
              content: { dayIndex in
            if diaryController.isListView {
                DiaryView.ListPage(date: controller.dateForDayIndex(dayIndex))
                    .environment(\.managedObjectContext, viewContext)
                    .environmentObject(diaryController)
            } else {
                DiaryView.TimelinePage(date: controller.dateForDayIndex(dayIndex))
            }
        })
        .sensitivity(.high)
        .pagingPriority(.high)
//        .itemSpacing(10)
//        .interactive(rotation: true)
//        .interactive(scale: 0.7)
//        .interactive(opacity: 0.4)
        .onPageChanged(controller.pageChanged(to:))
        .onPageWillChange(controller.pageWillChange(to:))
        .namespace(animation)
//        .environmentObject(NamespaceWrapper(animation))
    }
}
