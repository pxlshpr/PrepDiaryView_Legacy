import SwiftUI

extension Summary {
    class Controller: ObservableObject {
        
        weak var delegate: DiaryViewSummaryDelegate?
        
        @Published var diaryPagerController: DiaryPagerController

//        @Published var gaugesGridRowViewModels: [GaugesGrid.Row.ViewModel] = []

        @Published var viewType: SummaryViewType = .completed
//        @Published var showingEaten = true
        @Published var showingDetails = false
        
        //TODO: Replace with actual values
        @Published var haveGoal: Bool = true
        
        init(diaryPagerController: DiaryPagerController, delegate: DiaryViewSummaryDelegate? = nil) {
            self.diaryPagerController = diaryPagerController
            self.delegate = delegate
        }
    }
}

extension Summary.Controller {
}
