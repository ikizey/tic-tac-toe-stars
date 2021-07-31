//
//  Move.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 03.07.2021.
//

import GameplayKit

class Move: NSObject, GameMove, GKGameModelUpdate {
    typealias S = BoardSpace
    
    let space: S
    let playerId: Int
    var value: Int = 0
    
    init(playerId: Int, space: S) {
        self.playerId = playerId
        self.space = space
    }
}
