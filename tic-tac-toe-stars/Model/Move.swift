//
//  Move.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 03.07.2021.
//

import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    
    let index: Int
    var value: Int = 0
    
    init(_ index: Int) {
        self.index = index
    }
}
