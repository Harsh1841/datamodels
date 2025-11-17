//
//  CallSession.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.


import Foundation

struct CallSession: Identifiable, Equatable, Codable {
    let id: UUID
    // current user
    let participantOneID: UUID
    let participantTwoID: UUID?
    var suggestedQuestions: [String]? = nil
    var isConnected: Bool = false
    var interests: [Interest] = []
    var gender: Gender  = .any
    var englishLevel : EnglishLevel = .beginner
    var startedAt: Date
    var endedAt: Date?
    var feedback: SessionFeedback?
    init(participantOneID: UUID, participantTwoID: UUID, user: User, startedAt: Date = Date(), endedAt: Date? = nil, feedback: SessionFeedback? = nil, interests: [Interest], gender: Gender, englishLevel: EnglishLevel) {
        self.id = UUID()
        self.participantOneID = participantOneID
        self.participantTwoID = participantTwoID
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.feedback = feedback
        self.suggestedQuestions = nil
        self.interests = interests
        self.gender = gender
        self.englishLevel = englishLevel
    }
    
    static func ==(lhs: CallSession, rhs: CallSession) -> Bool {
        return lhs.id == rhs.id
    }
}
