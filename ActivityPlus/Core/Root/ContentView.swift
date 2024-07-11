//
//  ContentView.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var manager: healthManager
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabBarView()
                    .environmentObject(manager)
            } else {
                LoginView()
            }
            //                }
            //                .onAppear {
            //                    if let userSession = viewModel.userSession {
            //                        print("User session is: \(userSession)")
            //                    } else {
            //                        print("User session is nil")
            //                    }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(healthManager.shared)
    }
}
