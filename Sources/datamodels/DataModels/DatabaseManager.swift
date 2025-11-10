//
//  DatabaseManager.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

//
//  DatabaseManager.swift
//  OpenTone
//

import Foundation
@MainActor
final class DatabaseManager {

    static let shared = DatabaseManager()
    private init() {}

    
    let userRepo = UserRepository.shared
    let jamRepo = JamSessionRepository.shared
    let roleplayRepo = RoleplaySessionRepository.shared
    let callRepo = CallSessionRepository.shared
}
