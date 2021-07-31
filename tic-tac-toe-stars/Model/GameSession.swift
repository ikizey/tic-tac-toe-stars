//
//  GameSession.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import GameplayKit

class GameSession: NSObject {
    
    var withAI = false
    var byRules = TTTRulesBook3x3()
    
    func restart() {
        byRules.board.reset()
    }
    
    private func generateMove(from index: Int) -> Move {
        let space = byRules.board.spaces.filter({ $0.position == index }).first!
        let playerId = byRules.currentPlayer.playerId
        return Move(playerId: playerId, space: space)
    }
    
    func canMake(move: Int) -> Bool {
        let move = generateMove(from: move)
        return byRules.canMake(move: move)
    }
    
    func advance(with index: Int) {
        let move = generateMove(from: index)
        byRules.advance(with: move)
    }
}

// MARK: - GKGameModel

extension GameSession: GKGameModel {
    
    // MARK: - NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameSession()
        copy.setGameModel(self)
        return copy
    }
    
    // MARK: - GKGameModel
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let gameSessionOriginal = gameModel as? GameSession {
            byRules.board.madeMoves = gameSessionOriginal.byRules.board.madeMoves
        }
    }
    
    var players: [GKGameModelPlayer]? {
        byRules.players
    }
    
    var activePlayer: GKGameModelPlayer? {
        byRules.currentPlayer
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else { return false }
        
        return byRules.isWin(for: player)
    }
    
    func isLoss(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else { return false }
        
        return byRules.isWin(for: player.opponent)
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let _ = player as? Player else { return nil }
        guard !byRules.board.isFull else { return nil }
        
        var moves = [Move]()
        for space in byRules.board.unoccupiedSpaces {
            moves.append(Move(playerId: player.playerId, space: space))
        }
        return moves
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard  let move = gameModelUpdate as? Move else { return }
        byRules.advance(with: move)
    }

    // MARK: - Scoring
    
    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {
            return 0
        }
        
        if isWin(for: player) { return 5000 }
        if isLoss(for: player) { return -5000 }
        
        let playerMoves = byRules.movesPositions(for: player)
        let opponentMoves = byRules.movesPositions(for: player.opponent)
        
        let playerScore = movesCanLeadToWin(playerMoves: playerMoves, opponentMoves: opponentMoves)
        let opponentScore = movesCanLeadToWin(playerMoves: opponentMoves, opponentMoves: playerMoves)
        let score = playerScore - opponentScore
        
        return score == 0 ? playerScore : score
    }
    // not part of GKGameModel, just helper function
    func movesCanLeadToWin(playerMoves: Set<Int>, opponentMoves: Set<Int>) -> Int {
        // IMITATING OLD WAY, BEFORE RULE BOOK
        var wins = [
            byRules.movesPositions(for: Player.X),
            byRules.movesPositions(for: Player.O)
        ]
        
        // remove from win combinations all, that blocked by opponent
        for (i, win) in wins.enumerated().reversed() {
            let intersection = win.intersection(opponentMoves)
            if !intersection.isEmpty {
                wins.remove(at: i)
            }
        }
        
        var intersections = [Int]()
        #warning("alg can be wastly improved")
        for winMove in wins {
            intersections.append(winMove.intersection(playerMoves).count)
        }
        
        return intersections.filter({$0 != 0}).count
    }
}
