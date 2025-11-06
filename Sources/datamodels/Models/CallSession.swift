//
//  CallSession.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct CallSession: Identifiable, Codable {
    let id: UUID
    let participantOneID: UUID
    let participantTwoID: UUID
    var suggestedQuestions: [String]? = nil
    let user : User
    var isConnected: Bool = false

    var startedAt: Date
    var endedAt: Date?

    var feedback: SessionFeedback?
    init(participantOneID: UUID, participantTwoID: UUID, user: User, startedAt: Date = Date(), endedAt: Date? = nil, feedback: SessionFeedback? = nil) {
        self.id = UUID()
        self.participantOneID = participantOneID
        self.participantTwoID = participantTwoID
        self.user = user
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.feedback = feedback
        self.suggestedQuestions = nil
    }
}
