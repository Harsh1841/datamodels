//
//  JamSessionRepository.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
final class JamSessionRepository {

    static let shared = JamSessionRepository()
    private init() {}

    private var sessions: [JamSession] = []  // later replace with Firebase
  

    // CREATE
    func create(_ session: JamSession) {
        sessions.append(session)
    }

    // READ
    func getAll() -> [JamSession] {
        return sessions
    }

    func getById(_ id: UUID) -> JamSession? {
        return sessions.first { $0.id == id }
    }

    // UPDATE
    func update(_ updated: JamSession) {
        if let index = sessions.firstIndex(where: { $0.id == updated.id }) {
            sessions[index] = updated
        }
    }

    // DELETE
    func delete(_ id: UUID) {
        sessions.removeAll { $0.id == id }
    }
  func onCompletedSession(){
        // make activity object for jam, and use history repository to save it
        let activity = Activity( type: .jam, date: Date())
        HistoryRepository.shared.addActivity(activity)
    }
   
}
