//
//  User.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct User : Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var age: Int?
    var gender: Gender?
    var bio: String?
    var email: String
    var currentPlan: UserPlan?
    var englishLevel: EnglishLevel?
    var calls: [CallRecord]?
    var friends: [User]?
    var roleplays: [RoleplaySession]?
    var jams: [JamSession]?
    var avatar: String?
    var createdAt: Date
    var lastLogin: Date?
    var interests: [Interest]?

    // // Relationships
    var streak: Streak?
    // var stats: UserStats

    init(name: String, email: String, age: Int? = nil, currentPlan: UserPlan? = nil, calls: [CallRecord]? = nil, roleplays: [RoleplaySession]? = nil, jams: [JamSession]? = nil, createdAt: Date = Date(), lastLogin: Date? = nil, bio: String? = nil) {
        self.id = UUID()
        self.name = name
        self.age = age
        self.email = email
        self.currentPlan = currentPlan
        self.calls = calls
        self.roleplays = roleplays
        self.jams = jams
        self.createdAt = createdAt
        self.lastLogin = lastLogin
        self.bio = bio
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
