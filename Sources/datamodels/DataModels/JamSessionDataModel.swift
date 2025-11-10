//
//  JamSessionDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class JamSessionDataModel {
    
    static let shared = JamSessionDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var jamSessions: [JamSession] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("jamSessions").appendingPathExtension("plist")
        loadJamSessions()
    }
    
    // MARK: - Public Methods
    
    func getAllJamSessions() -> [JamSession] {
        return jamSessions
    }
    
    func addJamSession(_ jamSession: JamSession) {
        jamSessions.append(jamSession)
        saveJamSessions()
    }
    
    func updateJamSession(_ jamSession: JamSession) {
        if let index = jamSessions.firstIndex(where: { $0.id == jamSession.id }) {
            jamSessions[index] = jamSession
            saveJamSessions()
        }
    }
    
    func deleteJamSession(at index: Int) {
        jamSessions.remove(at: index)
        saveJamSessions()
    }
    
    func deleteJamSession(by id: UUID) {
        jamSessions.removeAll(where: { $0.id == id })
        saveJamSessions()
    }
    
    func getJamSession(by id: UUID) -> JamSession? {
        return jamSessions.first(where: { $0.id == id })
    }
    
    // MARK: - Private Methods
    
    private func loadJamSessions() {
        if let savedJamSessions = loadJamSessionsFromDisk() {
            jamSessions = savedJamSessions
        } else {
            jamSessions = loadSampleJamSessions()
        }
    }
    
    private func loadJamSessionsFromDisk() -> [JamSession]? {
        guard let codedJamSessions = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([JamSession].self, from: codedJamSessions)
    }
    
    private func saveJamSessions() {
        let propertyListEncoder = PropertyListEncoder()
        let codedJamSessions = try? propertyListEncoder.encode(jamSessions)
        try? codedJamSessions?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleJamSessions() -> [JamSession] {
        // Return empty array as sample - jam sessions require actual user data
        return []
    }
}

