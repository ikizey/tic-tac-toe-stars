//
//  Strategist.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 03.07.2021.
//

import GameplayKit

struct Strategist {
    
    private let strategist: GKMinmaxStrategist = {
        let strategist = GKMinmaxStrategist()
        
        strategist.maxLookAheadDepth = 5
        strategist.randomSource = GKARC4RandomSource()
        
        return strategist
    }()
    
    var model: GameSession {
        didSet {
            strategist.gameModel = model
        }
    }
    
    var bestMove: Int? {
        if let move = strategist.bestMove(for: model.currentPlayer) as? Move {
            return move.index
        }
        return nil
    }
}
