//
//  ActivityLogView.swift
//  ActivityPlus
//
//  Created by David Matos on 19/06/2024.
//

import Foundation
import SwiftUI

struct ActivityLogView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var manager: healthManager
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6) // Set the desired light gray background color here
                .edgesIgnoringSafeArea(.all)
            
            if let user = viewModel.currentUser {
                List {
                    Section {
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
                    }
                    
                    Section {
                        VStack {
                            DialView(goal: 10_000, steps: manager.stepCountToday)
                                .padding()
                            
                            Divider()
     
                            HStack(spacing: 30) {
                                StatTile(image: "flame", value: String(manager.caloriesBurnedToday), measurement: "Cals")
                                StatTile(image: "clock", value: String(manager.exerciseTimeToday), measurement: "Mins")
                                StatTile(image: "point.bottomleft.forward.to.point.topright.scurvepath", value: String(manager.distanceMovedToday), measurement: "Km")
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct StatTile: View {

    let image: String
    let value: String
    let measurement: String

    var body: some View {
        VStack {
            Image(systemName: image)
            Text(value)
                .font(.title)
            Text(measurement)
        }
        .foregroundColor(.accentColor)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15).fill(Color.white)
                .shadow(color: .foregroundGray, radius: 10)
        )
    }

}

#Preview {
    ActivityLogView()
}

extension Color {

    static let backgroundGray = Color(red: 0.922, green: 0.925, blue: 0.941)
    static let foregroundGray = Color(red: 0.871, green: 0.871, blue: 0.871)
}
