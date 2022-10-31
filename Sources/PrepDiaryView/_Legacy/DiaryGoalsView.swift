import SwiftUI
//import Charts

struct TdeeSegments {
    let array: [TdeeSegment]
    
    var kcal: Int {
        array.reduce(0) { $0 + $1.value }
    }
}

struct DiaryGoalsView: View {
    
    @State var date: Date = Date()
    
    @State var selectedProfile: String = "Recomposition"
    @State var selectedMacrosData: MacrosData = macrosDataRecomposition
    @State var toggleIncludeWorkouts = false
    @State var includeWorkouts = false
    @State var tdeeSegments: TdeeSegments = TdeeSegments(array: tdeeSegmentsWithoutWorkouts)

    var body: some View {
        VStack {
            Spacer().frame(height: 5)
            chartView
                .padding(.horizontal)
            list
        }
        .navigationTitle("Daily Goal")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedProfile) { newValue in
            withAnimation {
                selectedMacrosData = profiles.first(where: { $0.0 == newValue })!.1
            }
        }
        .onChange(of: toggleIncludeWorkouts) { newValue in
            withAnimation {
                includeWorkouts = toggleIncludeWorkouts
                let array = includeWorkouts ? tdeeSegmentsWithWorkouts : tdeeSegmentsWithoutWorkouts
                tdeeSegments = TdeeSegments(array: array)
            }
        }
    }
    
    var chartView: some View {
        DiaryGoalsChartView(
            data: $selectedMacrosData,
            tdeeSegments: $tdeeSegments
        )
    }
    
    var profiles: [(String, MacrosData)] = [
        ("Maintenance", macrosDataMaintenance),
        ("Recomposition", macrosDataRecomposition),
        ("Cheat Day", macrosDataCheatDay),
        ("Cutting", macrosDataCutting),
        ("Bulking", macrosDataBulking),
        ("Ketogenic", macrosDataKetogenic),
    ]
    
    var list: some View {
        Form {
            goalSection
            workoutsSection
        }
    }
    
    var goalSection: some View {
        Section("Goal") {
            Picker(selection: $selectedProfile, label: Text("Selected")) {
                ForEach(profiles, id: \.self.0) { profile in
                    Text(profile.0)
                }
            }
            Button {
            } label: {
                Text("Manage Goals")
            }
            .buttonStyle(.borderless)
        }
    }
    
    var workoutsSection: some View {
        Section("Workouts") {
            NavigationLink {
                
            } label: {
                HStack {
                    Text("Selected")
                    Spacer()
                    Text("3/3")
                        .foregroundColor(.secondary)
                }
            }
            Toggle("Add to allowance", isOn: $toggleIncludeWorkouts)
            if includeWorkouts {
                distributeCaloriesCell
                    .transition(.slide)
            }
        }
    }
    
    var distributeCaloriesCell: some View {
        NavigationLink {
        } label: {
            distributeCaloriesCellLabel
        }
    }
    
    var distributeCaloriesCellLabel: some View {
        HStack {
            Text("Macro Distribution")
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Carbs and Fat")
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.trailing)
                Text("With Goal Ratios")
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 7.0)
                            .fill(Color(.secondarySystemFill))
                    )
            }
        }
    }
    
    var list_toBeMoved: some View {
        List {
            Section("Diet Profile") {
                ForEach(profiles, id: \.self.0) { profile in
                    Button {
                        withAnimation(.easeOut) {
                            selectedMacrosData = profile.1
                        }
                    } label: {
                        HStack {
                            Label(profile.0, systemImage: selectedMacrosData == profile.1 ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(profile.1.kcal) kcal")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.borderless)
                }
                Button {
                } label: {
                    Text("Manage Profiles")
                }
                .buttonStyle(.borderless)
            }
            Section("Workouts") {
                HStack {
                    Text("Walking")
                    Spacer()
                    Text("55 kcal")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Traditional Strength Training")
                    Spacer()
                    Text("340 kcal")
                        .foregroundColor(.secondary)
                }
                Button {
                    
                } label: {
                    Text("Add Workout")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

let macrosDataMaintenance = MacrosData(macros: [
    .init(macro: .carb, kcal: 1055),
    .init(macro: .fat, kcal: 670),
    .init(macro: .protein, kcal: 880)
])

let macrosDataRecomposition = MacrosData(macros: [
    .init(macro: .carb, kcal: 1200),
    .init(macro: .fat, kcal: 810),
    .init(macro: .protein, kcal: 880)
])

let macrosDataCheatDay = MacrosData(macros: [
    .init(macro: .carb, kcal: 1500),
    .init(macro: .fat, kcal: 900),
    .init(macro: .protein, kcal: 1100)
])

let macrosDataCutting = MacrosData(macros: [
    .init(macro: .carb, kcal: 400),
    .init(macro: .fat, kcal: 210),
    .init(macro: .protein, kcal: 880)
])

let macrosDataBulking = MacrosData(macros: [
    .init(macro: .carb, kcal: 2200),
    .init(macro: .fat, kcal: 1310),
    .init(macro: .protein, kcal: 1380)
])

let macrosDataKetogenic = MacrosData(macros: [
    .init(macro: .carb, kcal: 520),
    .init(macro: .fat, kcal: 1800),
    .init(macro: .protein, kcal: 1250)
])
