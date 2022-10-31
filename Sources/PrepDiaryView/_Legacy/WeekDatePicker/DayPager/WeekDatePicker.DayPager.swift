import SwiftUI
import SwiftUIPager
import SwiftSugar

extension WeekDatePicker {
    struct DayPager: View {
        @StateObject var controller = Controller()
        
        init(delegate: WeekDatePickerDelegate? = nil) {
            _controller = StateObject(wrappedValue: Controller(delegate: delegate))
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
        .frame(width: 280, height: 44) //TODO: Remove hardcoded values
    }
    
    func dayButton(for index: Int) -> some View {
        Button {
            //TODO: DatePicker
//            diaryController.showingDatePicker = true
            controller.delegate?.didTapDayButton()
        } label: {
            controller.dateForDayIndex(index).longDateText()
                .padding(.bottom)
        }
        .buttonStyle(.plain)
    }
}
