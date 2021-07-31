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
    
    var game: GameSession {
        didSet {
            strategist.gameModel = game
        }
    }
    
    var bestMove: Move? {
        if let move = strategist.bestMove(for: game.byRules.currentPlayer) as? Move {
            return move
        }
        return nil
    }
}
