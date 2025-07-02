//
//  Controller.swift
//  Crystals and dragons
//
//  Created by Евгений Глоба on 7/1/25.
//

import Foundation

final class MazeGame {
    var size: Int
    var player: Player
    var rooms: [[Room]]
    var keyPos: Position
    var chestPos: Position
    var darkRoom: Position
    var view = ConsoleView()
    var litRoom: Set<Position> = []
    var gameOver: Bool = false
    
    init(size: Int) {
        self.size = size
        self.player = Player(pos: Position(x: 0, y: 0), stepsLeft: size * size * 2)
        self.rooms = Array(repeating: Array(repeating: Room(), count: size), count: size)
        self.keyPos = MazeGame.randomPos(size: size, except: [])
        self.chestPos = MazeGame.randomPos(size: size, except: [keyPos, Position(x: 0, y: 0)])
        self.darkRoom = MazeGame.randomPos(size: size, except: [keyPos, chestPos, Position(x: 0, y: 0)])
        rooms[keyPos.y][keyPos.x].items.append(Item(name: "key"))
        rooms[chestPos.y][chestPos.x].items.append(Item(name: "chest"))
        generateMaze()
        
    }
    
    static func randomPos(size: Int, except: [Position]) -> Position {
        var pos: Position
        repeat {
            pos = Position(x: Int.random(in: 0..<size), y: Int.random(in: 0..<size))
        } while except.contains(pos)
        return pos
    }
    
    func generateMaze() {
        for y in 0..<size {
            for x in 0..<size {
                if y > 0 { rooms[y][x].doors.insert(.n) }
                if y < size - 1 { rooms[y][x].doors.insert(.s) }
                if x > 0 { rooms[y][x].doors.insert(.w) }
                if x < size - 1 { rooms[y][x].doors.insert(.e) }
            }
        }
        
        var torchPos: Position
        repeat {
            torchPos = Position(x: Int.random(in: 0..<size), y: Int.random(in: 0..<size))
        } while [keyPos, chestPos, Position(x: 0, y: 0), darkRoom].contains(torchPos)
        rooms[torchPos.y][torchPos.x].items.append(Item(name: "torchlight"))
    }
    
    func play() {
        view.showMessage("Welcome! Find the key and the chest to win.")
        while player.stepsLeft > 0 && !gameOver {
            let pos = player.pos
            if isDarkAndUnlit(at: pos) {
                handleDarkRoom()
                continue
            }
            let room = rooms[pos.y][pos.x]
            view.showRoom(room, player: player)
            view.prompt()
            guard let input = readLine()?.lowercased() else { continue }
            handleCommand(input)
        }
        if !gameOver {
            view.showMessage("You lost! No steps left.")
        }
    }
    
    func isDarkAndUnlit(at pos: Position) -> Bool {
        let inDarkRoom = pos == darkRoom
        let hasTorch = player.inventory.contains(where: { $0.name == "torchlight" })
        let isLit = litRoom.contains(pos)
        return inDarkRoom && (!hasTorch || !isLit)
    }
    
    func handleDarkRoom() {
        view.showMessage("Can't see anything in this dark place!")
        view.prompt()
        guard let input = readLine()?.lowercased() else { return }
        let parts = input.split(separator: " ").map { String($0) }
        if let command = parts.first {
            if ["n", "s", "e", "w"].contains(command) {
                if let dir = Direction(rawValue: command) { move(dir) }
            } else {
                view.showMessage("You can only move in the dark room!")
            }
        }
    }
    
    func handleCommand(_ input: String) {
        let pos = player.pos
        let room = rooms[pos.y][pos.x]
        let parts = input.split(separator: " ").map { String($0) }
        guard let command = parts.first else {
            view.showMessage("Unknown command.")
            return
        }
        
        switch command {
        case "n", "s", "e", "w":
            if let dir = Direction(rawValue: command) { move(dir)}
        case "get":
            handleGet(parts, room: room, pos: pos)
        case "drop":
            handleDrop(parts, pos: pos)
        case "open":
            handleOpen(room: room)
        default:
            view.showMessage("Unknown command.")
        }
    }
    
    func handleGet(_ parts: [String], room: Room, pos: Position) {
        guard parts.count > 1, let idx = room.items.firstIndex(where: { $0.name == parts[1] }) else {
            view.showMessage("No such item.")
            return
        }
        let item = room.items[idx]
        if item.name == "chest" {
            view.showMessage("You can't pick up the chest!")
            return
        }
        player.inventory.append(item)
        rooms[pos.y][pos.x].items.remove(at: idx)
        view.showMessage("You picked up \(parts[1])")
        if pos == darkRoom && item.name == "torchlight" {
            litRoom.insert(pos)
        }
    }
    
    func handleDrop(_ parts: [String], pos: Position) {
        guard parts.count > 1, let idx = player.inventory.firstIndex(where: { $0.name == parts[1] }) else {
            view.showMessage("No such item.")
            return
        }
        let item = player.inventory[idx]
        rooms[pos.y][pos.x].items.append(item)
        player.inventory.remove(at: idx)
        view.showMessage("You dropped \(parts[1])")
        if pos == darkRoom && item.name == "torchlight" {
            litRoom.insert(pos)
        }
    }
    
    func handleOpen(room: Room) {
        if room.items.contains(where: { $0.name == "chest" }) && player.inventory.contains(where: { $0.name == "key" }) {
            view.showMessage("You win!")
            gameOver = true
        } else {
            view.showMessage("You need a key and a chest in the room.")
        }
    }
    
    func move(_ dir: Direction) {
        let (dx, dy) = MazeGame.delta(for: dir)
        let newX = player.pos.x + dx
        let newY = player.pos.y + dy
        if newX >= 0, newX < size, newY >= 0, newY < size, rooms[player.pos.y][player.pos.x].doors.contains(dir) {
            player.pos = Position(x: newX, y: newY)
            player.stepsLeft -= 1
        } else {
            view.showMessage("Can't move in that direction.")
        }
    }
    
    static func delta(for dir: Direction) -> (Int, Int) {
        switch dir {
        case .n: return (0, -1)
        case .s: return (0, 1)
        case .e: return (1, 0)
        case .w: return (-1, 0)
        }
    }
}
