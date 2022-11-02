import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline
import PrepDataTypes

struct DiaryPager<PageContent: View>: View {
    @Namespace private var namespace
    @EnvironmentObject var controller: DiaryPagerController
    @EnvironmentObject var diaryController: DiaryController
    
    @ViewBuilder let pageContentBuilder: (Date) -> PageContent

    var body: some View {
        Pager(
            page: controller.page,
            data: controller.dayIndices,
            id: \.self,
            content:
                { dayIndex in
                    pageContentBuilder(controller.dateForDayIndex(dayIndex))
                }
        )
        .sensitivity(.high)
        .pagingPriority(.high)
        .onPageChanged(controller.pageChanged(to:))
        .onPageWillChange(controller.pageWillChange(to:))
    }
}
