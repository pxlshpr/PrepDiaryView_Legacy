import SwiftUI
import SwiftUIPager
import SwiftHaptics
import PrepDataTypes

extension DiaryView {
    class Controller: ObservableObject {
        
        struct AddMealDetent {
            static let collapsed: PresentationDetent = .height(400)
            static let timeSettings: PresentationDetent = .height(450)
        }
        
        let pagerController: Pager.Controller
        
        @Published var mealToAddFoodTo: Meal? = nil
        @Published var mealToEdit: Meal? = nil
        
        @Published var mealToShowChartsFor: Meal? = nil
        @Published var dayToShowChartsFor: Day? = nil

        @Published var showingDatePicker = false
        @Published var showingAddMeal = false
        @Published var showingSettings = false

        @Published var isListView = true
        
        @Published var addMealDetent: PresentationDetent = AddMealDetent.collapsed
        
        @Published var selectedSummaryDetent: PresentationDetent = .medium {
            didSet {
                if selectedSummaryDetent == .medium {
                    NotificationCenter.default.post(name: .diarySummaryDetentChangedToMedium, object: nil)
                }
            }
        }
        
        @Published var presentationDetents: Set<PresentationDetent> = [AddMealDetent.collapsed, .large]
        
        var restoreFilePickDate: Date = Date()

        init(pagerController: Pager.Controller) {
            self.pagerController = pagerController
            addNotificationObservers()
        }
    }
}

extension DiaryView.Controller {
    func addNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didPickRestoreFile),
//            name: .didPickRestoreFile, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didRestoreBackupFile),
//            name: .didRestoreBackupFile, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didZipBackupFiles),
//            name: .didZipBackupFiles, object: nil)
    }
}

extension DiaryView.Controller {
    var viewChangeImageName: String {
        isListView ? timelineImageName : listImageName
    }
    
    var timelineImageName: String {
        "calendar.day.timeline.left"
    }
    
    var listImageName: String {
//        "list.bullet.rectangle"
        "checklist"
    }
}

extension DiaryView.Controller: WeekDatePickerDelegate {
    func didTapDayButton() {
        Haptics.feedback(style: .rigid)
        showingDatePicker = true
    }
    
    func willChangeDate(to newDate: Date) {
        print("willChangeDate(to: \(newDate)")
    }
    
    func didChangeDate(to newDate: Date) {
        print("didChangeDate(to: \(newDate)")
    }
}

extension DiaryView.Controller: DiaryViewSummaryDelegate {
    func didShowDatePicker() {
        selectedSummaryDetent = .large
    }
}
