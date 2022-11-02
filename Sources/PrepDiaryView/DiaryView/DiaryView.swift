import SwiftUI
import PrepDataTypes

public struct DiaryView<ActionButton: View, MenuButton: View, BottomCenterView: View>: View {
//public struct DiaryView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var controller: DiaryController
    @StateObject var pagerController: DiaryPager.Controller
    
    @State private var showingGoalPicker = false
    @State private var showingAddMenu = false
    @State private var showingBarcodeScanner = false

    let actionButton: ActionButton
    let menuButton: MenuButton
    let bottomCenterView: BottomCenterView

    let getMealsHandler: GetMealsHandler
    let tappedAddMealsHandler: EmptyHandler
    
    public init(
        getMealsHandler: @escaping GetMealsHandler,
        tappedAddMealsHandler: @escaping EmptyHandler,
        actionButton: ActionButton,
        menuButton: MenuButton,
        bottomCenterView: BottomCenterView
    ) {
        self.getMealsHandler = getMealsHandler
        self.tappedAddMealsHandler = tappedAddMealsHandler
        self.actionButton = actionButton
        self.menuButton = menuButton
        self.bottomCenterView = bottomCenterView
        
        let pagerController = DiaryPager.Controller()
        _pagerController = StateObject(wrappedValue: pagerController)
        _controller = StateObject(wrappedValue: DiaryController(pagerController: pagerController))
    }
    
    public var body: some View {
        navigationView
    }
    
    var navigationView: some View {
        NavigationView {
            VStack(spacing: 0) {
                weekDatePicker
                Divider()
                pager
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { bottomToolbarContent }
            .toolbar { navigationLeadingContent }
            .toolbar { navigationTrailingContent }
            .sheet(isPresented: $controller.showingDatePicker) { datePicker }
        }
    }
    
    var datePicker: some View {
        DatePickerView(date: pagerController.currentDate)
            .presentationDetents([.medium, .large])
    }
    
    var weekDatePicker: some View {
        WeekDatePicker(delegate: controller)
            //TODO: DatePicker
//            .environmentObject(controller)
//            .environmentObject(pagerController)
    }
    
    var pager: some View {
        DiaryPager(
            getMealsHandler: getMealsHandler,
            tapAddMealHandler: tappedAddMealsHandler
        )
            .environmentObject(controller)
            .environmentObject(pagerController)
            .onChange(of: pagerController.currentDate) { newValue in
                //TODO: Send this as a notification if not doing so already and update meter
//                updateMeter()
            }
    }
    
    var listViewButton: some View {
        Button {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            withAnimation() {
                controller.isListView.toggle()
            }
        } label: {
            Image(systemName: controller.viewChangeImageName)
        }
    }

    //MARK: - Toolbars
    
    var navigationTrailingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            TodayButton()
                .environmentObject(pagerController)
        }
    }
    
    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            menuButton
        }
    }
    
    var bottomToolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            ZStack {
                HStack {
                    listViewButton
                    Spacer()
                }
                HStack {
                    Spacer()
                    actionButton
                }
                HStack {
                    Spacer()
                    bottomCenterView
                    Spacer()
                }
            }
        }
    }
}
