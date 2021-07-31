//
//  Move.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 03.07.2021.
//

import GameplayKit

protocol GameMove: AnyObject {
    associatedtype C: GameBoardCell & Hashable
    
    var playerId: Int { get }
    var cell: C { get }
}

class Move: NSObject, GKGameModelUpdate {
    
    let index: Int
    var value: Int = 0
    
    init(_ index: Int) {
        self.index = index
    }
}
