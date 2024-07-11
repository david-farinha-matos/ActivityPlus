//
//  importWorkoutView.swift
//  ActivityPlus
//
//  Created by David Matos on 04/07/2024.
//

import SwiftUI

struct importWorkoutView: View {
    @EnvironmentObject var manager: healthManager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6) // Set the desired light gray background color here
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button("      "){
                        
                    }
                    Spacer()
                    Text("Import Workout")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                }
                .padding(.horizontal)
                
                List {
                    
                    Section("Select Your Workouts") {
                        ForEach(manager.activity.sorted(by: { $0.key > $1.key }), id: \.key) { item in
                            activityCardView(activity: item.value)
                        }
                    }
                    .onAppear {
                        manager.readStepCountToday()
                        manager.readCalorieCountToday()
                        manager.readExerciseMinutesToday()
                        manager.readDistanceMovedToday()
                        manager.readStepCountThisWeek()
                        manager.readAllRunningStats()
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    importWorkoutView()
}
