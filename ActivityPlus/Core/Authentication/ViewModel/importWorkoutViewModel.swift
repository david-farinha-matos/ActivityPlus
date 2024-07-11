//
//  importWorkoutViewModel.swift
//  ActivityPlus
//
//  Created by David Matos on 04/07/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class importWorkoutViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var importedWorkouts: [activityCard] = []
    
    init() {
        fetchImportedWorkouts()
    }
    
//    func fetchImportedWorkouts() {
//            guard let user = Auth.auth().currentUser else {
//                print("No user logged in.")
//                return
//            }
//
//            let db = Firestore.firestore()
//            let workoutsRef = db.collection("users").document(user.uid).collection("workouts")
//
//            workoutsRef.getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching imported workouts: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let snapshot = snapshot else {
//                    print("No snapshot found.")
//                    return
//                }
//
//                print("Snapshot found: \(snapshot.documents.count) documents")
//                
//                var idCounter = -1
//
//                let workouts = snapshot.documents.compactMap { document -> activityCard? in
//                    let data = document.data()
//                    print("Fetched document data: \(data)") // Debug print
//                    
//                    if let speed = data["speed"],
//                       let distance = data["distance"],
//                       let date = data["date"],
//                       let time = data["time"],
//                       let calories = data["calories"] {
//                        
//                        // Print or use these strings as needed
//                        print("Speed: \(speed)")
//                        print("Distance: \(distance)")
//                        print("Date: \(date)")
//                        print("Time: \(time)")
//                        print("Calories: \(calories)")
//                        
//                    } else {
//                        print("Error: Unable to extract all values from data dictionary")
//                    }
//                    
//                    guard
//                        let date = data["date"] as? String,
//                        let distance = data["distance"] as? String,
//                        let time = data["time"] as? String,
//                        let speed = data["speed"] as? String,
//                        let calories = data["calories"] as? String
//                        //let id = document.documentID
//                    else {
//                        print("Data parsing error for document: \(document.documentID)")
//                        return nil
//                    }
//                    idCounter += 1
//                    return activityCard(id: idCounter, date: date, distance: distance, time: time, speed: speed, calories: calories)
//                    
//                }
//                
//                DispatchQueue.main.async {
//                    print("Fetched workouts: \(workouts)") // Debug print
//                    self.importedWorkouts = workouts
//                }
//            }
//        }
    
    
    func fetchImportedWorkouts() {
            guard let user = Auth.auth().currentUser else {
                print("No user logged in.")
                return
            }

            let workoutsCollectionRef = db.collection("workouts")
            let query = workoutsCollectionRef.whereField("userID", isEqualTo: user.uid)

            query.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching imported workouts: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("No snapshot found.")
                    return
                }

                print("Snapshot found: \(snapshot.documents.count) documents")
                
                var idCounter = -1

                let workouts = snapshot.documents.compactMap { document -> activityCard? in
                    let data = document.data()
                    print("Fetched document data: \(data)") // Debug print
                    
                    guard
                        let date = data["date"] as? String,
                        let distance = data["distance"] as? String,
                        let time = data["time"] as? String,
                        let speed = data["speed"] as? String,
                        let calories = data["calories"] as? String,
                        let id = data["id"] as? Int
                    else {
                        print("Data parsing error for document: \(document.documentID)")
                        return nil
                    }
                    
                    return activityCard(id: id, date: date, distance: distance, time: time, speed: speed, calories: calories, isImported: true)
                }
                
                DispatchQueue.main.async {
                    print("Fetched workouts: \(workouts)") // Debug print
                    self.importedWorkouts = workouts
                }
            }
        }


        
        func importWorkout(activity: activityCard) {
            guard let user = Auth.auth().currentUser else { return }
            let db = Firestore.firestore()
            let workoutRef = db.collection("users").document(user.uid).collection("workouts").document("\(activity.id)")

            let data: [String: Any] = [
                "id": activity.id,
                "date": activity.date,
                "distance": activity.distance,
                "time": activity.time,
                "speed": activity.speed,
                "calories": activity.calories
            ]

            workoutRef.setData(data) { error in
                if let error = error {
                    print("Error importing workout: \(error.localizedDescription)")
                } else {
                    print("Workout imported successfully")
                }
            }
        }


    
//    func saveWorkout(activity: activityCard, completion: @escaping (Bool) -> Void) {
//        guard let user = Auth.auth().currentUser else {
//            print("No user is logged in")
//            completion(false)
//            return
//        }
//        
//        let workoutData: [String: Any] = [
//            "date": activity.date,
//            "distance": activity.distance,
//            "time": activity.time,
//            "speed": activity.speed,
//            "calories": activity.calories
//        ]
//        
//        let userDocRef = db.collection("users").document(user.uid)
//        
//        userDocRef.collection("workouts").addDocument(data: workoutData) { error in
//            if let error = error {
//                print("Error saving workout: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                print("Workout saved successfully")
//                self.addImportedActivityID(activity.id, forUser: user.uid) { success in
//                    completion(success)
//                }
//            }
//        }
//    }
    
    func saveWorkout(activity: activityCard, completion: @escaping (Bool) -> Void) {
            guard let user = Auth.auth().currentUser else {
                print("No user is logged in")
                completion(false)
                return
            }

            let workoutData: [String: Any] = [
                "id": activity.id,
                "userID": user.uid,
                "date": activity.date,
                "distance": activity.distance,
                "time": activity.time,
                "speed": activity.speed,
                "calories": activity.calories
            ]

            let workoutsCollectionRef = db.collection("workouts")

            workoutsCollectionRef.addDocument(data: workoutData) { error in
                if let error = error {
                    print("Error saving workout: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Workout saved successfully")
                    completion(true)
                }
            }
        }

    
    private func addImportedActivityID(_ activityID: Int, forUser userID: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("users").document(userID)
        
        userDocRef.updateData([
            "importedActivities": FieldValue.arrayUnion([activityID])
        ]) { error in
            if let error = error {
                print("Error updating imported activities: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
//    func isActivityImported(_ activityID: Int, forUser userID: String, completion: @escaping (Bool) -> Void) {
//        let userDocRef = db.collection("users").document(userID)
//        
//        userDocRef.getDocument { document, error in
//            if let error = error {
//                print("Error fetching user document: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            
//            guard let document = document, document.exists,
//                  let data = document.data(),
//                  let importedActivities = data["importedActivities"] as? [Int] else {
//                completion(false)
//                return
//            }
//            
//            completion(importedActivities.contains(activityID))
//        }
//    }
    
    
    func isActivityImported(_ activityID: Int, forUser userID: String, completion: @escaping (Bool) -> Void) {
            let workoutsCollectionRef = db.collection("workouts")
            let query = workoutsCollectionRef.whereField("userID", isEqualTo: userID).whereField("id", isEqualTo: activityID)

            query.getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking imported workouts: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let snapshot = snapshot else {
                    print("No snapshot found.")
                    completion(false)
                    return
                }

                completion(!snapshot.documents.isEmpty)
            }
        }
    }
