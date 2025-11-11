//
//  UserDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class UserDataModel {
    
    static let shared = UserDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var users: [User] = []
    private var currentUser: User?
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("users").appendingPathExtension("plist")
        loadUsers()
    }
    
    // MARK: - Public Methods
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func addUser(_ user: User) {
        users.append(user)
        saveUsers()
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
            saveUsers()
        }
    }
    
    func deleteUser(at index: Int) {
        users.remove(at: index)
        saveUsers()
    }
    
    func deleteUser(by id: UUID) {
        users.removeAll(where: { $0.id == id })
        saveUsers()
    }
    
    func getUser(by id: UUID) -> User? {
        return users.first(where: { $0.id == id })
    }
    
    func saveCurrentUser(_ user: User) {
        currentUser = user
        // Also add/update in users array
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        } else {
            users.append(user)
        }
        saveUsers()
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func updateStreak(_ streak: Streak) {
        if var user = currentUser {
            user.streak = streak
            currentUser = user
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index] = user
            }
            saveUsers()
        }
    }
    
    // MARK: - Matching Methods (for 1-to-1 call feature)
    
    func findMatchingUsers(for user: User, basedOn interests: [Interest]? = nil, gender: Gender? = nil, ageRange: ClosedRange<Int>? = nil, englishLevel: EnglishLevel? = nil) -> [User] {
        return users.filter { potentialMatch in
            // Don't match with self
            guard potentialMatch.id != user.id else { return false }
            
            // Match interests if provided
            if let interests = interests, let matchInterests = potentialMatch.interests {
                let hasCommonInterest = interests.contains { interest in
                    matchInterests.contains(interest)
                }
                if !hasCommonInterest { return false }
            }
            
            // Match gender if provided
            if let gender = gender, let matchGender = potentialMatch.gender {
                if matchGender != gender { return false }
            }
            
            // Match age if provided
            if let ageRange = ageRange, let matchAge = potentialMatch.age {
                if !ageRange.contains(matchAge) { return false }
            }
            
            // Match english level if provided
            if let englishLevel = englishLevel, let matchEnglishLevel = potentialMatch.englishLevel {
                if matchEnglishLevel != englishLevel { return false }
            }
            
            return true
        }
    }
    
    // MARK: - Private Methods
    
    private func loadUsers() {
        if let savedUsers = loadUsersFromDisk() {
            users = savedUsers
            // Set first user as current if no current user is set
            if currentUser == nil && !users.isEmpty {
                currentUser = users.first
            }
        } else {
            users = loadSampleUsers()
        }
    }
    
    private func loadUsersFromDisk() -> [User]? {
        guard let codedUsers = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([User].self, from: codedUsers)
    }
    
    private func saveUsers() {
        let propertyListEncoder = PropertyListEncoder()
        let codedUsers = try? propertyListEncoder.encode(users)
        try? codedUsers?.write(to: archiveURL)
    }
    
    private func loadSampleUsers() -> [User] {
        let user1 = User(
            name: "John Doe",
            email: "john@example.com",
            age: 25,
            currentPlan: .premium,
            bio: "Learning English"
        )
        
        let user2 = User(
            name: "Jane Smith",
            email: "jane@example.com",
            age: 28,
            currentPlan: .free,
            bio: "Practice makes perfect"
        )
        
        return [user1, user2]
    }
}

