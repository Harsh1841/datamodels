//
//  ReportDataModelTests.swift
//  datamodelsTests
//
//  Created by Harshdeep Singh on 05/11/25.
//

import XCTest
@testable import datamodels

final class ReportDataModelTests: XCTestCase {
    
    var reportDataModel: ReportDataModel!
    
    override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            reportDataModel = ReportDataModel.shared
        }
        
        // Clear existing data
        let allReports = await reportDataModel.getAllReports()
        for report in allReports {
            await reportDataModel.deleteReport(by: report.id)
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Create Tests
    
    func testAddReport() async {
        let report = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: "Test details",
            message: "Test message",
            timestamp: Date()
        )
        
        await reportDataModel.addReport(report)
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, 1)
        XCTAssertEqual(reports.first?.id, "report1")
        XCTAssertEqual(reports.first?.entityType, .user)
    }
    
    // MARK: - Read Tests
    
    func testGetAllReports() async {
        let report1 = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report2 = Report(
            id: "report2",
            reporterUserID: "user2",
            reportedEntityID: "entity2",
            entityType: .callSession,
            reason: .spam,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        
        await reportDataModel.addReport(report1)
        await reportDataModel.addReport(report2)
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, 2)
    }
    
    func testGetReportById() async {
        let report = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        await reportDataModel.addReport(report)
        
        let retrievedReport = await reportDataModel.getReport(by: "report1")
        XCTAssertNotNil(retrievedReport)
        XCTAssertEqual(retrievedReport?.id, "report1")
    }
    
    func testGetReportsByReporterUserID() async {
        let report1 = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report2 = Report(
            id: "report2",
            reporterUserID: "user1",
            reportedEntityID: "entity2",
            entityType: .callSession,
            reason: .spam,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report3 = Report(
            id: "report3",
            reporterUserID: "user2",
            reportedEntityID: "entity3",
            entityType: .jamSession,
            reason: .harassment,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        
        await reportDataModel.addReport(report1)
        await reportDataModel.addReport(report2)
        await reportDataModel.addReport(report3)
        
        let user1Reports = await reportDataModel.getReports(byReporterUserID: "user1")
        XCTAssertEqual(user1Reports.count, 2)
        
        let user2Reports = await reportDataModel.getReports(byReporterUserID: "user2")
        XCTAssertEqual(user2Reports.count, 1)
    }
    
    func testGetReportsByReportedEntityID() async {
        let report1 = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report2 = Report(
            id: "report2",
            reporterUserID: "user2",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .spam,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report3 = Report(
            id: "report3",
            reporterUserID: "user3",
            reportedEntityID: "entity2",
            entityType: .callSession,
            reason: .harassment,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        
        await reportDataModel.addReport(report1)
        await reportDataModel.addReport(report2)
        await reportDataModel.addReport(report3)
        
        let entity1Reports = await reportDataModel.getReports(byReportedEntityID: "entity1")
        XCTAssertEqual(entity1Reports.count, 2)
        
        let entity2Reports = await reportDataModel.getReports(byReportedEntityID: "entity2")
        XCTAssertEqual(entity2Reports.count, 1)
    }
    
    // MARK: - Update Tests
    
    func testUpdateReport() async {
        let report = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: "Original details",
            message: "Original message",
            timestamp: Date()
        )
        await reportDataModel.addReport(report)
        
        var updatedReport = report
        updatedReport = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .spam,
            reasonDetails: "Updated details",
            message: "Updated message",
            timestamp: Date()
        )
        await reportDataModel.updateReport(updatedReport)
        
        let retrievedReport = await reportDataModel.getReport(by: "report1")
        XCTAssertEqual(retrievedReport?.reason, .spam)
        XCTAssertEqual(retrievedReport?.reasonDetails, "Updated details")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteReportByIndex() async {
        let report1 = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        let report2 = Report(
            id: "report2",
            reporterUserID: "user2",
            reportedEntityID: "entity2",
            entityType: .callSession,
            reason: .spam,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        
        await reportDataModel.addReport(report1)
        await reportDataModel.addReport(report2)
        
        await reportDataModel.deleteReport(at: 0)
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, 1)
    }
    
    func testDeleteReportById() async {
        let report = Report(
            id: "report1",
            reporterUserID: "user1",
            reportedEntityID: "entity1",
            entityType: .user,
            reason: .inappropriateBehavior,
            reasonDetails: nil,
            message: nil,
            timestamp: Date()
        )
        await reportDataModel.addReport(report)
        
        await reportDataModel.deleteReport(by: "report1")
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, 0)
        
        let retrievedReport = await reportDataModel.getReport(by: "report1")
        XCTAssertNil(retrievedReport)
    }
    
    // MARK: - Report Entity Types Tests
    
    func testAllReportEntityTypes() async {
        let entityTypes: [ReportedEntityType] = [.user, .callSession, .jamSession, .roleplaySession]
        
        for (index, entityType) in entityTypes.enumerated() {
            let report = Report(
                id: "report\(index)",
                reporterUserID: "user1",
                reportedEntityID: "entity\(index)",
                entityType: entityType,
                reason: .inappropriateBehavior,
                reasonDetails: nil,
                message: nil,
                timestamp: Date()
            )
            await reportDataModel.addReport(report)
        }
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, entityTypes.count)
    }
    
    // MARK: - Report Reasons Tests
    
    func testAllReportReasons() async {
        let reasons: [ReportReason] = [.inappropriateBehavior, .abusiveLanguage, .spam, .harassment, .fakeProfile, .other]
        
        for (index, reason) in reasons.enumerated() {
            let report = Report(
                id: "report\(index)",
                reporterUserID: "user1",
                reportedEntityID: "entity\(index)",
                entityType: .user,
                reason: reason,
                reasonDetails: nil,
                message: nil,
                timestamp: Date()
            )
            await reportDataModel.addReport(report)
        }
        
        let reports = await reportDataModel.getAllReports()
        XCTAssertEqual(reports.count, reasons.count)
    }
}

