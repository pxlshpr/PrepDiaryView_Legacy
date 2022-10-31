import SwiftUI
import SwiftHaptics
import PrepDataTypes

extension DiaryView.ListPage {
    struct MealView: View {
        @EnvironmentObject var diaryController: DiaryView.Controller
        @StateObject var viewModel: ViewModel
        let namespace: Namespace.ID

        init(meal: Meal, namespace: Namespace.ID) {
            _viewModel = StateObject(wrappedValue: ViewModel(meal: meal))
            self.namespace = namespace
        }
    }
}

extension DiaryView.ListPage.MealView {

    var body: some View {
        Section {
            Header(
                viewModel: viewModel,
                namespace: namespace
            )
            .environmentObject(diaryController)
            ForEach(viewModel.foodItems) { item in
                DiaryItemView(
                    item: item,
                    namespace: namespace
                )
            }
            Footer(meal: viewModel.meal)
                .environmentObject(diaryController)
        }
//        .onChange(of: viewModel.meal) { newValue in
//            viewModel.mealDidChange()
//        }
    }
}
