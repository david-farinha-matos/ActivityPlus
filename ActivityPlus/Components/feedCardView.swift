//
//  feedCardView.swift
//  ActivityPlus
//
//  Created by David Matos on 11/07/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct feedCard: Identifiable {
    let id: Int
    let userName: String
    let date: String
    let distance: String
    let time: String
    let speed: String
    let calories: String
    var isImported: Bool = false
}

struct feedCardView: View {
    @State var feed: feedCard
    @ObservedObject var viewModel = importWorkoutViewModel()
    @State private var isImported = false
    
    var body: some View {
        Section(feed.userName) {
            VStack {
                HStack {
                    SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                        .foregroundColor(.green)
                    
                    Text("Date:")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(feed.date)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                HStack {
                    SettingRowView(imageName: "figure.run", title: "Run", tintColour: Color(.systemGray))
                        .foregroundColor(.green)
                        .opacity(0)
                    
                    Text("Distance:")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Text(feed.distance)
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
                    Text(feed.time)
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
                    Text(feed.speed)
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
                    Text(feed.calories)
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                }
                
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    viewModel.isActivityImported(feed.id, forUser: user.uid) { imported in
                        isImported = imported
                    }
                }
            }
        }
    }
}

#Preview {
    feedCardView(feed: feedCard(id: 0, userName: "31fj31f8j", date: "June 4, 2024", distance: "21.11", time: "110", speed: "5:13", calories: "1362"))
}
