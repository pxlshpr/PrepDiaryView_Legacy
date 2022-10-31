import SwiftUI
import SwiftUIPager

extension WeekDatePicker {
    struct WeekPager: View {
        @StateObject var controller: Controller
        
        init(delegate: WeekDatePickerDelegate? = nil) {
            _controller = StateObject(wrappedValue: Controller(delegate: delegate))
        }
    }
}

extension WeekDatePicker.WeekPager {
    var body: some View {
        Pager(page: controller.page,
              data: controller.indices,
              id: \.self,
              content: { weekIndex in
            weekPage(for: weekIndex)
        })
        .sensitivity(.high)
        .pagingPriority(.high)
        .onPageChanged(controller.pageChanged(to:))
//        .onPageWillChange(controller.pageWillChange(to:))
        .frame(height: 50) //TODO: Hardcoded Value
    }
    
    func weekPage(for index: Int) -> some View {
        HStack {
            ForEach(controller.week(for: index), id: \.self) { date in
                Button {
                    let userInfo: [String: Any] = [Notification.Keys.date: date]
                    NotificationCenter.default.post(name: .weekPagerWillChangeDate, object: nil, userInfo: userInfo)
                    controller.delegate?.didChangeDate(to: date)
                } label: {
                    Text(date.dayString)
                        .frame(maxWidth: .infinity)
                        .font(.callout)
                        .foregroundColor(foregroundColor(forDate: date))
                        .background(background(forDate: date))
                        .fontWeight(fontWeight(forDate: date))
                }
            }
        }
    }
    
    func dateIsHighlightedDate(_ date: Date) -> Bool {
        date.startOfDay == controller.highlightedDate.startOfDay
    }
    
    func fontWeight(forDate date: Date) -> Font.Weight {
        dateIsHighlightedDate(date) ? .semibold : .regular
    }
    
    func background(forDate date: Date) -> some View {
        Circle()
            .padding(-6)
            .foregroundColor(foregroundColorForDateCircle(forDate: date))
            .transition(.opacity)
            .animation(.default, value: controller.highlightedDate)
    }
    
    func foregroundColorForDateCircle(forDate date: Date) -> Color {
        guard dateIsHighlightedDate(date) else {
            return Color.clear
        }
        return date.startOfDay == Date().startOfDay ? .accentColor : Color(.label)
    }
    
    func foregroundColor(forDate date: Date) -> Color {
        guard !dateIsHighlightedDate(date) else {
            return date.startOfDay == Date().startOfDay ? .white : Color(.systemBackground)
        }
        return date.isWeekend ? Color(.secondaryLabel) : Color(.label)
    }
}
