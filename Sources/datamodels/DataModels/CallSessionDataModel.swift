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
    
    /*
        Find a match for the current user, based on the interests, gender and english level
        Parameters: CallSession object for interets, gender and english level
        Return:
            Returns UUID of matched peer, nil in case of no match found
    */
    func findMatch(callSession: CallSession) -> UUID? {
        // get all online users near the current user
        // filter users based on these 3 things
        // return user id if found, otherwise nil
        return nil
    }
    
    
    func getParticipantDetails(participantID: UUID){
            // get participant bio
            // get participant name
            // get participant image
            // get shared interests
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

