import SwiftUI
import SwiftUIPager

//protocol WeekDatePickerDelegate: AnyObject {
//    func didTapDayButton()
//    func willChangeDate(to newDate: Date)
//    func didChangeDate(to newDate: Date)
//}

struct WeekDatePicker: View {
    let weekdayStrings = ["M", "Tu", "W", "Th", "F", "Sa", "Su"]
    
    let startingDate: Date
    let didTapDayButton: () -> ()
    let willChangeDate: ((Date) -> ())?
    let didChangeDate: ((Date) -> ())?
    
    let debugNotification = NotificationCenter.default.publisher(for: .debugNotification)
    
    @State var refreshBool: Bool = false
    
    init(
        currentDate: Date,
        didTapDayButton: @escaping () -> Void,
        willChangeDate: ((Date) -> Void)? = nil,
        didChangeDate: ((Date) -> Void)? = nil
    ) {
        self.startingDate = currentDate
        self.didTapDayButton = didTapDayButton
        self.willChangeDate = willChangeDate
        self.didChangeDate = didChangeDate
    }
}

extension WeekDatePicker {
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                weekdayHeadings
                weekPager
            }
            .padding(.horizontal)
            dayPager
        }
        .onReceive(debugNotification) { notification in
//            refreshBool.toggle()
        }
    }
    
    var weekdayHeadings: some View {
        HStack {
            ForEach(weekdayStrings, id: \.self) { string in
                Text(string)
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .foregroundColor(foregroundColor(forWeekdayString: string))
            }
        }
    }
    
    var weekPager: some View {
        WeekPager(
            currentDate: startingDate,
            didTapDayButton: didTapDayButton,
            willChangeDate: willChangeDate,
            didChangeDate: didChangeDate
        )
        .id(refreshBool)
    }
    
    var dayPager: some View {
        DayPager(
            currentDate: startingDate,
            didTapDayButton: didTapDayButton,
            willChangeDate: willChangeDate
        )
    }
    
    func foregroundColor(forWeekdayString string: String) -> Color {
        string == "Sa" || string == "Su" ? Color(.secondaryLabel) : Color(.label)
    }
}

extension Date {
    var dayString: String {
        let calendar = Calendar.autoupdatingCurrent
        let day = calendar.component(.day, from: self)
        return "\(day)"
    }
    
    var isWeekend: Bool {
        let calendar = Calendar.autoupdatingCurrent
        let weekday = calendar.component(.weekday, from: self)
        return weekday == 1 || weekday == 7 /// Saturday or Sunday
    }
}

struct DiaryDateView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            VStack(spacing: 0) {
                WeekDatePicker(currentDate: Date()) {
                    
                }
                Spacer()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}
