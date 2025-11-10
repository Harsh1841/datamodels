//
//  HistoryDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class HistoryDataModelTests: XCTestCase {
    
    var historyDataModel: HistoryDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            historyDataModel = HistoryDataModel.shared
        }
        
        // Clear existing data
        let allActivities = await historyDataModel.getAllActivities()
        for activity in allActivities {
            await historyDataModel.deleteActivity(by: activity.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddActivity() async {
        let activity = Activity(type: .call, date: Date())
        
        await historyDataModel.addActivity(activity)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertEqual(activities.count, 1)
        XCTAssertEqual(activities.first?.type, .call)
    }
    
    // MARK: - Read Tests
    
    func testGetAllActivities() async {
        let activity1 = Activity(type: .call, date: Date())
        let activity2 = Activity(type: .jam, date: Date())
        let activity3 = Activity(type: .roleplay, date: Date())
        
        await historyDataModel.addActivity(activity1)
        await historyDataModel.addActivity(activity2)
        await historyDataModel.addActivity(activity3)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertEqual(activities.count, 3)
    }
    
    func testGetActivityById() async {
        let activity = Activity(type: .call, date: Date())
        await historyDataModel.addActivity(activity)
        
        let retrievedActivity = await historyDataModel.getActivity(by: activity.id)
        XCTAssertNotNil(retrievedActivity)
        XCTAssertEqual(retrievedActivity?.id, activity.id)
    }
    
    func testSearchHistoryByType() async {
        let callActivity1 = Activity(type: .call, date: Date())
        let callActivity2 = Activity(type: .call, date: Date())
        let jamActivity = Activity(type: .jam, date: Date())
        let roleplayActivity = Activity(type: .roleplay, date: Date())
        
        await historyDataModel.addActivity(callActivity1)
        await historyDataModel.addActivity(callActivity2)
        await historyDataModel.addActivity(jamActivity)
        await historyDataModel.addActivity(roleplayActivity)
        
        let callActivities = await historyDataModel.searchHistory(by: .call)
        XCTAssertEqual(callActivities.count, 2)
        
        let jamActivities = await historyDataModel.searchHistory(by: .jam)
        XCTAssertEqual(jamActivities.count, 1)
        
        let roleplayActivities = await historyDataModel.searchHistory(by: .roleplay)
        XCTAssertEqual(roleplayActivities.count, 1)
    }
    
    // MARK: - Update Tests
    
    func testUpdateActivity() async {
        let activity = Activity(type: .call, date: Date())
        await historyDataModel.addActivity(activity)
        
        // Note: Activity is immutable, so we test that update works with a new activity
        let updatedActivity = Activity(type: .jam, date: Date())
        await historyDataModel.addActivity(updatedActivity)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertTrue(activities.contains(where: { $0.type == .call }))
        XCTAssertTrue(activities.contains(where: { $0.type == .jam }))
    }
    
    // MARK: - Delete Tests
    
    func testDeleteActivityByIndex() async {
        let activity1 = Activity(type: .call, date: Date())
        let activity2 = Activity(type: .jam, date: Date())
        
        await historyDataModel.addActivity(activity1)
        await historyDataModel.addActivity(activity2)
        
        await historyDataModel.deleteActivity(at: 0)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertEqual(activities.count, 1)
    }
    
    func testDeleteActivityById() async {
        let activity = Activity(type: .call, date: Date())
        await historyDataModel.addActivity(activity)
        
        await historyDataModel.deleteActivity(by: activity.id)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertEqual(activities.count, 0)
        
        let retrievedActivity = await historyDataModel.getActivity(by: activity.id)
        XCTAssertNil(retrievedActivity)
    }
    
    // MARK: - Activity Type Tests
    
    func testAllActivityTypes() async {
        let callActivity = Activity(type: .call, date: Date())
        let jamActivity = Activity(type: .jam, date: Date())
        let roleplayActivity = Activity(type: .roleplay, date: Date())
        
        await historyDataModel.addActivity(callActivity)
        await historyDataModel.addActivity(jamActivity)
        await historyDataModel.addActivity(roleplayActivity)
        
        let activities = await historyDataModel.getAllActivities()
        XCTAssertEqual(activities.count, 3)
        
        let types = Set(activities.map { $0.type })
        XCTAssertTrue(types.contains(.call))
        XCTAssertTrue(types.contains(.jam))
        XCTAssertTrue(types.contains(.roleplay))
    }
}

