//
//  StreakDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class StreakDataModelTests: XCTestCase {
    
    var streakDataModel: StreakDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            streakDataModel = StreakDataModel.shared
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testIncrementStreakCreatesNewStreak() async {
        await streakDataModel.deleteStreak()
        
        await streakDataModel.incrementStreak()
        
        let streak = await streakDataModel.getStreak()
        XCTAssertNotNil(streak)
        XCTAssertEqual(streak?.currentCount, 1)
        XCTAssertEqual(streak?.longestCount, 1)
    }
    
    // MARK: - Read Tests
    
    func testGetStreak() async {
        let testStreak = Streak(currentCount: 5, longestCount: 10, lastActiveDate: Date())
        await streakDataModel.updateStreak(testStreak)
        
        let retrievedStreak = await streakDataModel.getStreak()
        XCTAssertNotNil(retrievedStreak)
        XCTAssertEqual(retrievedStreak?.currentCount, 5)
        XCTAssertEqual(retrievedStreak?.longestCount, 10)
    }
    
    // MARK: - Update Tests
    
    func testUpdateStreak() async {
        let streak = Streak(currentCount: 3, longestCount: 5, lastActiveDate: Date())
        await streakDataModel.updateStreak(streak)
        
        let retrievedStreak = await streakDataModel.getStreak()
        XCTAssertEqual(retrievedStreak?.currentCount, 3)
        XCTAssertEqual(retrievedStreak?.longestCount, 5)
    }
    
    func testIncrementStreak() async {
        let initialStreak = Streak(currentCount: 2, longestCount: 5, lastActiveDate: Date())
        await streakDataModel.updateStreak(initialStreak)
        
        await streakDataModel.incrementStreak()
        
        let updatedStreak = await streakDataModel.getStreak()
        XCTAssertEqual(updatedStreak?.currentCount, 3)
        XCTAssertEqual(updatedStreak?.longestCount, 5) // Should not update if current < longest
    }
    
    func testIncrementStreakUpdatesLongestCount() async {
        let initialStreak = Streak(currentCount: 5, longestCount: 5, lastActiveDate: Date())
        await streakDataModel.updateStreak(initialStreak)
        
        await streakDataModel.incrementStreak()
        
        let updatedStreak = await streakDataModel.getStreak()
        XCTAssertEqual(updatedStreak?.currentCount, 6)
        XCTAssertEqual(updatedStreak?.longestCount, 6) // Should update when current exceeds longest
    }
    
    func testIncrementStreakUpdatesLastActiveDate() async {
        let oldDate = Date().addingTimeInterval(-86400) // Yesterday
        let initialStreak = Streak(currentCount: 1, longestCount: 1, lastActiveDate: oldDate)
        await streakDataModel.updateStreak(initialStreak)
        
        await streakDataModel.incrementStreak()
        
        let updatedStreak = await streakDataModel.getStreak()
        XCTAssertNotNil(updatedStreak?.lastActiveDate)
        XCTAssertGreaterThan(updatedStreak?.lastActiveDate ?? Date(), oldDate)
    }
    
    func testResetStreak() async {
        let streak = Streak(currentCount: 5, longestCount: 10, lastActiveDate: Date())
        await streakDataModel.updateStreak(streak)
        
        await streakDataModel.resetStreak()
        
        let resetStreak = await streakDataModel.getStreak()
        XCTAssertEqual(resetStreak?.currentCount, 0)
        XCTAssertEqual(resetStreak?.longestCount, 10) // Longest should remain
    }
    
    // MARK: - Delete Tests
    
    func testDeleteStreak() async {
        let streak = Streak(currentCount: 5, longestCount: 10, lastActiveDate: Date())
        await streakDataModel.updateStreak(streak)
        
        await streakDataModel.deleteStreak()
        
        let deletedStreak = await streakDataModel.getStreak()
        XCTAssertNil(deletedStreak)
    }
    
    // MARK: - Streak Logic Tests
    
    func testMultipleIncrements() async {
        await streakDataModel.deleteStreak()
        
        for _ in 1...5 {
            await streakDataModel.incrementStreak()
        }
        
        let streak = await streakDataModel.getStreak()
        XCTAssertEqual(streak?.currentCount, 5)
        XCTAssertEqual(streak?.longestCount, 5)
    }
    
    func testStreakAfterReset() async {
        let streak = Streak(currentCount: 3, longestCount: 10, lastActiveDate: Date())
        await streakDataModel.updateStreak(streak)
        
        await streakDataModel.resetStreak()
        await streakDataModel.incrementStreak()
        
        let updatedStreak = await streakDataModel.getStreak()
        XCTAssertEqual(updatedStreak?.currentCount, 1)
        XCTAssertEqual(updatedStreak?.longestCount, 10) // Longest should remain
    }
}

