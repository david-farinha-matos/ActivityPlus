//
//  healthManager.swift
//  Fitness App
//
//  Created by David Matos on 06/01/2024.
//

import SwiftUI
import Foundation
import HealthKit
import WidgetKit
import CoreLocation

class healthManager: ObservableObject {
    var healthStore = HKHealthStore()
    @Published var activity: [String: activityCard] = [:]
    @Published var weekOffset: Int = -1
    
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
    var runningStatsThisWeek: [Int: (distance: Double, speed: Double, time: Double, calories: Double, pace: Double)] = [:]
    
    
    
    static let shared = healthManager()
    
    init() {
        requestAuthorization()
    }
    
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
            HKObjectType.quantityType(forIdentifier: .runningPower)!,
            //            HKObjectType.quantityType(forIdentifier: .runningCadence)!,
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
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
        print("////////////////////////////////////////")
        print("Attempting to fetch all Datas")
        readStepCountToday()
        readCalorieCountToday()
        readExerciseMinutesToday()
        readDistanceMovedToday()
        readStepCountThisWeek()
        //        readRunningStatsThisWeek()
        weekOffset -= 1
        
        print("DATAS FETCHED: ")
        print("\(stepCountToday) steps today")
        print("\(caloriesBurnedToday) calories today")
        print("\(exerciseTimeToday) exercise time today")
        print("\(distanceMovedToday) distance moved today")
        print("////////////////////////////////////////")
        print("\(runningStatsThisWeek) : runnings stats this week")
        
        
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
            
            //            let activity = Activity(id: 0, distance: "10", km: "km", speed: "5'00\"", minKm: "min/km", time: "40.0", mins: "min", calories: "460", cals: "cals", image: "figure.run")
            //            DispatchQueue.main.async {
            //                self.activities["todaySteps"] = activity
            //            }
            
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
            
            //            let activity = Activity(id: 0, title: "Active Calories", subtitle: "calories", image: "flame", amount: "\(self.caloriesBurnedToday)")
            //            DispatchQueue.main.async {
            //                self.activities["todayCalories"] = activity
            //            }
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
            
            //            Update the activity dictionary with today's exercise minutes
            //            let activity = Activity(id: 0, title: "Exercise Minutes", subtitle: "minutes", image: "figure.walk", amount: "\(Int(totalExerciseMinutes))")
            //            DispatchQueue.main.async {
            //                self.activities["todayExerciseMinutes"] = activity
            //            }
            //            let activity = activitiesCard(id: 0, imageName: "figure.run", title: "Distance", subtitle: "km", tintColour: Color(.systemGray), amount: "\(Int(totalExerciseMinutes))")
            //            DispatchQueue.main.async {
            //                self.activities2["todayExerciseMinutes"] = activity
            //            }
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
            //            let activity = Activity(id: 0, title: "Distance Moved", subtitle: "meters", image: "figure.walk", amount: "\(Int(distance))")
            //            DispatchQueue.main.async {
            //                self.activities["todayDistanceMoved"] = activity
            //            }
            //            let activity = activitiesCard(id: 0, imageName: "figure.run", title: "Distance:", subtitle: "km", tintColour: Color(.systemGray), amount: "\(Int(distance))")
            //            DispatchQueue.main.async {
            //                self.activities2["todayExerciseMinutes"] = activity
            //            }
        }
        
        healthStore.execute(query)
    }
    
    
    
    
    
    func readStepCountThisWeek() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        let today = calendar.startOfDay(for: Date())
        // Find the start date (Monday) of the current week
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            print("Failed to calculate the start date of the week.")
            return
        }
        // Find the end date (Sunday) of the current week
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            print("Failed to calculate the end date of the week.")
            return
        }
        
        print("Attempting to get step count from \(startOfWeek) to \(endOfWeek)")
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfWeek,
            end: endOfWeek,
            options: .strictStartDate
        )
        
        let query = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { _, result, error in
            guard let result = result else {
                if let error = error {
                    print("An error occurred while retrieving step count: \(error.localizedDescription)")
                }
                return
            }
            
            result.enumerateStatistics(from: startOfWeek, to: endOfWeek) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = Int(quantity.doubleValue(for: HKUnit.count()))
                    let day = calendar.component(.weekday, from: statistics.startDate)
                    DispatchQueue.main.async {
                        self.thisWeekSteps[day] = steps
                    }
                }
            }
            
            print("\(self.thisWeekSteps)")
        }
        healthStore.execute(query)
    }
    
    
    
    func readAllRunningStats() {
        let workoutType = HKObjectType.workoutType()
            
            print("Attempting to get all running stats")
            
            // Use a predicate that retrieves all samples
            let predicate = HKQuery.predicateForWorkouts(with: .running)
            
            let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                guard let workouts = results as? [HKWorkout] else {
                    print("An error occurred while retrieving workouts: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                    return
                }
                
                var newActivities: [String: activityCard] = [:]
                var idCounter = 0
                
                // Date formatter for formatting workout start date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d, yyyy"
                
                for workout in workouts {
                    if workout.workoutActivityType == .running {
                        let formattedDate = dateFormatter.string(from: workout.startDate)
                        let distance = workout.totalDistance?.doubleValue(for: .meter()) ?? 0.0
                        let timeInSeconds = workout.duration
                        let speed = distance / timeInSeconds
                        let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0
                        
                        let formattedDistance = String(format: "%.2f", distance / 1000)
                        let formattedTime = self.convertTime(seconds: timeInSeconds)
                        let formattedSpeed = self.convertSpeedToPace(speed: speed)
                        let formattedCalories = String(format: "%.0f", calories)
                        
                        let activity = activityCard(
                            id: idCounter,
                            date: formattedDate,
                            distance: formattedDistance,
                            time: formattedTime,
                            speed: formattedSpeed,
                            calories: formattedCalories
                        )
                        
                        newActivities["\(workout.startDate)"] = activity
                        idCounter += 1
                    }
                }
                
                DispatchQueue.main.async {
                    self.activity = newActivities
                }
            }
            
            healthStore.execute(query)
        }
    
    func convertSpeedToPace(speed: Double) -> String {
        let speedKmPerHour = speed * 3.6
        let paceMinPerKm = 60 / speedKmPerHour
        
        let minutes = Int(paceMinPerKm)
        let seconds = Int((paceMinPerKm - Double(minutes)) * 60)
        
        return String(format: "%d'%02d\"", minutes, seconds)
    }
    
    func convertTime(seconds: Double) -> String {
        let totalMinutes = Int(seconds / 60)
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", totalMinutes, remainingSeconds)
    }
    
    
    //    func orderedRunningStats() -> [(day: String, distance: Double, speed: Double, time: Double, calories: Double, pace: Double)] {
    //        let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    //        return runningStatsThisWeek.keys.sorted().compactMap { day -> (day: String, distance: Double, speed: Double, time: Double, calories: Double, pace: Double)? in
    //            guard let stats = runningStatsThisWeek[day] else { return nil }
    //            return (daysOfWeek[day - 1], stats.distance, stats.speed, stats.time, stats.calories, stats.pace)
    //        }
    //    }
    
    
    
}


extension healthManager {
    func orderedWeekSteps() -> [(day: String, steps: Int)] {
        let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let sortedSteps = (2...7).map { (dayOfWeek: $0, steps: self.thisWeekSteps[$0, default: 0]) }
        + [(dayOfWeek: 1, steps: self.thisWeekSteps[1, default: 0])]
        
        var stepsData: [(day: String, steps: Int)] = []
        for (index, stepData) in sortedSteps.enumerated() {
            stepsData.append((day: weekDays[index], steps: stepData.steps))
        }
        
        return stepsData
    }
}
