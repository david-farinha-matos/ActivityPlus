//
//  ProfileView.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(user.firstName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.surname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                    .padding(.leading, -4)
                            }
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("General") {
                    HStack {
                        SettingRowView(imageName: "gear", title: "Version", tintColour: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                }
                
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingRowView(imageName: "rectangle.portrait.and.arrow.right", title: "Sign Out", tintColour: .red)
                    }
                    Button {
                        print("Delete Account...")
                    } label: {
                        SettingRowView(imageName: "xmark.circle", title: "Delete Account", tintColour: .red)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
