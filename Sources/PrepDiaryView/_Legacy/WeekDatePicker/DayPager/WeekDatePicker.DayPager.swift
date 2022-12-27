import SwiftUI
import SwiftUIPager
import SwiftSugar

extension WeekDatePicker {
    struct DayPager: View {
        @StateObject var controller: Controller
        
        let didTapDayButton: () -> ()
        
        init(
            currentDate: Date,
            didTapDayButton: @escaping () -> (),
            willChangeDate: ((Date) -> ())? = nil
        ) {
            self.didTapDayButton = didTapDayButton
            let controller = Controller(
                currentDate: currentDate,
                willChangeDate: willChangeDate
            )
            _controller = StateObject(wrappedValue: controller)
        }
    }
}

extension WeekDatePicker.DayPager {

    var body: some View {
        pager
    }
    
    var pager: some View {
        Pager(page: controller.page,
              data: controller.indices,
              id: \.self,
              content: { dayIndex in
            dayButton(for: dayIndex)
        })
        .sensitivity(.high)
        .pagingPriority(.high)
        .interactive(scale: 0.7)
        .interactive(opacity: 0.99)
        .onPageWillChange(controller.pageWillChange(to:))
        .onPageChanged(controller.pageChanged(to:)) //TODO: Remove this if it is not needed anymore
        .frame(width: 280, height: 27) //TODO: Remove hardcoded values
    }
    
    func dayButton(for index: Int) -> some View {
        Button {
            //TODO: DatePicker
//            diaryController.showingDatePicker = true
            didTapDayButton()
        } label: {
            controller.dateForDayIndex(index).longDateText()
                .padding(.bottom, 10)
        }
        .buttonStyle(.plain)
    }
}
