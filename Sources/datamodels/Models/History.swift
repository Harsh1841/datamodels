

import Foundation


enum ActivityType: String, Codable {
    case call = "image url for call"
    case jam = "image url for jam"
    case roleplay = "image url for roleplay"
}

struct History: Codable {
    var history: [Activity]
}

struct Activity: Codable {
    let id: UUID
    let type: ActivityType
    let date: Date
    let imageURL: String
    init( type: ActivityType, date: Date) {
        self.id = UUID()
        self.type = type
        self.date = date
        self.imageURL = type.rawValue
    }
}
