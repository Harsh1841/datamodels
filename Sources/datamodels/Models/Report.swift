import Foundation

struct Report: Identifiable, Codable, Sendable {
    let id: String                          
    let reporterUserID: String                  
    let reportedEntityID: String            
    let entityType: ReportedEntityType      
    let reason: ReportReason   
    let reasonDetails: String?             
    let message: String?                    
    let timestamp: Date                     
}


enum ReportedEntityType: String, Codable, Sendable {
    case user
    case callSession
    case jamSession
    case roleplaySession
}


enum ReportReason: String, Codable, Sendable {
    case inappropriateBehavior = "Inappropriate Behavior"
    case abusiveLanguage = "Abusive Language"
    case spam = "Spam / Advertising"
    case harassment = "Harassment / Bullying"
    case fakeProfile = "Fake / Impersonation"
    case other = "Other"
}
