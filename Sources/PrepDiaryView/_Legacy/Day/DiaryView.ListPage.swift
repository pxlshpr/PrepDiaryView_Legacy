import SwiftUI
import SwiftUISugar
import SwiftHaptics
import PrepDataTypes

extension DiaryView {
    struct ListPage: View {
        
        @Environment(\.managedObjectContext) private var viewContext
        @EnvironmentObject var diaryController: DiaryView.Controller
        
        //TODO: CoreData
//        @FetchRequest private var meals: FetchedResults<Meal>
        var meals: [Meal]
        
        var date: Date
        let namespace: Namespace.ID
    }
}

extension DiaryView.ListPage {
    
    init(date: Date = Date(), namespace: Namespace.ID) {
        self.date = date
        
        //TODO: CoreData
        self.meals = []
        self.namespace = namespace
//        let predicate: NSPredicate
//        if let day = Store.shared.day(forDate: date) {
//            predicate = NSPredicate(format: "day = %@", day)
//        } else {
//            predicate = NSPredicate(format: "time = 0")
//        }
//
//        _meals = FetchRequest<Meal>(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Meal.time, ascending: true)],
//            predicate: predicate,
//            animation: .default
//        )
    }
    
    var body: some View {
        list
    }
    
    var list: some View {
        List {
            ForEach(meals) { meal in
                DiaryView.ListPage.MealView(
                    meal: meal,
                    namespace: namespace
                )
                .environmentObject(diaryController)
            }
            if !meals.isEmpty {
                Spacer().frame(height: 20)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemGroupedBackground))
            }
            addMealButton
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }
    
    var addMealButton: some View {
        Section {
            Button {
                diaryController.showingAddMeal = true
            } label: {
                Text("Add Meal")
                Spacer()
            }
            .buttonStyle(.borderless)
            .listRowSeparator(.hidden)
            .listRowBackground(
                ListRowBackground(
                    color: Color(.secondarySystemGroupedBackground),
                    includeTopSeparator: true,
                    includeBottomSeparator: true
                )
            )
        }
    }
}

