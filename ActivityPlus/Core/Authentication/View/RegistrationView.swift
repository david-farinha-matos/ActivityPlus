//
//  RegistrationView.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var firstName = ""
    @State private var surname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Image
                Image("runningLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .padding(.vertical, 10)
                
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $firstName, title: "First Name", placeholder: "Enter Your First Name")
                    
                    InputView(text: $surname, title: "Surname", placeholder: "Enter Your Surname")
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter Password", isSecureField: true)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm Your Password", isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email, password: password, firstName: firstName, surname: surname)
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsVaild)
                .opacity(formIsVaild ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsVaild: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 7
        && confirmPassword == password
        && !firstName.isEmpty
        && !surname.isEmpty
    }
}

#Preview {
    RegistrationView()
}
