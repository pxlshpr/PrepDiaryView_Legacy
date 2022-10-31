import SwiftUI
import Timeline
import PrepDataTypes

extension DiaryView {
    struct TimelinePage: View {
        @Environment(\.managedObjectContext) private var viewContext
        @EnvironmentObject var diaryController: DiaryView.Controller
        
        //TODO: CoreData
//        @FetchRequest private var meals: FetchedResults<Meal>
        var meals: [Meal]
        var timelineItems: [TimelineItem]
        
        var date: Date
    }
}

extension DiaryView.TimelinePage {
    
    init(date: Date = Date()) {
        self.date = date
        
        //TODO: CoreData
        meals = []
        timelineItems = []
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
//        timelineItems = Store.timelineItems(for: date)

    }

    var body: some View {
        timeline
    }

    var timeline: some View {
        Timeline(items: timelineItems)
            .background(Color(.systemGroupedBackground))
    }

//    var timelineItems: [TimelineItem] {
//        Store.timelineItems(for: date)
//    }
}
