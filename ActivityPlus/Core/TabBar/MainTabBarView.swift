//
//  MainTabBarView.swift
//  ActivityPlus
//
//  Created by David Matos on 29/05/2024.
//

import SwiftUI

struct MainTabBarView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Temp")
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
            
            Text("Temp")
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                }
                .tag(1)
            
            Text("Temp")
                .tabItem {
                    Image(systemName: "trophy.fill")
                }
                .tag(2)
            
            //Text("Temp")
            ActivityLogView()
                .tabItem {
                    Image(systemName: "target")
                }
                .tag(3)
            
            //Text("Profile")
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(4)
            
        }
        .accentColor(Color(red: 0.275, green: 0.235, blue: 1))
        .onAppear {
            selectedTab = 4 // set profile to the start up view
        }
    }
}

#Preview {
    MainTabBarView()
}
