// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct datamodels {
    static func main() {
        RoleplayRepository.shared.createRoleplay(Roleplay(title: "Job Interview", category: .interview, predefinedScript: []))
        RoleplayRepository.shared.createRoleplay(Roleplay(title: "Grocery Shopping", category: .groceryShopping, predefinedScript: []))
        RoleplayRepository.shared.createRoleplay(Roleplay(title: "Restaurant", category: .restaurant, predefinedScript: []))
        RoleplayRepository.shared.createRoleplay(Roleplay(title: "Travel", category: .travel, predefinedScript: []))
        RoleplayRepository.shared.createRoleplay(Roleplay(title: "Custom Roleplay", category: .custom, predefinedScript: []))
        print("Hello, World!")
    }
}
