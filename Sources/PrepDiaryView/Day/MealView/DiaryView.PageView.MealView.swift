import SwiftUI
import SwiftHaptics
import PrepDataTypes

extension DiaryView.ListPage {
    struct MealView: View {
        @EnvironmentObject var diaryController: DiaryView.Controller
        @StateObject var viewModel: ViewModel

        init(meal: Meal) {
            _viewModel = StateObject(wrappedValue: ViewModel(meal: meal))
        }
    }
}

extension DiaryView.ListPage.MealView {

    var body: some View {
        Section {
            Header(viewModel: viewModel)
                .environmentObject(diaryController)
            ForEach(viewModel.foodItems) { item in
                DiaryItemView(item: item)
            }
            Footer(meal: viewModel.meal)
                .environmentObject(diaryController)
        }
//        .onChange(of: viewModel.meal) { newValue in
//            viewModel.mealDidChange()
//        }
    }
}
