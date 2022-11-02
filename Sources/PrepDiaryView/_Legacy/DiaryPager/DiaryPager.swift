import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline
import PrepDataTypes

struct DiaryPager: View {
    @Namespace private var namespace
    @EnvironmentObject var controller: Controller
    @EnvironmentObject var diaryController: DiaryController
    
    let getMealsHandler: GetMealsHandler
    let tapAddMealHandler: EmptyHandler
    
    var body: some View {
        Pager(page: controller.page,
              data: controller.dayIndices,
              id: \.self,
              content: { dayIndex in
            pagerContent(for: controller.dateForDayIndex(dayIndex))
        })
        .sensitivity(.high)
        .pagingPriority(.high)
        .onPageChanged(controller.pageChanged(to:))
        .onPageWillChange(controller.pageWillChange(to:))
    }
    
    @ViewBuilder
    func pagerContent(for date: Date) -> some View {
        if diaryController.isListView {
            ListPage(
                date: date,
                getMealsHandler: getMealsHandler,
                tapAddMealHandler: tapAddMealHandler,
                namespace: namespace
            )
        } else {
            TimelinePage(
                date: date,
                namespace: namespace
            )
        }
    }
}
