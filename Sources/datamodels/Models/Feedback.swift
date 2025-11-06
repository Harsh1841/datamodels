
import Foundation

enum SessionFeedbackRating: String, Codable {
    case excellent
    case good
    case average
    case poor
}

enum SessionFeedbackType: String, Codable {
    case callSession
    case jamSession
}

enum Issue {
    case longPauses
    case unclearSpeech
    case fillerWords
    case wrongPronunciation
}

struct Feedback: Codable {
    let comments: String
    let rating: SessionFeedbackRating
    let wordsPerMinute: Double
    let durationInSeconds: Double
    let totalWords: Int
    let transcript: String
}