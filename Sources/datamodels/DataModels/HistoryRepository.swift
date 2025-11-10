import Foundation

@MainActor
final class HistoryRepository {

    static let shared = HistoryRepository()
    private init() {}

    private var history: [Activity] = []

    func addActivity(_ activity: Activity) {
        history.append(activity)
    }

    func getHistory() -> [Activity] {
        return history
    }

    func searchHistory(by type: ActivityType) -> [Activity] {
        return history.filter { $0.type == type }
    }
}
