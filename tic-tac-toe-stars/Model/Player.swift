//
//  Player.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import GameplayKit

extension GameSession {
    
    class Player: NSObject, GKGameModelPlayer {
        
        static private var players = [Player(id: 0), Player(id: 1)]

        static var X: Player {
            Player.players[0]
        }
        static var O: Player {
            Player.players[1]
        }

        var playerId: Int
        
        var name: String {
            self == Player.X ? "Star" : "Butterfly"
        }
        var opponent: Player {
            self == Player.X ? Player.O : Player.X
        }
        var isX: Bool {
            self == Player.X
        }
        var isO: Bool {
            !isX
        }
        
        init(id: Int) {
            playerId = id
        }
        static func == (lhs: Player, rhs: Player) -> Bool {
            lhs.playerId == rhs.playerId
        }
    }
}


