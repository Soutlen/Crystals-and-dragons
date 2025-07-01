//
//  Model.swift
//  Crystals and dragons
//
//  Created by Евгений Глоба on 7/1/25.
//

import Foundation

enum Direction: String, CaseIterable {
    case n = "n", s = "s", e = "e", w = "w"
}

struct Position: Equatable, Hashable {
    var x: Int
    var y: Int
}

struct Item: Equatable {
    var name: String
}

struct Room {
    var items: [Item] = []
    var doors: Set<Direction> = []
}

struct Player {
    var pos: Position
    var inventory: [Item] = []
    var stepsLeft: Int
}
