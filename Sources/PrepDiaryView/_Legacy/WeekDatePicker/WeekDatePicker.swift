import SwiftUI
import SwiftUIPager

//protocol WeekDatePickerDelegate: AnyObject {
//    func didTapDayButton()
//    func willChangeDate(to newDate: Date)
//    func didChangeDate(to newDate: Date)
//}

struct WeekDatePicker: View {
    let weekdayStrings = ["M", "Tu", "W", "Th", "F", "Sa", "Su"]
    
    let didTapDayButton: () -> ()
    let willChangeDate: ((Date) -> ())?
    let didChangeDate: ((Date) -> ())?
    
    init(
        didTapDayButton: @escaping () -> Void,
        willChangeDate: ((Date) -> Void)? = nil,
        didChangeDate: ((Date) -> Void)? = nil
    ) {
        self.didTapDayButton = didTapDayButton
        self.willChangeDate = willChangeDate
        self.didChangeDate = didChangeDate
    }
}

extension WeekDatePicker {
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                HStack {
                    ForEach(weekdayStrings, id: \.self) { string in
                        Text(string)
                            .frame(maxWidth: .infinity)
                            .font(.footnote)
                            .foregroundColor(foregroundColor(forWeekdayString: string))
                    }
                }
                WeekPager(
                    didTapDayButton: didTapDayButton,
                    willChangeDate: willChangeDate,
                    didChangeDate: didChangeDate
                )
            }
            .padding(.horizontal)
            DayPager(
                didTapDayButton: didTapDayButton,
                willChangeDate: willChangeDate
            )
        }
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
                WeekDatePicker {
                    
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
