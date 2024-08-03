//
//  MyWorkoutsView.swift
//  ActivityPlus
//
//  Created by David Matos on 25/06/2024.
//

import SwiftUI

struct MyWorkoutsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var manager: healthManager
    @StateObject private var importViewModel = importWorkoutViewModel()
    @State private var showImportView = false
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6) // Set the desired light gray background color here
                .edgesIgnoringSafeArea(.all)
            
            if let user = viewModel.currentUser {
                List {
                    Section {
                        VStack {
                            HStack {
                                Image("DavidPicture")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 100, height: 100)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Good Morning \(user.firstName)")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .padding(.top, 4)
                                    
                                    Text("Let's Smash Today")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .padding(.top, 4)
                                    
                                    HStack {
                                        VStack {
                                            Text("3")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Text("Followers")
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        VStack {
                                            Text("5")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Text("Following")
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .foregroundColor(.black)
                                }
                                .foregroundColor(.accentColor)
                            }
                            
                            
                            Divider()
                            
                            Button(action: {
                                // Action to perform when button is tapped
                                print("Button tapped")
                                // You can perform navigation or other actions here
                                showImportView.toggle()
                            }) {
                                HStack {
                                    Text("Import Workout")
                                        .foregroundColor(Color(red: 0.275, green: 0.235, blue: 1))
                                        .fontWeight(.bold)
//                                    Spacer()
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .foregroundColor(Color(red: 0.275, green: 0.235, blue: 1))
                                }
                            }
                        }
                    }
                    Section("My Workouts") {
                        ForEach(importViewModel.importedWorkouts) { workout in
                            activityCardView(activity: workout)
                        }
                    }
                }
                .onAppear {
                    importViewModel.fetchImportedWorkouts()
                }
            }
        }
        .fullScreenCover(isPresented: $showImportView) {
            importWorkoutView()
        }
    }
}

#Preview {
    MyWorkoutsView()
}
