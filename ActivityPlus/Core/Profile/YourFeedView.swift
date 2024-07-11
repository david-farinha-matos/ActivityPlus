//
//  YourFeedView.swift
//  ActivityPlus
//
//  Created by David Matos on 19/06/2024.
//

import SwiftUI

struct YourFeedView: View {
    @StateObject private var viewModel = YourFeedViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.workouts) { workout in
                Section(workout.userName) {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                                .foregroundColor(.green)
                            
                            Text("Date:")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text(workout.date)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            
                            Spacer()
                        }
                        HStack {
                            SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                                .foregroundColor(.green)
                                .opacity(0)
                            
                            Text("Distance:")
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Text(workout.distance)
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
                            Text(workout.time)
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
                            Text(workout.speed)
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
                            Text(workout.calories)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                }
//                .padding(.vertical, 4)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Your Feed")
                        .foregroundColor(Color(red: 0.275, green: 0.235, blue: 1))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            
        }
        .onAppear {
            viewModel.fetchAllWorkoutsExcludingCurrentUser()
        }
    }
}

//struct activityCard: Identifiable {
//    let id: Int
//    let date: String
//    let distance: String
//    let time: String
//    let speed: String
//    let calories: String
//    var isImported: Bool = false
//}

#Preview {
    YourFeedView()
}
