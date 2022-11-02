import SwiftUI
import SwiftUISugar
import SwiftHaptics
import PrepDataTypes

public typealias GetMealsHandler = ((Date) async throws -> [Meal])

struct ListPage: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var diaryController: DiaryController
    
    @State var meals: [Meal] = []
    
    var date: Date
    let namespace: Namespace.ID
    
    let getMealsHandler: GetMealsHandler
    let tapAddMealHandler: EmptyHandler
    
    let didAddMeal = NotificationCenter.default.publisher(for: .didAddMeal)
    let didUpdateMeals = NotificationCenter.default.publisher(for: .didUpdateMeals)
    
    init(date: Date = Date(),
         getMealsHandler: @escaping GetMealsHandler,
         tapAddMealHandler: @escaping EmptyHandler,
         namespace: Namespace.ID
    ) {
        self.date = date
        self.getMealsHandler = getMealsHandler
        self.namespace = namespace
        self.tapAddMealHandler = tapAddMealHandler
    }
    
    var body: some View {
        list
    }
    
    var list: some View {
        List {
            ForEach(meals) { meal in
                MealView(
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
        .onAppear(perform: appeared)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .onReceive(didAddMeal, perform: didAddMeal)
        .onReceive(didUpdateMeals, perform: didUpdateMeals)
    }
    
    func didAddMeal(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let meal = userInfo[Notification.Keys.meal] as? Meal,
              meal.day.calendarDayString == self.date.calendarDayString
        else {
            return
        }
        getMeals()
    }
    
    func didUpdateMeals(notification: Notification) {
        getMeals()
    }
    
    func appeared() {
        getMeals(animated: false)
    }
    
    func getMeals(animated: Bool = true) {
        Task {
            do {
                let meals = try await getMealsHandler(date)
                await MainActor.run {
                    let sortedMeals = meals.sorted(by: { $0.time < $1.time })
                    if animated {
                        withAnimation {
                            self.meals = sortedMeals
                        }
                    } else {
                        self.meals = sortedMeals
                    }
                }
            } catch {
                print("Error getting meals for: \(date)")
            }
        }
    }
    
    var addMealButton: some View {
        Section {
            Button {
                tapAddMealHandler()
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
