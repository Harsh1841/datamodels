//
//  RoleplaySessionRepository.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

//
//  RoleplaySessionRepository.swift
//  OpenTone
//

import Foundation

@MainActor
final class RoleplaySessionRepository {

    static let shared = RoleplaySessionRepository()
    private init() {}

    private var sessions: [RoleplaySession] = []

    // CREATE
    func createSession(_ session: RoleplaySession) {
        sessions.append(session)
    }

    // READ
    func getAllSessions() -> [RoleplaySession] {
        return sessions
    }

    func getSession(by id: UUID) -> RoleplaySession? {
        return sessions.first(where: { $0.id == id })
    }

    // UPDATE
    func updateSession(_ updatedSession: RoleplaySession) {
        if let index = sessions.firstIndex(where: { $0.id == updatedSession.id }) {
            sessions[index] = updatedSession
        }
    }

    // DELETE
    func deleteSession(by id: UUID) {
        sessions.removeAll(where: { $0.id == id })
    }

      func onCompletedSession(){
        // make activity object for roleplay, and use history repository to save it
        let activity = Activity(type: .roleplay, date: Date())
        HistoryRepository.shared.addActivity(activity)
    }
}
