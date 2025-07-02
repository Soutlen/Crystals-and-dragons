//
//  main.swift
//  Crystals and dragons
//
//  Created by Евгений Глоба on 7/1/25.
//

import Foundation

print("Enter maze size (e.g. 4):")
let size = Int(readLine() ?? "4") ?? 4
let game = MazeGame(size: size)
game.play()

