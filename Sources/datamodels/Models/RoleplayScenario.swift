import Foundation

struct RoleplayScenario: Identifiable, Codable, Equatable {

    let id: UUID
    let title: String
    let description: String
    let imageName: String
    let category: RoleplayCategory
    let difficulty: RoleplayDifficulty
    let estimatedTimeMinutes: Int
    let script: [String]

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageName: String,
        category: RoleplayCategory,
        difficulty: RoleplayDifficulty,
        estimatedTimeMinutes: Int,
        script: [String]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.category = category
        self.difficulty = difficulty
        self.estimatedTimeMinutes = estimatedTimeMinutes
        self.script = script
    }
}
