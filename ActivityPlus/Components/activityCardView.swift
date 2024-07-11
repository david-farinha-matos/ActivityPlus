//
//  activityCardView.swift
//  ActivityPlus
//
//  Created by David Matos on 26/06/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct activityCard: Identifiable {
    let id: Int
    let date: String
    let distance: String
    let time: String
    let speed: String
    let calories: String
    var isImported: Bool = false
}

struct activityCardView: View {
    @State var activity: activityCard
    @ObservedObject var viewModel = importWorkoutViewModel()
    @State private var isImported = false
    
    var body: some View {
        VStack {
            HStack {
                SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                    .foregroundColor(.green)
                
                Text("Date:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(activity.date)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                
                if isImported {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        viewModel.saveWorkout(activity: activity) { success in
                            if success {
                                isImported = true
                            }
                        }
                    }) {
                        HStack {
                            Text("Import")
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                    }
                }
                
            }
            HStack {
                SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                    .foregroundColor(.green)
                    .opacity(0)
                
                Text("Distance:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(activity.distance)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("km")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                
            }
            HStack {
                SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                    .foregroundColor(.green)
                    .opacity(0)
                
                Text("Time:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(activity.time)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("mins")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                
            }
            HStack {
                SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                    .foregroundColor(.green)
                    .opacity(0)
                
                Text("Pace:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(activity.speed)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("/km")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
                
            }
            HStack {
                SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                    .foregroundColor(.green)
                    .opacity(0)
                
                Text("Calories:")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text(activity.calories)
                    .font(.subheadline)
                    .foregroundColor(.black)
                Spacer()
            }
            
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                viewModel.isActivityImported(activity.id, forUser: user.uid) { imported in
                    isImported = imported
                }
            }
        }
    }
}

#Preview {
    activityCardView(activity: activityCard(id: 0, date: "June 4, 2024", distance: "21.11", time: "110", speed: "5:13", calories: "1362"))
}
