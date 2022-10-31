import Foundation

extension DiaryView.Summary.PageView {
    
    class ViewModel: ObservableObject {
        
        var date: Date

        @Published var energy: Double? = nil
        
        init(date: Date) {
            self.date = date
        }
    }
}

extension DiaryView.Summary.PageView.ViewModel {
    
    func fetchData() {
    }
}
