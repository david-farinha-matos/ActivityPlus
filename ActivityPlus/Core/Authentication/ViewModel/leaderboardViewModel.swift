//
//  leaderboardViewModel.swift
//  ActivityPlus
//
//  Created by David Matos on 11/07/2024.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

class leaderboardViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var workouts: [feedCard] = []
    @Published var totalDistances: [String: (firstName: String, lastName: String, distance: Double)] = [:]
    @Published var timeRemaining: String = ""
    
    private var timer: AnyCancellable?
    
    
    init() {
        fetchNumberOfUsers()
        fetchTotalDistanceForEachUser()
        fetchAllWorkoutsIncludingCurrentUser()
        startCountdown()
    }
    
    func startCountdown() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
    }
    
    private func updateTimeRemaining() {
        let calendar = Calendar.current
        let now = Date()
        
        // Find next Sunday midnight
        let nextSunday = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: 1), matchingPolicy: .nextTime)!
        
        // Calculate the difference
        let diff = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: nextSunday)
        
        if let day = diff.day, let hour = diff.hour, let minute = diff.minute, let second = diff.second {
            timeRemaining = String(format: "%02d:%02d:%02d:%02d", day, hour, minute, second)
        }
    }
    
    func fetchTotalDistances() {
            let db = Firestore.firestore()
            
            db.collection("workouts").getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No documents found.")
                    return
                }
                
                var distances: [String: Double] = [:]
                
                // Step 1: Fetching user details for each workout
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard let userID = data["userID"] as? String else {
                        print("Invalid userID format for document \(document.documentID)")
                        continue
                    }
                    
                    guard let distanceString = data["distance"] as? String,
                          let distance = Double(distanceString) else {
                        print("Invalid distance format for document \(document.documentID)")
                        continue
                    }
                    
                    // Accumulate distance for each user
                    if let currentDistance = distances[userID] {
                        distances[userID] = currentDistance + distance
                    } else {
                        distances[userID] = distance
                    }
                }
                
                // Step 2: Fetching user names and mapping to totalDistances
                var updatedDistances: [String: (firstName: String, lastName: String, distance: Double)] = [:]
                let group = DispatchGroup()
                
                for (userID, distance) in distances {
                    group.enter()
                    
                    db.collection("users").document(userID).getDocument { (userDocument, userError) in
                        defer { group.leave() }
                        
                        if let userError = userError {
                            print("Error fetching user document for \(userID): \(userError.localizedDescription)")
                            return
                        }
                        
                        guard let userDocument = userDocument, userDocument.exists else {
                            print("User document does not exist for \(userID)")
                            return
                        }
                        
                        let data = userDocument.data()!
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["surname"] as? String ?? ""
                        
                        updatedDistances[userID] = (firstName: firstName, lastName: lastName, distance: distance)
                    }
                }
                
                group.notify(queue: .main) {
                    self.totalDistances = updatedDistances
                }
            }
        }

    
    func fetchNumberOfUsers() {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("No documents found.")
                return
            }

            print("Number of users: \(snapshot.documents.count)")
        }
    }
    
    func fetchTotalDistanceForEachUser() {
        let db = Firestore.firestore()
        
        db.collection("workouts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No documents found.")
                return
            }
            
            var totalDistanceDict: [String: Double] = [:] // Dictionary to store total distance for each user
            
            for document in snapshot.documents {
                let data = document.data()
                
                guard let userID = data["userID"] as? String else {
                    print("Invalid userID format for document \(document.documentID)")
                    continue
                }
                
                guard let distanceString = data["distance"] as? String else {
                    print("Invalid distance format for document \(document.documentID)")
                    continue
                }
                
                // Convert distanceString to Double
                guard let distance = Double(distanceString) else {
                    print("Unable to convert distance to Double for document \(document.documentID)")
                    continue
                }
                
                // Accumulate distance for each user
                if let currentDistance = totalDistanceDict[userID] {
                    totalDistanceDict[userID] = currentDistance + distance
                } else {
                    totalDistanceDict[userID] = distance
                }
            }
            
            // Print or use the total distances
            for (userID, totalDistance) in totalDistanceDict {
                print("Total distance run for user \(userID): \(totalDistance) meters")
            }
        }
    }



    
    
    func fetchAllWorkoutsIncludingCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user logged in.")
            return
        }
        
        db.collection("workouts").whereField("userID", in: [currentUserID, "otherUserID"])
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
