//
//  Roleplay.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 06/11/25.
//

import Foundation



struct Roleplay: Identifiable, Codable {
    let id: UUID
    var title: String              
    var category: RoleplayCategory
    var predefinedScript: [String]
    var userMessages: [RoleplayMessage]
    var transcript: [String]? = nil
    var status: RoleplayStatus
    var createdAt: Date
    var difficultyLevel: Difficulty
    var imageURL: String? = nil

    init(title: String,
         category: RoleplayCategory,
         predefinedScript: [String],
         userMessages: [RoleplayMessage] = [],
         status: RoleplayStatus = .notStarted,
         createdAt: Date = Date(),
         difficultyLevel: Difficulty = .beginner,
         imageURL: String? = nil) {

        self.id = UUID()
        self.title = title
        self.category = category
        self.predefinedScript = predefinedScript
        self.userMessages = userMessages
        self.status = status
        self.createdAt = createdAt
        self.difficultyLevel = difficultyLevel
        self.imageURL = imageURL
    }
}

