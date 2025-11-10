//
//  CallSessionDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class CallSessionDataModelTests: XCTestCase {
    
    var callSessionDataModel: CallSessionDataModel!
    var testUser: User!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            callSessionDataModel = CallSessionDataModel.shared
        }
        testUser = User(name: "Test User", email: "test@example.com")
        
        // Clear existing data
        let allSessions = await callSessionDataModel.getAllCallSessions()
        for session in allSessions {
            await callSessionDataModel.deleteCallSession(by: session.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddCallSession() async {
        let participantOneID = UUID()
        let participantTwoID = UUID()
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session = CallSession(participantOneID: participantOneID, participantTwoID: participantTwoID, user: user)
        
        await callSessionDataModel.addCallSession(session)
        
        let sessions = await callSessionDataModel.getAllCallSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.participantOneID, participantOneID)
        XCTAssertEqual(sessions.first?.participantTwoID, participantTwoID)
    }
    
    // MARK: - Read Tests
    
    func testGetAllCallSessions() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session1 = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        let session2 = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        
        await callSessionDataModel.addCallSession(session1)
        await callSessionDataModel.addCallSession(session2)
        
        let sessions = await callSessionDataModel.getAllCallSessions()
        XCTAssertEqual(sessions.count, 2)
    }
    
    func testGetCallSessionById() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        await callSessionDataModel.addCallSession(session)
        
        let retrievedSession = await callSessionDataModel.getCallSession(by: session.id)
        XCTAssertNotNil(retrievedSession)
        XCTAssertEqual(retrievedSession?.id, session.id)
    }
    
    // MARK: - Update Tests
    
    func testUpdateCallSession() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        await callSessionDataModel.addCallSession(session)
        
        var updatedSession = session
        updatedSession.isConnected = true
        updatedSession.endedAt = Date()
        await callSessionDataModel.updateCallSession(updatedSession)
        
        let retrievedSession = await callSessionDataModel.getCallSession(by: session.id)
        XCTAssertTrue(retrievedSession?.isConnected ?? false)
        XCTAssertNotNil(retrievedSession?.endedAt)
    }
    
    func testAddSuggestedQuestions() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        await callSessionDataModel.addCallSession(session)
        
        let questions = ["What's your favorite hobby?", "Where are you from?"]
        await callSessionDataModel.addSuggestedQuestions(to: session.id, questions: questions)
        
        let retrievedSession = await callSessionDataModel.getCallSession(by: session.id)
        XCTAssertEqual(retrievedSession?.suggestedQuestions?.count, 2)
        XCTAssertEqual(retrievedSession?.suggestedQuestions?.first, "What's your favorite hobby?")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteCallSessionByIndex() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session1 = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        let session2 = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        
        await callSessionDataModel.addCallSession(session1)
        await callSessionDataModel.addCallSession(session2)
        
        await callSessionDataModel.deleteCallSession(at: 0)
        
        let sessions = await callSessionDataModel.getAllCallSessions()
        XCTAssertEqual(sessions.count, 1)
    }
    
    func testDeleteCallSessionById() async {
        guard let user = testUser else {
            XCTFail("testUser should not be nil")
            return
        }
        let session = CallSession(participantOneID: UUID(), participantTwoID: UUID(), user: user)
        await callSessionDataModel.addCallSession(session)
        
        await callSessionDataModel.deleteCallSession(by: session.id)
        
        let sessions = await callSessionDataModel.getAllCallSessions()
        XCTAssertEqual(sessions.count, 0)
        
        let retrievedSession = await callSessionDataModel.getCallSession(by: session.id)
        XCTAssertNil(retrievedSession)
    }
}

