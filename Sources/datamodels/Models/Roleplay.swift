//
//  Roleplay.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 06/11/25.
//

import Foundation

enum RoleplayCategory: String, Codable {
    case interview
    case groceryShopping
    case restaurant
    case travel
    case custom
}

enum RoleplayStatus: String, Codable {
    case notStarted
    case inProgress
    case completed
}

struct RoleplayMessage: Identifiable, Codable {
    let id: UUID
    let sender: String
    let message: String
    let timestamp: Date

    init(sender: String, message: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.sender = sender
        self.message = message
        self.timestamp = timestamp
    }
    
}

enum Difficulty: String, Codable {
    case beginner
    case intermediate
    case advanced
}

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

