//
//  healthManager.swift
//  ActivityPlus
//
//  Created by David Matos on 19/06/2024.
//

import Foundation
import HealthKit
import WidgetKit


class healthManager: ObservableObject {
    var healthStore = HKHealthStore()
    //    @Published var activities: [String: Activity] = [:]
    
    var stepCountToday: Int = 0
    var stepCountYesterday: Int = 0
    
    var caloriesBurnedToday: Int = 0
    var exerciseTimeToday: Int = 0
    var distanceMovedToday: Double = 0.0
    var thisWeekSteps: [Int: Int] = [1: 0,
                                     2: 0,
                                     3: 0,
                                     4: 0,
                                     5: 0,
                                     6: 0,
                                     7: 0]
    
    
    static let shared = healthManager()
    
    init() {
        requestAuthorization()
    }
    
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.workoutType()
        ])
        guard HKHealthStore.isHealthDataAvailable() else {
            print("health data not available!")
            return
        }
        healthStore.requestAuthorization(toShare: nil, read: toReads) {
            success, error in
            if success {
                print("Auth successful")
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    func fetchAllDatas() {
        print("Attempting to fetch all Datas")
        readStepCountToday()
        readCalorieCountToday()
        readExerciseMinutesToday()
        readDistanceMovedToday()
        
        print("DATAS FETCHED: ")
        print("\(stepCountToday) steps today")
        print("\(caloriesBurnedToday) calories today")
        print("\(exerciseTimeToday) exercise time today")
        print("\(distanceMovedToday) distance moved today")
        
        UserDefaults(suiteName: "group.iWalker")?.set(stepCountToday, forKey: "widgetStep")
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )
        
        //    print("attempting to get step count from \(startDate)")
        
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            print("Fetched your steps today: \(steps)")
            self.stepCountToday = steps
            
            //          let activity = Activity(id: 0, title: "Steps", subtitle: "steps", image: "figure.walk", amount: "\(self.stepCountToday)")
            //          DispatchQueue.main.async {
            //              self.activities["todaySteps"] = activity
            //          }
        }
        
        healthStore.execute(query)
    }
    
    func readCalorieCountToday() {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKSampleQuery(sampleType: calorieType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
            guard let samples = results as? [HKQuantitySample], let firstSample = samples.first else {
                print("No calorie burn samples found.")
                return
            }
            
            // Retrieve the total calories burned for today
            let totalCalories = samples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            
            // Process the total calories burned
            print("Total calories burned today: \(totalCalories) kcal")
            self.caloriesBurnedToday = Int(totalCalories)
            
            //          let activity = Activity(id: 0, title: "Active Calories", subtitle: "calories", image: "flame", amount: "\(self.caloriesBurnedToday)")
            //          DispatchQueue.main.async {
            //              self.activities["todayCalories"] = activity
            //          }
        }
        
        healthStore.execute(query)
    }
    
    
    func readExerciseMinutesToday() {
        let workoutType = HKObjectType.workoutType()
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, _ in
            guard let samples = results as? [HKWorkout] else {
                print("No workout samples found.")
                return
            }
            
            // Calculate the total exercise minutes
            let totalExerciseMinutes = samples.reduce(0.0) { $0 + $1.duration } / 60
            print("Total exercise minutes today: \(totalExerciseMinutes)")
            
            // Update the exerciseTimeToday property
            self.exerciseTimeToday = Int(totalExerciseMinutes)
            
            // Update the activity dictionary with today's exercise minutes
            //              let activity = Activity(id: 0, title: "Exercise Minutes", subtitle: "minutes", image: "figure.walk", amount: "\(Int(totalExerciseMinutes))")
            //              DispatchQueue.main.async {
            //                  self.activities["todayExerciseMinutes"] = activity
            //              }
        }
        
        healthStore.execute(query)
    }
    
    func readDistanceMovedToday() {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to read distance: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let distance = sum.doubleValue(for: HKUnit.meter())
            print("Total distance moved today: \(distance) meters")
            
            // Round the distance to 2 decimal places
            let roundedDistance = ((distance / 1000) * 100).rounded() / 100
            print("Rounded distance: \(roundedDistance) km")
            
            // Update the distanceMovedToday property
            self.distanceMovedToday = roundedDistance
            
            // Update the activity dictionary with today's distance moved
            //              let activity = Activity(id: 0, title: "Distance Moved", subtitle: "meters", image: "figure.walk", amount: "\(Int(distance))")
            //              DispatchQueue.main.async {
            //                  self.activities["todayDistanceMoved"] = activity
            //              }
        }
        
        healthStore.execute(query)
    }
}
