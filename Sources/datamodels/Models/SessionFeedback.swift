//
//  SessionFeedback.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct SessionFeedback: Identifiable, Codable {
    let id: String
    let sessionId: String

    let fillerWordCount: Int
    let mispronouncedWords: [String]
    let fluencyScore: Double   // 0.0—1.0
    let onTopicScore: Double   // 0.0—1.0

    let summary: String
    let createdAt: Date
}
