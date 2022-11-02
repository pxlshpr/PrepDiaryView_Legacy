import SwiftUI
import SwiftUIPager
import SwiftHaptics
import PrepDataTypes

class DiaryController: ObservableObject {
    
    struct AddMealDetent {
        static let collapsed: PresentationDetent = .height(400)
        static let timeSettings: PresentationDetent = .height(450)
    }
    
    let pagerController: DiaryPagerController
    
    @Published var mealToAddFoodTo: Meal? = nil
    @Published var mealToEdit: Meal? = nil
    
    @Published var mealToShowChartsFor: Meal? = nil
    @Published var dayToShowChartsFor: Day? = nil

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

    init(pagerController: DiaryPagerController) {
        self.pagerController = pagerController
        addNotificationObservers()
    }
}

extension DiaryController {
    func addNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didPickRestoreFile),
//            name: .didPickRestoreFile, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didRestoreBackupFile),
//            name: .didRestoreBackupFile, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didZipBackupFiles),
//            name: .didZipBackupFiles, object: nil)
    }
}

extension DiaryController {
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

extension DiaryController: DiaryViewSummaryDelegate {
    func didShowDatePicker() {
        selectedSummaryDetent = .large
    }
}
