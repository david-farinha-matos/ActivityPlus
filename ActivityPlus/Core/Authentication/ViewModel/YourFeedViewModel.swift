//
//  YourFeedViewModel.swift
//  ActivityPlus
//
//  Created by David Matos on 11/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class YourFeedViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var workouts: [feedCard] = []

    init() {
        fetchAllWorkoutsExcludingCurrentUser()
    }

    func fetchAllWorkoutsExcludingCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user logged in.")
            return
        }

        db.collection("workouts").whereField("userID", isNotEqualTo: currentUserID)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching workouts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found.")
                    return
                }

                var userIDs: [String] = []
                for document in documents {
                    let data = document.data()
                    if let userID = data["userID"] as? String {
                        userIDs.append(userID)
                    }
                }

                self.fetchUsers(userIDs: userIDs) { usersDict in
                                // Configure the date formatter for the specific date format
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM d, yyyy"

                                // Sort the documents by date in descending order before mapping to feedCard
                                let sortedDocuments = documents.sorted {
                                    guard
                                        let date1String = $0.data()["date"] as? String,
                                        let date2String = $1.data()["date"] as? String,
                                        let date1 = dateFormatter.date(from: date1String),
                                        let date2 = dateFormatter.date(from: date2String)
                                    else {
                                        return false
                                    }
                                    return date1 > date2
                                }

                                self.workouts = sortedDocuments.compactMap { document -> feedCard? in
                                    let data = document.data()
                                    guard
                                        let id = data["id"] as? Int,
                                        let userID = data["userID"] as? String,
                                        let date = data["date"] as? String,
                                        let distance = data["distance"] as? String,
                                        let time = data["time"] as? String,
                                        let speed = data["speed"] as? String,
                                        let calories = data["calories"] as? String
                                    else {
                                        print("Data parsing error for document: \(document.documentID)")
                                        return nil
                                    }

                                    let userName = usersDict[userID] ?? "Unknown User"
                                    return feedCard(id: id, userName: userName, date: date, distance: distance, time: time, speed: speed, calories: calories, isImported: true)
                                }
                            }
            }
    }


    private func fetchUsers(userIDs: [String], completion: @escaping ([String: String]) -> Void) {
        var usersDict: [String: String] = [:]
        let group = DispatchGroup()

        for userID in userIDs {
            group.enter()
            db.collection("users").document(userID).getDocument { document, error in
                defer { group.leave() }

                if let error = error {
                    print("Error fetching user with ID \(userID): \(error.localizedDescription)")
                    return
                }

                guard let document = document, document.exists, let data = document.data() else {
                    print("Document does not exist or data is missing for user with ID \(userID)")
                    return
                }

                let firstName = data["firstName"] as? String ?? ""
                let lastName = data["surname"] as? String ?? ""
                let fullName = "\(firstName) \(lastName)"
                usersDict[userID] = fullName
            }
        }

        group.notify(queue: .main) {
            completion(usersDict)
        }
    }
}
