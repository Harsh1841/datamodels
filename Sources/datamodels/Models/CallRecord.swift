//
//  CallSession.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct CallRecord: Identifiable, Equatable, Codable {
    let id: UUID
    let participantID: UUID
    let participantAvatarURL: String?
    let participantBio: String?
    let callDate: Date
    let duration: TimeInterval
    let userStatus: UserStatus

    init(participantID: UUID, participantAvatarURL: String? = nil, participantBio: String? = nil, callDate: Date, duration: TimeInterval, userStatus: UserStatus) {
        self.id = UUID()
        self.participantID = participantID
        self.participantAvatarURL = participantAvatarURL
        self.participantBio = participantBio
        self.callDate = callDate
        self.duration = duration
        self.userStatus = userStatus
    }
    
    static func ==(lhs: CallRecord, rhs: CallRecord) -> Bool {
        return lhs.id == rhs.id
    }
}
 
