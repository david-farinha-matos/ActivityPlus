//
//  User.swift
//  ActivityPlus
//
//  Created by David Matos on 27/05/2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let surname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        let components = PersonNameComponents(givenName: firstName, familyName: surname)
            formatter.style = .abbreviated
            return formatter.string(from: components)
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, firstName: "Kobe", surname: "Bryant", email: "test@email.com")
}
