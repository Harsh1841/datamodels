//
//  RoleplaySessionDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class RoleplaySessionDataModelTests: XCTestCase {
    
    var roleplaySessionDataModel: RoleplaySessionDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            roleplaySessionDataModel = RoleplaySessionDataModel.shared
        }
        
        // Clear existing data
        let allSessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        for session in allSessions {
            await roleplaySessionDataModel.deleteRoleplaySession(by: session.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddRoleplaySession() async {
        let script = ["Hello, I'd like to buy some apples.", "How much do they cost?"]
        let session = RoleplaySession(
            title: "Grocery Shopping",
            category: .groceryShopping,
            predefinedScript: script
        )
        
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        let sessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.title, "Grocery Shopping")
        XCTAssertEqual(sessions.first?.category, .groceryShopping)
        XCTAssertEqual(sessions.first?.predefinedScript.count, 2)
    }
    
    // MARK: - Read Tests
    
    func testGetAllRoleplaySessions() async {
        let session1 = RoleplaySession(
            title: "Interview",
            category: .interview,
            predefinedScript: ["Tell me about yourself."]
        )
        let session2 = RoleplaySession(
            title: "Restaurant",
            category: .restaurant,
            predefinedScript: ["I'd like to order a pizza."]
        )
        
        await roleplaySessionDataModel.addRoleplaySession(session1)
        await roleplaySessionDataModel.addRoleplaySession(session2)
        
        let sessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        XCTAssertEqual(sessions.count, 2)
    }
    
    func testGetRoleplaySessionById() async {
        let session = RoleplaySession(
            title: "Test Session",
            category: .custom,
            predefinedScript: []
        )
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        let retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertNotNil(retrievedSession)
        XCTAssertEqual(retrievedSession?.id, session.id)
    }
    
    // MARK: - Update Tests
    
    func testUpdateRoleplaySession() async {
        let session = RoleplaySession(
            title: "Original Title",
            category: .interview,
            predefinedScript: []
        )
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        var updatedSession = session
        updatedSession.title = "Updated Title"
        updatedSession.status = .inProgress
        await roleplaySessionDataModel.updateRoleplaySession(updatedSession)
        
        let retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertEqual(retrievedSession?.title, "Updated Title")
        XCTAssertEqual(retrievedSession?.status, .inProgress)
    }
    
    func testUpdateRoleplaySessionWithUserMessages() async {
        let session = RoleplaySession(
            title: "Test Session",
            category: .groceryShopping,
            predefinedScript: ["Hello"]
        )
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        let message = RoleplayMessage(sender: "User", message: "I'd like to buy apples")
        var updatedSession = session
        updatedSession.userMessages.append(message)
        await roleplaySessionDataModel.updateRoleplaySession(updatedSession)
        
        let retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertEqual(retrievedSession?.userMessages.count, 1)
        XCTAssertEqual(retrievedSession?.userMessages.first?.message, "I'd like to buy apples")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteRoleplaySessionByIndex() async {
        let session1 = RoleplaySession(
            title: "Session 1",
            category: .interview,
            predefinedScript: []
        )
        let session2 = RoleplaySession(
            title: "Session 2",
            category: .restaurant,
            predefinedScript: []
        )
        
        await roleplaySessionDataModel.addRoleplaySession(session1)
        await roleplaySessionDataModel.addRoleplaySession(session2)
        
        await roleplaySessionDataModel.deleteRoleplaySession(at: 0)
        
        let sessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        XCTAssertEqual(sessions.count, 1)
    }
    
    func testDeleteRoleplaySessionById() async {
        let session = RoleplaySession(
            title: "Test Session",
            category: .custom,
            predefinedScript: []
        )
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        await roleplaySessionDataModel.deleteRoleplaySession(by: session.id)
        
        let sessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        XCTAssertEqual(sessions.count, 0)
        
        let retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertNil(retrievedSession)
    }
    
    // MARK: - Roleplay Session Status Tests
    
    func testRoleplaySessionStatusProgression() async {
        let session = RoleplaySession(
            title: "Test Session",
            category: .interview,
            predefinedScript: ["Question 1", "Question 2"]
        )
        await roleplaySessionDataModel.addRoleplaySession(session)
        
        // Start session
        var updatedSession = session
        updatedSession.status = .inProgress
        await roleplaySessionDataModel.updateRoleplaySession(updatedSession)
        
        var retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertEqual(retrievedSession?.status, .inProgress)
        
        // Complete session
        updatedSession = retrievedSession!
        updatedSession.status = .completed
        await roleplaySessionDataModel.updateRoleplaySession(updatedSession)
        
        retrievedSession = await roleplaySessionDataModel.getRoleplaySession(by: session.id)
        XCTAssertEqual(retrievedSession?.status, .completed)
    }
    
    // MARK: - Category Tests
    
    func testRoleplaySessionCategories() async {
        let categories: [RoleplayCategory] = [.interview, .groceryShopping, .restaurant, .travel, .custom]
        
        for category in categories {
            let session = RoleplaySession(
                title: "\(category) Session",
                category: category,
                predefinedScript: []
            )
            await roleplaySessionDataModel.addRoleplaySession(session)
        }
        
        let sessions = await roleplaySessionDataModel.getAllRoleplaySessions()
        XCTAssertEqual(sessions.count, categories.count)
    }
}

