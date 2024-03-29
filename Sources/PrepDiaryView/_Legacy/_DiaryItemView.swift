//import SwiftUI
//import SwiftHaptics
//import SwiftUISugar
//import PrepDataTypes
//
//struct DiaryItemView: View {
//
//    @Environment(\.colorScheme) var colorScheme
//
//    //TODO: CoreData
////    @ObservedObject var item: FoodItem
//    var item: FoodItem
//
//    @Namespace var localNamespace
////    let namespace: Namespace.ID
//    var namespace: Binding<SwiftUI.Namespace.ID?>
//
//    var body: some View {
//        HStack {
//            optionalEmojiText
//            nameTexts
//            Spacer()
//            isEatenToggle
//        }
//        .listRowBackground(listRowBackground)
//    }
//
//    var listRowBackgroundColor: Color {
//        if item.isCompleted {
//            return colorScheme == .light ? Color("EBE9F7") : Color("191331")
//        } else {
//            return Color(.secondarySystemGroupedBackground)
//        }
//    }
//    var listRowBackground: some View {
//        Color.white
//            .colorMultiply(listRowBackgroundColor)
//            .animation(.default, value: item.isCompleted)
//    }
//
//
//    var isEatenToggle: some View {
//        Button {
//            withAnimation {
//                //TODO: Bring this back
////                Store.shared.toggleCompletionForFoodItem(item)
//            }
//            Haptics.feedback(style: .soft)
//        } label: {
//            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle.dotted")
//        }
//        .foregroundColor(item.isCompleted ? .accentColor : Color(.tertiaryLabel))
//        .buttonStyle(.borderless)
//    }
//
//    @ViewBuilder
//    var optionalEmojiText: some View {
//        Text(item.food.emoji)
//            .font(.body)
//            .if(namespace.wrappedValue != nil) { view in
//                view.matchedGeometryEffect(id: item.id.uuidString, in: namespace.wrappedValue!)
//            }
//            .if(namespace.wrappedValue == nil) { view in
//                view.matchedGeometryEffect(id: "\(item.id.uuidString)2", in: localNamespace)
//            }
//    }
//
//    var nameColor: Color {
//        guard let meal = item.meal else {
//            return Color(.secondaryLabel)
//        }
//        return meal.isNextPlannedMeal ? Color(.label) : Color(.secondaryLabel)
//    }
//
//    var amountColor: Color {
//        guard let meal = item.meal else {
//            return Color(.quaternaryLabel)
//        }
//        return meal.isNextPlannedMeal ? Color(.secondaryLabel) : Color(.quaternaryLabel)
//    }
//
//    var nameTexts: some View {
//        var view = Text(item.food.name)
//            .font(.body)
//            .fontWeight(.semibold)
//            .foregroundColor(nameColor)
//        if let detail = item.food.detail {
//            view = view
//            + Text(", ")
//                .font(.callout)
//                .foregroundColor(Color(.secondaryLabel))
//            + Text(detail)
//                .font(.callout)
//                .foregroundColor(Color(.secondaryLabel))
//        }
//        if let brand = item.food.brand {
//            view = view
//            + Text(", ")
//                .font(.callout)
//                .foregroundColor(Color(.tertiaryLabel))
//            + Text(brand)
//                .font(.callout)
//                .foregroundColor(Color(.tertiaryLabel))
//        }
//        view = view
//        + Text(" • ").foregroundColor(Color(.secondaryLabel))
//        + Text(item.amountString(withDetails: false, parentMultiplier: 1))
//
//        .font(.callout)
//        .fontWeight(.semibold)
//        .foregroundColor(amountColor)
//
//        return view
//    }
//}
//
//
