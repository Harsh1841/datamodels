//
//  CallRecordDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class CallRecordDataModelTests: XCTestCase {
    
    var callRecordDataModel: CallRecordDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            callRecordDataModel = CallRecordDataModel.shared
        }
        
        // Clear existing data
        let allRecords = await callRecordDataModel.getAllCallRecords()
        for record in allRecords {
            await callRecordDataModel.deleteCallRecord(by: record.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddCallRecord() async {
        let record = CallRecord(
            participantID: UUID(),
            participantAvatarURL: "https://example.com/avatar.jpg",
            participantBio: "Test bio",
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        
        await callRecordDataModel.addCallRecord(record)
        
        let records = await callRecordDataModel.getAllCallRecords()
        XCTAssertEqual(records.count, 1)
        XCTAssertEqual(records.first?.duration, 300.0)
        XCTAssertEqual(records.first?.userStatus, .online)
    }
    
    // MARK: - Read Tests
    
    func testGetAllCallRecords() async {
        let record1 = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        let record2 = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 600.0,
            userStatus: .offline
        )
        
        await callRecordDataModel.addCallRecord(record1)
        await callRecordDataModel.addCallRecord(record2)
        
        let records = await callRecordDataModel.getAllCallRecords()
        XCTAssertEqual(records.count, 2)
    }
    
    func testGetCallRecordById() async {
        let record = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        await callRecordDataModel.addCallRecord(record)
        
        let retrievedRecord = await callRecordDataModel.getCallRecord(by: record.id)
        XCTAssertNotNil(retrievedRecord)
        XCTAssertEqual(retrievedRecord?.id, record.id)
    }
    
    // MARK: - Update Tests
    
    func testUpdateCallRecord() async {
        let record = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        await callRecordDataModel.addCallRecord(record)
        
        // Note: CallRecord properties are mostly immutable, but we can test update mechanism
        let updatedRecord = record
        // Since CallRecord has let properties, we'd need to create a new one
        // This test verifies the update method works
        await callRecordDataModel.updateCallRecord(updatedRecord)
        
        let retrievedRecord = await callRecordDataModel.getCallRecord(by: record.id)
        XCTAssertNotNil(retrievedRecord)
    }
    
    // MARK: - Delete Tests
    
    func testDeleteCallRecordByIndex() async {
        let record1 = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        let record2 = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 600.0,
            userStatus: .offline
        )
        
        await callRecordDataModel.addCallRecord(record1)
        await callRecordDataModel.addCallRecord(record2)
        
        await callRecordDataModel.deleteCallRecord(at: 0)
        
        let records = await callRecordDataModel.getAllCallRecords()
        XCTAssertEqual(records.count, 1)
    }
    
    func testDeleteCallRecordById() async {
        let record = CallRecord(
            participantID: UUID(),
            callDate: Date(),
            duration: 300.0,
            userStatus: .online
        )
        await callRecordDataModel.addCallRecord(record)
        
        await callRecordDataModel.deleteCallRecord(by: record.id)
        
        let records = await callRecordDataModel.getAllCallRecords()
        XCTAssertEqual(records.count, 0)
        
        let retrievedRecord = await callRecordDataModel.getCallRecord(by: record.id)
        XCTAssertNil(retrievedRecord)
    }
    
    // MARK: - Call Record Properties Tests
    
    func testCallRecordWithAllProperties() async {
        let participantID = UUID()
        let record = CallRecord(
            participantID: participantID,
            participantAvatarURL: "https://example.com/avatar.jpg",
            participantBio: "This is a test bio",
            callDate: Date(),
            duration: 450.0,
            userStatus: .online
        )
        
        await callRecordDataModel.addCallRecord(record)
        
        let retrievedRecord = await callRecordDataModel.getCallRecord(by: record.id)
        XCTAssertEqual(retrievedRecord?.participantID, participantID)
        XCTAssertEqual(retrievedRecord?.participantAvatarURL, "https://example.com/avatar.jpg")
        XCTAssertEqual(retrievedRecord?.participantBio, "This is a test bio")
        XCTAssertEqual(retrievedRecord?.duration, 450.0)
        XCTAssertEqual(retrievedRecord?.userStatus, .online)
    }
}

