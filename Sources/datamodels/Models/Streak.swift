//
//  Streak.swift
//  StoryboardsExample
//
//  Created by Harshdeep Singh on 05/11/25.
//

import Foundation

struct Streak: Codable {
    var currentCount: Int
    var longestCount: Int
    var lastActiveDate: Date?
}
