import SwiftUI
import SwiftHaptics
import PrepDataTypes

struct MealView: View {
    @EnvironmentObject var diaryController: DiaryController
    @StateObject var viewModel: ViewModel
    let namespace: Namespace.ID

    init(meal: Meal, namespace: Namespace.ID) {
        _viewModel = StateObject(wrappedValue: ViewModel(meal: meal))
        self.namespace = namespace
    }

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
