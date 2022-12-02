import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline
import PrepDataTypes

struct DiaryPager<PageContent: View>: View {
    @EnvironmentObject var controller: DiaryPagerController
    @EnvironmentObject var diaryController: DiaryController
    
    @ViewBuilder let pageContentBuilder: (Date, Int, Int) -> PageContent

    @State var color: Color = .yellow

    var body: some View {
        pager
    }
    
    func contentForDayIndex(_ dayIndex: Int) -> some View {
        pageContentBuilder(
            controller.dateForDayIndex(dayIndex),
            dayIndex,
            controller.position(of: dayIndex)
        )
    }
    
    var pager: some View {
        Pager(
            page: controller.page,
            data: controller.dayIndices,
            id: \.self,
            content: contentForDayIndex
        )
        .sensitivity(.high)
        .pagingPriority(.high)
        .onPageChanged(controller.pageChanged(to:))
        .onPageWillChange(controller.pageWillChange(to:))
        .onAppear {
            /// We're doing this here to ensure the observers only get observed once
            /// (otherwise resulting it a double fire of the observer)
            controller.addNotificationObservers()
        }
    }
}
