//
//  CallSessionRepository.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

//
//  CallSessionRepository.swift
//  OpenTone
//

import Foundation

@MainActor

final class CallSessionRepository {

    static let shared = CallSessionRepository()
    private init() {}

    private var sessions: [CallSession] = []

    // CREATE
    func createSession(_ session: CallSession) {
        sessions.append(session)
    }

    // READ
    func getAllSessions() -> [CallSession] {
        return sessions
    }

    func getSession(by id: UUID) -> CallSession? {
        return sessions.first(where: { $0.id == id })
    }

    // UPDATE
    func updateSession(_ updatedSession: CallSession) {
        if let index = sessions.firstIndex(where: { $0.id == updatedSession.id }) {
            sessions[index] = updatedSession
        }
    }

    // DELETE
    func deleteSession(by id: UUID) {
        sessions.removeAll(where: { $0.id == id })
    }

    // Suggest Questions
    func addSuggestedQuestions(to sessionID: UUID, questions: [String]) {
        if let index = sessions.firstIndex(where: { $0.id == sessionID }) {
            sessions[index].suggestedQuestions = questions
        }
    }

    func onCompletedSession(){
        // make activity object for call, and use history repository to save it
        let activity = Activity( type: .call, date: Date())
        HistoryRepository.shared.addActivity(activity)
    }
}