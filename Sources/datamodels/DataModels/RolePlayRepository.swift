//
//  RoleplayRepository.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

@MainActor
final class RoleplayRepository {

    static let shared = RoleplayRepository()
    private init() {}

    private var roleplays: [Roleplay] = []

    func createRoleplay(_ roleplay: Roleplay) {
        roleplays.append(roleplay)
    }

    func getAllRoleplays() -> [Roleplay] {
        return roleplays
    }

    func getRoleplay(by id: UUID) -> Roleplay? {
        return roleplays.first(where: { $0.id == id })
    }

    func updateRoleplay(_ updatedRoleplay: Roleplay) {
        if let index = roleplays.firstIndex(where: { $0.id == updatedRoleplay.id }) {
            roleplays[index] = updatedRoleplay
        }
    }

    func deleteRoleplay(by id: UUID) {
        roleplays.removeAll(where: { $0.id == id })
    }

    func searchRoleplays(by title: String) -> [Roleplay] {
        return roleplays.filter { $0.title.lowercased().contains(title.lowercased()) }
    }
}


