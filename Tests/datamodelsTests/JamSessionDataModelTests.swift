//
//  JamSessionDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class JamSessionDataModelTests: XCTestCase {
    
    var jamSessionDataModel: JamSessionDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            jamSessionDataModel = JamSessionDataModel.shared
        }
        
        // Clear existing data
        let allSessions = await jamSessionDataModel.getAllJamSessions()
        for session in allSessions {
            await jamSessionDataModel.deleteJamSession(by: session.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddJamSession() async {
        let session = JamSession(userId: "user123", phase: .preparing)
        
        await jamSessionDataModel.addJamSession(session)
        
        let sessions = await jamSessionDataModel.getAllJamSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.userId, "user123")
        XCTAssertEqual(sessions.first?.phase, .preparing)
    }
    
    // MARK: - Read Tests
    
    func testGetAllJamSessions() async {
        let session1 = JamSession(userId: "user1", phase: .preparing)
        let session2 = JamSession(userId: "user2", phase: .speaking)
        
        await jamSessionDataModel.addJamSession(session1)
        await jamSessionDataModel.addJamSession(session2)
        
        let sessions = await jamSessionDataModel.getAllJamSessions()
        XCTAssertEqual(sessions.count, 2)
    }
    
    func testGetJamSessionById() async {
        let session = JamSession(userId: "user123", phase: .preparing)
        await jamSessionDataModel.addJamSession(session)
        
        let retrievedSession = await jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertNotNil(retrievedSession)
        XCTAssertEqual(retrievedSession?.id, session.id)
    }
    
    // MARK: - Update Tests
    
    func testUpdateJamSession() async {
        let session = JamSession(userId: "user123", phase: .preparing)
        await jamSessionDataModel.addJamSession(session)
        
        var updatedSession = session
        updatedSession.phase = .speaking
        updatedSession.startedPrepAt = Date()
        updatedSession.startedSpeakingAt = Date()
        await jamSessionDataModel.updateJamSession(updatedSession)
        
        let retrievedSession = await jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertEqual(retrievedSession?.phase, .speaking)
        XCTAssertNotNil(retrievedSession?.startedPrepAt)
        XCTAssertNotNil(retrievedSession?.startedSpeakingAt)
    }
    
    func testUpdateJamSessionWithTranscript() async {
        let session = JamSession(userId: "user123", phase: .speaking)
        await jamSessionDataModel.addJamSession(session)
        
        var updatedSession = session
        updatedSession.transcript = "This is a test transcript."
        updatedSession.phase = .completed
        updatedSession.endedAt = Date()
        await jamSessionDataModel.updateJamSession(updatedSession)
        
        let retrievedSession = await jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertEqual(retrievedSession?.transcript, "This is a test transcript.")
        XCTAssertEqual(retrievedSession?.phase, .completed)
        XCTAssertNotNil(retrievedSession?.endedAt)
    }
    
    // MARK: - Delete Tests
    
    func testDeleteJamSessionByIndex() async {
        let session1 = JamSession(userId: "user1", phase: .preparing)
        let session2 = JamSession(userId: "user2", phase: .speaking)
        
        await jamSessionDataModel.addJamSession(session1)
        await jamSessionDataModel.addJamSession(session2)
        
        await jamSessionDataModel.deleteJamSession(at: 0)
        
        let sessions = await jamSessionDataModel.getAllJamSessions()
        XCTAssertEqual(sessions.count, 1)
    }
    
    func testDeleteJamSessionById() async {
        let session = JamSession(userId: "user123", phase: .preparing)
        await jamSessionDataModel.addJamSession(session)
        
        await jamSessionDataModel.deleteJamSession(by: session.id)
        
        let sessions = await jamSessionDataModel.getAllJamSessions()
        XCTAssertEqual(sessions.count, 0)
        
        let retrievedSession = await jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertNil(retrievedSession)
    }
    
    // MARK: - Jam Session Flow Tests
    
    func testJamSessionPhaseProgression() async {
        let session = JamSession(userId: "user123", phase: .preparing)
        await jamSessionDataModel.addJamSession(session)
        
        // Move from preparing to speaking
        var updatedSession = session
        updatedSession.phase = .speaking
        updatedSession.startedPrepAt = Date()
        updatedSession.startedSpeakingAt = Date()
        await jamSessionDataModel.updateJamSession(updatedSession)
        
        var retrievedSession = jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertEqual(retrievedSession?.phase, .speaking)
        
        // Move from speaking to completed
        updatedSession = retrievedSession!
        updatedSession.phase = .completed
        updatedSession.endedAt = Date()
        updatedSession.transcript = "Test transcript"
        await jamSessionDataModel.updateJamSession(updatedSession)
        
        retrievedSession = jamSessionDataModel.getJamSession(by: session.id)
        XCTAssertEqual(retrievedSession?.phase, .completed)
        XCTAssertNotNil(retrievedSession?.endedAt)
    }
}

