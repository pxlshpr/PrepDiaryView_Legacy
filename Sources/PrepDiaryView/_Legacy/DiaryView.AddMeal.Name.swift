//import SwiftUI
//import SwiftUIFlowLayout
//
//extension DiaryView.AddMeal {
//    struct Name: View {
//        @EnvironmentObject var diaryController: DiaryView.Controller
//        @Environment(\.dismiss) var dismiss
//        @FocusState var isFocused: Bool?
//        @Binding var name: String
//    }
//}
//
//extension DiaryView.AddMeal.Name {
//    var body: some View {
//        scrollView
//    }
//    
//    var scrollView: some View {
//        ScrollView {
//            LazyVStack(spacing: 0) {
//                textField
//                    .formElementStyle()
//                if Store.recentMealNames.count > 0 {
//                    Text("Recently Used")
//                        .formSectionHeaderStyle()
//                    recentSuggestions
//                        .formElementStyle()
//                }
//                Text("Presets")
//                    .formSectionHeaderStyle()
//                presetSuggestions
//                    .formElementStyle()
//            }
//        }
//        .background(Color(.systemGroupedBackground))
//    }
//    
//    var textField: some View {
//        TextField("", text: $name)
//            .focused($isFocused, equals: true)
//            .submitLabel(.done)
//            .onSubmit {
////                collapseDetentAndDimiss()
//                dismiss()
//            }
//    }
//    
//    var recentSuggestions: some View {
//        FlowLayout(mode: .scrollable, items: Store.recentMealNames.sorted{$0<$1}, itemSpacing: 4) {
//            button(forSuggestion: $0)
//        }
//    }
//
//    var presetSuggestions: some View {
//        FlowLayout(mode: .scrollable, items: PresetMealNameSuggestions, itemSpacing: 4) {
//            button(forSuggestion: $0)
//        }
//    }
//
//    func collapseDetentAndDimiss() {
////        diaryController.collapseAddMealDetent()
//        dismiss()
//    }
//    
//    func button(forSuggestion string: String) -> some View {
//        Button {
//            name = string
//            dismiss()
////            collapseDetentAndDimiss()
//        } label: {
//            Text(string)
//              .foregroundColor(Color(.secondaryLabel))
//              .padding(.vertical, 6)
//              .padding(.horizontal, 8)
//              .background(
//                RoundedRectangle(cornerRadius: 5.0)
//                      .fill(Color(.secondarySystemFill))
//              )
//        }
//    }
//}
