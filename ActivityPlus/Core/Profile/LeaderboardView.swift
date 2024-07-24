//
//  LeaderboardView.swift
//  ActivityPlus
//
//  Created by David Matos on 11/07/2024.
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = leaderboardViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Time remaining until new league week:")
                        .font(.headline)
                    Text("\(viewModel.timeRemaining)")
                        .font(.headline)
                }
                List {
                    Section(header: HStack {
                        Image(systemName: "shield.fill")
                            .foregroundColor(Color(red: 0.830, green: 0.690, blue: 0.22))
                        Text("Gold League")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.830, green: 0.690, blue: 0.22))
                        Spacer()
                    }.padding(.vertical, 5)) {
                        ForEach(Array(viewModel.totalDistances.sorted(by: { $0.value.distance > $1.value.distance }).enumerated()), id: \.offset) { index, element in
                            let (userID, values) = element
                            let position = index + 1
                            let xpPoints = Int(values.distance * 50.0) // Calculate XP points (1 km = 50 XP)
                            
                            if position == 6 {
                                HStack {
                                    Spacer()
                                    Image(systemName: "arrowshape.up.fill")
                                        .foregroundColor(.green)
                                    Text("Promotion Zone")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    Image(systemName: "arrowshape.up.fill")
                                        .foregroundColor(.green)
                                    Spacer()
                                }
                            }
                            
                            HStack {
                                Text("\(position).")
                                Text("\(values.firstName) \(values.lastName)")
                                Spacer()
                                Text("\(xpPoints) XP")
                            }
                            
                            if position == 10 {
                                HStack {
                                    Spacer()
                                    Image(systemName: "arrowshape.down.fill")
                                        .foregroundColor(.red)
                                    Text("Demotion Zone")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    Image(systemName: "arrowshape.down.fill")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    Section("Rewards") {
                        VStack {
                            HStack {
                                Image(systemName: "medal.fill")
                                    .foregroundColor(Color(red: 0.830, green: 0.690, blue: 0.22))
                                Text("1st Finisher")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by coming first in your league")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "medal.fill")
                                    .foregroundColor(Color(red: 0.753, green: 0.753, blue: 0.753))
                                Text("2nd Finisher")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by coming second in your league")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "medal.fill")
                                    .foregroundColor(Color(red: 0.808, green: 0.537, blue: 0.275))
                                Text("3rd Finisher")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by coming third in your league")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(Color(red: 0.808, green: 0.537, blue: 0.275))
                                Text("Distance Achiever")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 50km ran total!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(Color(red: 0.753, green: 0.753, blue: 0.753))
                                Text("Distance Warrior")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 100km ran total!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(Color(red: 0.830, green: 0.690, blue: 0.22))
                                Text("Distance Master")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 200km ran total!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.green)
                                Text("£5 Gift Voucher")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Finish in promotion zone to achieve £5 gift voucher for your university cafe!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "mountain.2.circle.fill")
                                    .foregroundColor(Color(red: 0.808, green: 0.537, blue: 0.275))
                                Text("Workouts Achiever")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 50 workouts complete!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "mountain.2.circle.fill")
                                    .foregroundColor(Color(red: 0.753, green: 0.753, blue: 0.753))
                                Text("Workouts Warrior")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 100 workouts complete!")
                                Spacer()
                            }
                        }
                        VStack {
                            HStack {
                                Image(systemName: "mountain.2.circle.fill")
                                    .foregroundColor(Color(red: 0.830, green: 0.690, blue: 0.22))
                                Text("Workouts Master")
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Image(systemName: "medal.fill")
                                    .opacity(0)
                                Text("Achieve this by reaching 200 workouts complete!")
                                Spacer()
                            }
                        }
                    }
                }
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Leaderboards")
                            .foregroundColor(Color(red: 0.275, green: 0.235, blue: 1))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchTotalDistances()
        }
    }
}



#Preview {
    LeaderboardView()
}

