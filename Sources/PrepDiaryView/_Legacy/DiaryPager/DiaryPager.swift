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

    @StateObject var page2 = Page.first()
    var data2 = PrepConstants.dayIndices

    var body: some View {
        contentForDayIndex(0)
//        pager
    }
    
    func contentForDayIndex(_ dayIndex: Int) -> some View {
        let date = controller.dateForDayIndex(dayIndex)
        let position = controller.position(of: dayIndex)
        
//        print("pageContentBuilder(date: \(date.calendarDayString), dayIndex: \(dayIndex), position: \(position))")
        return pageContentBuilder(date, dayIndex, position)
    }
    
    /// New looping pager
    var pager: some View {
        Pager(page: self.page2,
              data: self.data2,
              id: \.self) { page in
            contentForDayIndex(page)
//            ZStack {
//                Color.yellow
//                Text("\(page)")
//                    .font(.largeTitle)
//                    .fontWeight(.black)
//            }
        }
//        .pagingPriority(.simultaneous)
        .pagingPriority(.high)
        .loopPages()
        .sensitivity(.high)
        .itemSpacing(10)
    }
    
    var pager_legacy: some View {
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
        
//        .interactive(scale: includeDepthEffect ? 0.7 : 1.0)
//        .itemSpacing(includeDepthEffect ? 10 : 10)
//        .if(includeDepthEffect, transform: { view in
//            view
//                .interactive(rotation: true)
//        })
            
        .onAppear {
            /// We're doing this here to ensure the observers only get observed once
            /// (otherwise resulting it a double fire of the observer)
            controller.addNotificationObservers()
        }

    }
}
