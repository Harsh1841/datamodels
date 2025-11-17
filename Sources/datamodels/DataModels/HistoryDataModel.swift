//
//  HistoryDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class HistoryDataModel {
    
    static let shared = HistoryDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var activities: [Activity] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("history").appendingPathExtension("plist")
        loadHistory()
    }
    

    
    func getAllActivities() -> [Activity] {
        return activities
    }
    
    func addActivity(_ activity: Activity) {
        activities.append(activity)
        saveHistory()
    }
    
    func updateActivity(_ activity: Activity) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
            saveHistory()
        }
    }
    
    func deleteActivity(at index: Int) {
        activities.remove(at: index)
        saveHistory()
    }
    
    func deleteActivity(by id: UUID) {
        activities.removeAll(where: { $0.id == id })
        saveHistory()
    }
    
    func getActivity(by id: UUID) -> Activity? {
        return activities.first(where: { $0.id == id })
    }
    
    func searchHistory(by type: ActivityType) -> [Activity] {
        return activities.filter { $0.type == type }
    }
    
   
    
    private func loadHistory() {
        if let savedActivities = loadHistoryFromDisk() {
            activities = savedActivities
        } else {
            activities = loadSampleActivities()
        }
    }
    
    private func loadHistoryFromDisk() -> [Activity]? {
        guard let codedActivities = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([Activity].self, from: codedActivities)
    }
    
    private func saveHistory() {
        let propertyListEncoder = PropertyListEncoder()
        let codedActivities = try? propertyListEncoder.encode(activities)
        try? codedActivities?.write(to: archiveURL)
    }
    
    private func loadSampleActivities() -> [Activity] {
        let activity1 = Activity(type: .call, date: Date().addingTimeInterval(-86400))
        let activity2 = Activity(type: .jam, date: Date().addingTimeInterval(-172800))
        let activity3 = Activity(type: .roleplay, date: Date().addingTimeInterval(-259200))
        
        return [activity1, activity2, activity3]
    }
}

