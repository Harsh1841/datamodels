import Foundation

struct Activity: Equatable, Codable {
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
    
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
}

