//
//  SessionFeedbackDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class SessionFeedbackDataModelTests: XCTestCase {
    
    var sessionFeedbackDataModel: SessionFeedbackDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            sessionFeedbackDataModel = SessionFeedbackDataModel.shared
        }
        
        // Clear existing data
        let allFeedbacks = await sessionFeedbackDataModel.getAllSessionFeedbacks()
        for feedback in allFeedbacks {
            await sessionFeedbackDataModel.deleteSessionFeedback(by: feedback.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddSessionFeedback() async {
        let feedback = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: ["hello", "world"],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "Good performance",
            createdAt: Date()
        )
        
        await sessionFeedbackDataModel.addSessionFeedback(feedback)
        
        let feedbacks = await sessionFeedbackDataModel.getAllSessionFeedbacks()
        XCTAssertEqual(feedbacks.count, 1)
        XCTAssertEqual(feedbacks.first?.id, "feedback1")
        XCTAssertEqual(feedbacks.first?.fluencyScore, 0.85)
    }
    
    // MARK: - Read Tests
    
    func testGetAllSessionFeedbacks() async {
        let feedback1 = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "Good",
            createdAt: Date()
        )
        let feedback2 = SessionFeedback(
            id: "feedback2",
            sessionId: "session2",
            fillerWordCount: 3,
            mispronouncedWords: [],
            fluencyScore: 0.90,
            onTopicScore: 0.95,
            summary: "Excellent",
            createdAt: Date()
        )
        
        await sessionFeedbackDataModel.addSessionFeedback(feedback1)
        await sessionFeedbackDataModel.addSessionFeedback(feedback2)
        
        let feedbacks = await sessionFeedbackDataModel.getAllSessionFeedbacks()
        XCTAssertEqual(feedbacks.count, 2)
    }
    
    func testGetSessionFeedbackById() async {
        let feedback = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "Test",
            createdAt: Date()
        )
        await sessionFeedbackDataModel.addSessionFeedback(feedback)
        
        let retrievedFeedback = await sessionFeedbackDataModel.getSessionFeedback(by: "feedback1")
        XCTAssertNotNil(retrievedFeedback)
        XCTAssertEqual(retrievedFeedback?.id, "feedback1")
    }
    
    func testGetSessionFeedbacksBySessionId() async {
        let feedback1 = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "First",
            createdAt: Date()
        )
        let feedback2 = SessionFeedback(
            id: "feedback2",
            sessionId: "session1",
            fillerWordCount: 3,
            mispronouncedWords: [],
            fluencyScore: 0.90,
            onTopicScore: 0.95,
            summary: "Second",
            createdAt: Date()
        )
        let feedback3 = SessionFeedback(
            id: "feedback3",
            sessionId: "session2",
            fillerWordCount: 2,
            mispronouncedWords: [],
            fluencyScore: 0.95,
            onTopicScore: 0.98,
            summary: "Third",
            createdAt: Date()
        )
        
        await sessionFeedbackDataModel.addSessionFeedback(feedback1)
        await sessionFeedbackDataModel.addSessionFeedback(feedback2)
        await sessionFeedbackDataModel.addSessionFeedback(feedback3)
        
        let session1Feedbacks = await sessionFeedbackDataModel.getSessionFeedbacks(by: "session1")
        XCTAssertEqual(session1Feedbacks.count, 2)
        
        let session2Feedbacks = await sessionFeedbackDataModel.getSessionFeedbacks(by: "session2")
        XCTAssertEqual(session2Feedbacks.count, 1)
    }
    
    // MARK: - Update Tests
    
    func testUpdateSessionFeedback() async {
        let feedback = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "Original",
            createdAt: Date()
        )
        await sessionFeedbackDataModel.addSessionFeedback(feedback)
        
        var updatedFeedback = feedback
        updatedFeedback = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 3,
            mispronouncedWords: [],
            fluencyScore: 0.90,
            onTopicScore: 0.95,
            summary: "Updated",
            createdAt: Date()
        )
        await sessionFeedbackDataModel.updateSessionFeedback(updatedFeedback)
        
        let retrievedFeedback = await sessionFeedbackDataModel.getSessionFeedback(by: "feedback1")
        XCTAssertEqual(retrievedFeedback?.fluencyScore, 0.90)
        XCTAssertEqual(retrievedFeedback?.summary, "Updated")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteSessionFeedbackByIndex() async {
        let feedback1 = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "First",
            createdAt: Date()
        )
        let feedback2 = SessionFeedback(
            id: "feedback2",
            sessionId: "session2",
            fillerWordCount: 3,
            mispronouncedWords: [],
            fluencyScore: 0.90,
            onTopicScore: 0.95,
            summary: "Second",
            createdAt: Date()
        )
        
        await sessionFeedbackDataModel.addSessionFeedback(feedback1)
        await sessionFeedbackDataModel.addSessionFeedback(feedback2)
        
        await sessionFeedbackDataModel.deleteSessionFeedback(at: 0)
        
        let feedbacks = await sessionFeedbackDataModel.getAllSessionFeedbacks()
        XCTAssertEqual(feedbacks.count, 1)
    }
    
    func testDeleteSessionFeedbackById() async {
        let feedback = SessionFeedback(
            id: "feedback1",
            sessionId: "session1",
            fillerWordCount: 5,
            mispronouncedWords: [],
            fluencyScore: 0.85,
            onTopicScore: 0.90,
            summary: "Test",
            createdAt: Date()
        )
        await sessionFeedbackDataModel.addSessionFeedback(feedback)
        
        await sessionFeedbackDataModel.deleteSessionFeedback(by: "feedback1")
        
        let feedbacks = await sessionFeedbackDataModel.getAllSessionFeedbacks()
        XCTAssertEqual(feedbacks.count, 0)
        
        let retrievedFeedback = await sessionFeedbackDataModel.getSessionFeedback(by: "feedback1")
        XCTAssertNil(retrievedFeedback)
    }
}

