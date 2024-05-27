//
//  ActivityPlusApp.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import SwiftUI
import Firebase

@main
struct ActivityPlusApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
