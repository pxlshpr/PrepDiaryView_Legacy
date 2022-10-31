import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline

struct DiaryPager: View {
    @Namespace private var namespace
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var controller: Controller
    @EnvironmentObject var diaryController: DiaryController
    
    var body: some View {
        Pager(page: controller.page,
              data: controller.dayIndices,
              id: \.self,
              content: { dayIndex in
            if diaryController.isListView {
                ListPage(
                    date: controller.dateForDayIndex(dayIndex),
                    namespace: namespace
                )
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(diaryController)
            } else {
                TimelinePage(
                    date: controller.dateForDayIndex(dayIndex),
                    namespace: namespace
                )
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
//        .environmentObject(NamespaceWrapper(animation))
    }
}
