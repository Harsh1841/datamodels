//
//  RoleplaySession.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct RoleplaySession: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String              
    var category: RoleplayCategory
    var predefinedScript: [String]
    var userMessages: [RoleplayMessage]
    var status: RoleplayStatus
    var createdAt: Date

    // TODO add ending feature 
    init(title: String,
         category: RoleplayCategory,
         predefinedScript: [String],
         userMessages: [RoleplayMessage] = [],
         status: RoleplayStatus = .notStarted,
         createdAt: Date = Date()) {

        self.id = UUID()
        self.title = title
        self.category = category
        self.predefinedScript = predefinedScript
        self.userMessages = userMessages
        self.status = status
        self.createdAt = createdAt
    }
    
    static func ==(lhs: RoleplaySession, rhs: RoleplaySession) -> Bool {
        return lhs.id == rhs.id
    }
}
