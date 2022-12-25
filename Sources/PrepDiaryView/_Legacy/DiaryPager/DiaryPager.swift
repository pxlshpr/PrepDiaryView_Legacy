import SwiftUI
import SwiftUISugar
import SwiftUIPager
import Timeline
import PrepDataTypes

struct DiaryPager<PageContent: View>: View {
    @EnvironmentObject var controller: DiaryPagerController
    
    @Binding var allowsDragging: Bool
    @Binding var simultaneousDragging: Bool
    let includeDepthEffect: Bool
    @ViewBuilder let pageContentBuilder: (Date, Int, Int) -> PageContent

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
//        .pagingPriority(.high)
        .allowsDragging(allowsDragging)
        .pagingPriority(simultaneousDragging ? .simultaneous : .high)
        .onPageChanged(controller.pageChanged(to:))
        .onPageWillChange(controller.pageWillChange(to:))
        
        .interactive(scale: includeDepthEffect ? 0.7 : 1.0)
        .itemSpacing(includeDepthEffect ? 10 : 10)
        .if(includeDepthEffect, transform: { view in
            view
                .interactive(rotation: true)
        })
            
        .onAppear {
            /// We're doing this here to ensure the observers only get observed once
            /// (otherwise resulting it a double fire of the observer)
            controller.addNotificationObservers()
        }

    }
}
