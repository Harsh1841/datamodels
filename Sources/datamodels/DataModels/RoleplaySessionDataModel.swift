//
//  RoleplaySessionDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class RoleplaySessionDataModel {
    
    static let shared = RoleplaySessionDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var roleplaySessions: [RoleplaySession] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("roleplaySessions").appendingPathExtension("plist")
        loadRoleplaySessions()
    }
    

    
    func getAllRoleplaySessions() -> [RoleplaySession] {
        return roleplaySessions
    }
    
    func addRoleplaySession(_ roleplaySession: RoleplaySession) {
        roleplaySessions.append(roleplaySession)
        saveRoleplaySessions()
    }
    
    func updateRoleplaySession(_ roleplaySession: RoleplaySession) {
        if let index = roleplaySessions.firstIndex(where: { $0.id == roleplaySession.id }) {
            roleplaySessions[index] = roleplaySession
            saveRoleplaySessions()
        }
    }
    
    func deleteRoleplaySession(at index: Int) {
        roleplaySessions.remove(at: index)
        saveRoleplaySessions()
    }
    
    func deleteRoleplaySession(by id: UUID) {
        roleplaySessions.removeAll(where: { $0.id == id })
        saveRoleplaySessions()
    }
    
    func getRoleplaySession(by id: UUID) -> RoleplaySession? {
        return roleplaySessions.first(where: { $0.id == id })
    }
    
 
    
    private func loadRoleplaySessions() {
        if let savedRoleplaySessions = loadRoleplaySessionsFromDisk() {
            roleplaySessions = savedRoleplaySessions
        } else {
            roleplaySessions = loadSampleRoleplaySessions()
        }
    }
    
    private func loadRoleplaySessionsFromDisk() -> [RoleplaySession]? {
        guard let codedRoleplaySessions = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([RoleplaySession].self, from: codedRoleplaySessions)
    }
    
    private func saveRoleplaySessions() {
        let propertyListEncoder = PropertyListEncoder()
        let codedRoleplaySessions = try? propertyListEncoder.encode(roleplaySessions)
        try? codedRoleplaySessions?.write(to: archiveURL)
    }
    
    private func loadSampleRoleplaySessions() -> [RoleplaySession] {
        let session1 = RoleplaySession(
            title: "Grocery Shopping",
            category: .groceryShopping,
            predefinedScript: ["Hello, I'd like to buy some apples.", "How much do they cost?"],
            userMessages: [],
            status: .notStarted
        )
        
        let session2 = RoleplaySession(
            title: "Job Interview",
            category: .interview,
            predefinedScript: ["Tell me about yourself.", "What are your strengths?"],
            userMessages: [],
            status: .notStarted
        )
        
        let session3 = RoleplaySession(
            title: "Restaurant Order",
            category: .restaurant,
            predefinedScript: ["I'd like to order a pizza.", "What toppings do you have?"],
            userMessages: [],
            status: .notStarted
        )
        
        return [session1, session2, session3]
    }
}

