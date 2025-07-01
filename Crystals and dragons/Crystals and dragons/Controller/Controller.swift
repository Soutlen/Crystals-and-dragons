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
    var view: ConsoleView()
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
        
    }
    
    func isDarkAndUnlit() {
        
    }
    
    func handleDarkRoom() {
        
    }
    
    func handleCommand() {
        
    }
    
    func handleGet() {
        
    }
    
    func handleDrop() {
        
    }
    
    func handleOpen() {
        
    }
    
    func move() {
        
    }
    
    func delta() {
        
    }
}
