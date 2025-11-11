//
//  CallSessionDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class CallSessionDataModel {
    
    static let shared = CallSessionDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var callSessions: [CallSession] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("callSessions").appendingPathExtension("plist")
        loadCallSessions()
    }
    
    // MARK: - Public Methods
    
    func getAllCallSessions() -> [CallSession] {
        return callSessions
    }
    
    func addCallSession(_ callSession: CallSession) {
        callSessions.append(callSession)
        saveCallSessions()
    }
    
    func updateCallSession(_ callSession: CallSession) {
        if let index = callSessions.firstIndex(where: { $0.id == callSession.id }) {
            callSessions[index] = callSession
            saveCallSessions()
        }
    }
    
    func deleteCallSession(at index: Int) {
        callSessions.remove(at: index)
        saveCallSessions()
    }
    
    func deleteCallSession(by id: UUID) {
        callSessions.removeAll(where: { $0.id == id })
        saveCallSessions()
    }
    
    func getCallSession(by id: UUID) -> CallSession? {
        return callSessions.first(where: { $0.id == id })
    }
    
    func addSuggestedQuestions(to sessionID: UUID, questions: [String]) {
        if let index = callSessions.firstIndex(where: { $0.id == sessionID }) {
            callSessions[index].suggestedQuestions = questions
            saveCallSessions()
        }
    }
    
    // MARK: - Private Methods
    
    private func loadCallSessions() {
        if let savedCallSessions = loadCallSessionsFromDisk() {
            callSessions = savedCallSessions
        } else {
            callSessions = loadSampleCallSessions()
        }
    }
    
    private func loadCallSessionsFromDisk() -> [CallSession]? {
        guard let codedCallSessions = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([CallSession].self, from: codedCallSessions)
    }
    
    private func saveCallSessions() {
        let propertyListEncoder = PropertyListEncoder()
        let codedCallSessions = try? propertyListEncoder.encode(callSessions)
        try? codedCallSessions?.write(to: archiveURL)
    }
    
    private func loadSampleCallSessions() -> [CallSession] {
        // Return empty array as sample - call sessions require actual user data
        return []
    }
}

