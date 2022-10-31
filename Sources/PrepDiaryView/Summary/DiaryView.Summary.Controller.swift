import SwiftUI

enum SummaryViewType: Int, CaseIterable {
    case completed = 0
    case planned
    
    var title: String {
        switch self {
        case .completed:
            return "Eaten"
        case .planned:
            return "Prepped"
        }
    }
    
    var remainingTitle: String {
        switch self {
        case .completed:
            return "To Eat"
        case .planned:
            return "To Prep"
        }
    }
    
    var systemImage: String {
        switch self {
        case .completed:
            return "checkmark"
        case .planned:
            return "calendar.badge.clock"
        }
    }
}

extension DiaryView.Summary {
    class Controller: ObservableObject {
        
        weak var delegate: DiaryViewSummaryDelegate?
        
        @Published var diaryPagerController: DiaryView.Pager.Controller

//        @Published var gaugesGridRowViewModels: [GaugesGrid.Row.ViewModel] = []

        @Published var viewType: SummaryViewType = .completed
//        @Published var showingEaten = true
        @Published var showingDetails = false
        
        //TODO: Replace with actual values
        @Published var haveGoal: Bool = true
        
        init(diaryPagerController: DiaryView.Pager.Controller, delegate: DiaryViewSummaryDelegate? = nil) {
            self.diaryPagerController = diaryPagerController
            self.delegate = delegate
        }
    }
}

extension DiaryView.Summary.Controller {
}
