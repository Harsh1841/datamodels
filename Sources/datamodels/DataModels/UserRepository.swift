//
//  UserRepository.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//
@MainActor
final class UserRepository {

    static let shared = UserRepository()
    private init() {}

    private var currentUser: User?

    func saveUser(_ user: User) {
        currentUser = user
    }

    func getCurrentUser() -> User? {
        return currentUser
    }

    func updateStreak(_ streak: Streak) {
        currentUser?.streak = streak
    }
}
