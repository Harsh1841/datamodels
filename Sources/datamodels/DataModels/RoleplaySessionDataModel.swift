import Foundation

@MainActor
class RoleplaySessionDataModel {

    static let shared = RoleplaySessionDataModel()

    private let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!

    private let archiveURL: URL

    private var sessions: [RoleplaySession] = []

    private init() {
        archiveURL =
            documentsDirectory
            .appendingPathComponent("roleplaySessions")
            .appendingPathExtension("plist")

        loadSessions()
    }

    func getAllSessions() -> [RoleplaySession] {
        sessions
    }

    func getSessions(for userId: UUID) -> [RoleplaySession] {
        sessions.filter { $0.userId == userId }
    }

    func addSession(_ session: RoleplaySession) {
        sessions.append(session)
        saveSessions()
    }

    func updateSession(_ session: RoleplaySession) {
        if let index: Array<RoleplaySession>.Index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveSessions()
        }
    }

    func deleteSession(by id: UUID) {
        sessions.removeAll { $0.id == id }
        saveSessions()
    }

    func getSession(by id: UUID) -> RoleplaySession? {
        sessions.first { $0.id == id }
    }

    private func loadSessions() {
        if let data: Data = try? Data(contentsOf: archiveURL) {
            let decoder: PropertyListDecoder = PropertyListDecoder()
            sessions = (try? decoder.decode([RoleplaySession].self, from: data)) ?? []
        } else {
            sessions = []
        }
    }

    private func saveSessions() {
        let encoder: PropertyListEncoder = PropertyListEncoder()
        if let data: Data = try? encoder.encode(sessions) {
            try? data.write(to: archiveURL)
        }
    }
}