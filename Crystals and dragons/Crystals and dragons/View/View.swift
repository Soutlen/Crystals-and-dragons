//
//  View.swift
//  Crystals and dragons
//
//  Created by Евгений Глоба on 7/1/25.
//

import Foundation

struct ConsoleView {
    func showRoom(_ room: Room, player: Player) {
        print("You are at [\(player.pos.x), \(player.pos.y)]")
        print("Doors: \(room.doors.map{$0.rawValue}.joined(separator: ", "))")
        print("Items: \(room.items.map{$0.name}.joined(separator: ", "))")
        print("Steps left: \(player.stepsLeft).")
        print("Inventory: \(player.inventory.map{$0.name}.joined(separator: ", "))")
    }

    func showMessage(_ message: String) {
        print(message)
    }

    func prompt() {
        print("Enter command:")
    }
}
