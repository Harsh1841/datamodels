//
//  CallRecordDataModel.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
class CallRecordDataModel {
    
    static let shared = CallRecordDataModel()
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let archiveURL: URL
    
    private var callRecords: [CallRecord] = []
    
    private init() {
        archiveURL = documentsDirectory.appendingPathComponent("callRecords").appendingPathExtension("plist")
        loadCallRecords()
    }
    
    // MARK: - Public Methods
    
    func getAllCallRecords() -> [CallRecord] {
        return callRecords
    }
    
    func addCallRecord(_ callRecord: CallRecord) {
        callRecords.append(callRecord)
        saveCallRecords()
    }
    
    func updateCallRecord(_ callRecord: CallRecord) {
        if let index = callRecords.firstIndex(where: { $0.id == callRecord.id }) {
            callRecords[index] = callRecord
            saveCallRecords()
        }
    }
    
    func deleteCallRecord(at index: Int) {
        callRecords.remove(at: index)
        saveCallRecords()
    }
    
    func deleteCallRecord(by id: UUID) {
        callRecords.removeAll(where: { $0.id == id })
        saveCallRecords()
    }
    
    func getCallRecord(by id: UUID) -> CallRecord? {
        return callRecords.first(where: { $0.id == id })
    }
    
    // MARK: - Private Methods
    
    private func loadCallRecords() {
        if let savedCallRecords = loadCallRecordsFromDisk() {
            callRecords = savedCallRecords
        } else {
            callRecords = loadSampleCallRecords()
        }
    }
    
    private func loadCallRecordsFromDisk() -> [CallRecord]? {
        guard let codedCallRecords = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([CallRecord].self, from: codedCallRecords)
    }
    
    private func saveCallRecords() {
        let propertyListEncoder = PropertyListEncoder()
        let codedCallRecords = try? propertyListEncoder.encode(callRecords)
        try? codedCallRecords?.write(to: archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleCallRecords() -> [CallRecord] {
        // Return empty array as sample - call records require actual call data
        return []
    }
}

