import SwiftUI
import Timeline
import PrepDataTypes

extension DiaryView {
    struct TimelinePage: View {
        
        @Environment(\.managedObjectContext) private var viewContext
        @EnvironmentObject var diaryController: DiaryView.Controller
        
        let namespace: Namespace.ID
        
        //TODO: CoreData
//        @FetchRequest private var meals: FetchedResults<Meal>
        var meals: [Meal]
        var timelineItems: [TimelineItem]
        
        var date: Date
    }
}

extension DiaryView.TimelinePage {
    
    init(date: Date = Date(), namespace: Namespace.ID) {
        self.date = date
        self.namespace = namespace
        
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
        Timeline(items: timelineItems, matchedGeometryNamespace: namespace)
            .background(Color(.systemGroupedBackground))
    }

//    var timelineItems: [TimelineItem] {
//        Store.timelineItems(for: date)
//    }
}
