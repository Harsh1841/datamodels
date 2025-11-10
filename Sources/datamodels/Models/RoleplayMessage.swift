import Foundation

struct RoleplayMessage: Identifiable, Codable {
    let id: UUID
    let sender: String
    let message: String
    let timestamp: Date

    init(sender: String, message: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.sender = sender
        self.message = message
        self.timestamp = timestamp
    }
    
}

