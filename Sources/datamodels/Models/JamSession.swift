//
//  JamSession.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation


struct JamSession: Identifiable, Equatable, Codable {
    private var topics: [String] = [
        "The Future of Technology",
        "Climate Change and Its Impact",
        "The Role of Art in Society",
        "Exploring Space: The Next Frontier",
        "The Evolution of Education"
    ]   

    let id: UUID
    let userId: String

    let topic: String
    var phase: JamPhase

    var startedPrepAt: Date?
    var startedSpeakingAt: Date?
    var endedAt: Date?

    var transcript: String?     
    var feedback: SessionFeedback?

    
    init(userId: String, phase: JamPhase, startedPrepAt: Date? = nil, startedSpeakingAt: Date? = nil, endedAt: Date? = nil, transcript: String? = nil, feedback: SessionFeedback? = nil) {
        self.id = UUID()
        self.userId = userId
        self.topic = topics.randomElement() ?? "General Topic"
        self.phase = phase
        self.startedPrepAt = startedPrepAt
        self.startedSpeakingAt = startedSpeakingAt
        self.endedAt = endedAt
        self.transcript = transcript
        self.feedback = feedback
    }
    
    static func ==(lhs: JamSession, rhs: JamSession) -> Bool {
        return lhs.id == rhs.id
    }
}
