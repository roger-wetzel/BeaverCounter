//
//  Game.swift
//  Beaver Counter
//
//  Copyright © 2020 Roger Wetzel. All rights reserved.
//

import Foundation

class Game {
    let maxRounds = 6

    var players = [Player]()
    
    var round: Int?

    var numberOfPlayers: Int? {
        didSet {
            players = [Player]()
            for _ in 0..<numberOfPlayers! {
                let player = Player()
                players.append(player)
            }
        }
    }
    
    func addUpScores() {
        for player in players {
            player.addUpScore()
        }
    }
    
    func nextRound() {
        if round != nil {
            round! += 1
        }
    }
    
    func isEndOfGame() -> Bool {
        var endOfGame = false
        if let currentRound = round {
            endOfGame = currentRound > maxRounds
        }
        return endOfGame
    }
}
