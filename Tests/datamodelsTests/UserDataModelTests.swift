//
//  UserDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class UserDataModelTests: XCTestCase {
    
    var userDataModel: UserDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        userDataModel = await UserDataModel.shared
        // Clear existing data for clean test state
        let allUsers = await userDataModel.getAllUsers()
        for user in allUsers {
            await userDataModel.deleteUser(by: user.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddUser() async {
        let user = User(name: "Test User", email: "test@example.com", age: 25)
        await userDataModel.addUser(user)
        
        let users = await userDataModel.getAllUsers()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "Test User")
        XCTAssertEqual(users.first?.email, "test@example.com")
    }
    
    func testSaveCurrentUser() async {
        let user = User(name: "Current User", email: "current@example.com")
        await userDataModel.saveCurrentUser(user)
        
        let currentUser = await userDataModel.getCurrentUser()
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.name, "Current User")
        
        let users = await userDataModel.getAllUsers()
        XCTAssertTrue(users.contains(where: { $0.id == user.id }))
    }
    
    // MARK: - Read Tests
    
    func testGetAllUsers() async {
        let user1 = User(name: "User 1", email: "user1@example.com")
        let user2 = User(name: "User 2", email: "user2@example.com")
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        
        let users = await userDataModel.getAllUsers()
        XCTAssertEqual(users.count, 2)
    }
    
    func testGetUserById() async {
        let user = User(name: "Test User", email: "test@example.com")
        await userDataModel.addUser(user)
        
        let retrievedUser = await userDataModel.getUser(by: user.id)
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser?.id, user.id)
        XCTAssertEqual(retrievedUser?.name, "Test User")
    }
    
    func testGetCurrentUser() async {
        let user = User(name: "Current User", email: "current@example.com")
        await userDataModel.saveCurrentUser(user)
        
        let currentUser = await userDataModel.getCurrentUser()
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.id, user.id)
    }
    
    // MARK: - Update Tests
    
    func testUpdateUser() async {
        let user = User(name: "Original Name", email: "test@example.com")
        await userDataModel.addUser(user)
        
        var updatedUser = user
        updatedUser.name = "Updated Name"
        await userDataModel.updateUser(updatedUser)
        
        let retrievedUser = await userDataModel.getUser(by: user.id)
        XCTAssertEqual(retrievedUser?.name, "Updated Name")
    }
    
    func testUpdateStreak() async {
        let user = User(name: "Test User", email: "test@example.com")
        await userDataModel.saveCurrentUser(user)
        
        let streak = Streak(currentCount: 5, longestCount: 10, lastActiveDate: Date())
        await userDataModel.updateStreak(streak)
        
        let updatedUser = await userDataModel.getCurrentUser()
        XCTAssertNotNil(updatedUser?.streak)
        XCTAssertEqual(updatedUser?.streak?.currentCount, 5)
    }
    
    // MARK: - Delete Tests
    
    func testDeleteUserByIndex() async {
        let user1 = User(name: "User 1", email: "user1@example.com")
        let user2 = User(name: "User 2", email: "user2@example.com")
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        
        await userDataModel.deleteUser(at: 0)
        
        let users = await userDataModel.getAllUsers()
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.name, "User 2")
    }
    
    func testDeleteUserById() async {
        let user = User(name: "Test User", email: "test@example.com")
        await userDataModel.addUser(user)
        
        await userDataModel.deleteUser(by: user.id)
        
        let users = await userDataModel.getAllUsers()
        XCTAssertEqual(users.count, 0)
        
        let retrievedUser = await userDataModel.getUser(by: user.id)
        XCTAssertNil(retrievedUser)
    }
    
    // MARK: - Matching Tests (1-to-1 Call Feature)
    
    func testFindMatchingUsersByInterests() async {
        var user1 = User(name: "User 1", email: "user1@example.com")
        user1.interests = [.technology, .science]
        var user2 = User(name: "User 2", email: "user2@example.com")
        user2.interests = [.technology, .health]
        var user3 = User(name: "User 3", email: "user3@example.com")
        user3.interests = [.sports, .music]
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        await userDataModel.addUser(user3)
        
        let matches = await userDataModel.findMatchingUsers(for: user1, basedOn: [.technology])
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, user2.id)
    }
    
    func testFindMatchingUsersByGender() async {
        var user1 = User(name: "User 1", email: "user1@example.com")
        user1.gender = .male
        var user2 = User(name: "User 2", email: "user2@example.com")
        user2.gender = .female
        var user3 = User(name: "User 3", email: "user3@example.com")
        user3.gender = .male
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        await userDataModel.addUser(user3)
        
        let matches = await userDataModel.findMatchingUsers(for: user1, gender: .male)
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, user3.id)
    }
    
    func testFindMatchingUsersByAge() async {
        let user1 = User(name: "User 1", email: "user1@example.com", age: 25)
        let user2 = User(name: "User 2", email: "user2@example.com", age: 30)
        let user3 = User(name: "User 3", email: "user3@example.com", age: 35)
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        await userDataModel.addUser(user3)
        
        let matches = await userDataModel.findMatchingUsers(for: user1, ageRange: 28...32)
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, user2.id)
    }
    
    func testFindMatchingUsersByEnglishLevel() async {
        var user1 = User(name: "User 1", email: "user1@example.com")
        user1.englishLevel = .intermediate
        var user2 = User(name: "User 2", email: "user2@example.com")
        user2.englishLevel = .intermediate
        var user3 = User(name: "User 3", email: "user3@example.com")
        user3.englishLevel = .advanced
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        await userDataModel.addUser(user3)
        
        let matches = await userDataModel.findMatchingUsers(for: user1, englishLevel: .intermediate)
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, user2.id)
    }
    
    func testFindMatchingUsersWithMultipleCriteria() async {
        var user1 = User(name: "User 1", email: "user1@example.com", age: 25)
        user1.gender = .male
        user1.englishLevel = .intermediate
        user1.interests = [.technology]
        var user2 = User(name: "User 2", email: "user2@example.com", age: 28)
        user2.gender = .male
        user2.englishLevel = .intermediate
        user2.interests = [.technology]
        var user3 = User(name: "User 3", email: "user3@example.com", age: 30)
        user3.gender = .female
        user3.englishLevel = .intermediate
        user3.interests = [.technology]
        
        await userDataModel.addUser(user1)
        await userDataModel.addUser(user2)
        await userDataModel.addUser(user3)
        
        let matches = await userDataModel.findMatchingUsers(
            for: user1,
            basedOn: [.technology],
            gender: .male,
            ageRange: 25...30,
            englishLevel: .intermediate
        )
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, user2.id)
    }
    
    func testFindMatchingUsersExcludesSelf() async {
        let user = User(name: "Test User", email: "test@example.com")
        await userDataModel.addUser(user)
        
        let matches = await userDataModel.findMatchingUsers(for: user)
        
        XCTAssertFalse(matches.contains(where: { $0.id == user.id }))
    }
}

