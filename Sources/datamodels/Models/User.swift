//
//  User.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation


enum UserPlan: String, Codable {
    case free
    case premium
    case pro
}
enum Gender: String, Codable {
    case male
    case female
    case other
}

enum Interest: String, Codable {
    case technology
    case health
    case education
    case entertainment
    case sports
    case music
    case movies
    case travel
    case food
    case science
    case art
}
enum EnglishLevel: String, Codable {
    case beginner
    case intermediate
    case advanced
}

struct User : Identifiable, Codable {
    let id: UUID
    var name: String
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

    init(name: String, email: String, currentPlan: UserPlan? = nil, calls: [CallRecord]? = nil, roleplays: [RoleplaySession]? = nil, jams: [JamSession]? = nil, createdAt: Date = Date(), lastLogin: Date? = nil, bio: String? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.currentPlan = currentPlan
        self.calls = calls
        self.roleplays = roleplays
        self.jams = jams
        self.createdAt = createdAt
        self.lastLogin = lastLogin
        self.bio = bio
    }

}
