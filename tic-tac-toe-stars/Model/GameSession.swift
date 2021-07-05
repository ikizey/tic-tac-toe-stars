//
//  GameSession.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import GameplayKit

class GameSession: NSObject {
    
    var withAI = false

    var board = GameBoard.board
    
    var currentPlayer: Player {
        allMoves.count.isMultiple(of: 2) ? Player.X : Player.O
    }
    
    func advance(with move: Int) {
        if currentPlayer.isX {
            moves.X.insert(move)
        } else {
            moves.O.insert(move)
        }
    }
    
    func restart() {
        moves.X.removeAll()
        moves.O.removeAll()
    }
    
    // MARK: - Moves
    let winMoves = [Set(arrayLiteral: 0, 1, 2), //rows
                    Set(arrayLiteral: 3, 4, 5),
                    Set(arrayLiteral: 6, 7, 8),
                    Set(arrayLiteral: 0, 3, 6), // colums
                    Set(arrayLiteral: 1, 4, 7),
                    Set(arrayLiteral: 2, 5, 8),
                    Set(arrayLiteral: 0, 4, 8), // diagonals
                    Set(arrayLiteral: 2, 4, 6)]
    
    var moves = (X: Set<Int>(),
                 O: Set<Int>())
    
    var remainingMoves: [Int] {
        Array(Set(board.cells).subtracting(allMoves))
    }
    
    var allMoves: Set<Int> {
        moves.X.union(moves.O)
    }
    
    var isEnded: Bool {
        moves.X.count == 5
    }
    
    func isPossible(move: Int) -> Bool {
        remainingMoves.contains(move)
    }
    
    var winCells: Set<Int>? {
        guard allMoves.count >= 5 else { return nil }
        
        var winCombination = Set<Int>()
        
        for moves in [moves.X, moves.O] {
            for winMove in winMoves {
                if winMove.isSubset(of: moves) {
                    winCombination.formUnion(winMove)
                }
            }
            if !winCombination.isEmpty { return winCombination }
        }
        return winCombination.isEmpty ? nil : winCombination
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
        if let gameSessionCopy = gameModel as? GameSession {
            moves.X = gameSessionCopy.moves.X
            moves.O = gameSessionCopy.moves.O
        }
    }
    
    var players: [GKGameModelPlayer]? {
        [Player.X, Player.O]
    }
    
    var activePlayer: GKGameModelPlayer? {
        currentPlayer
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else { return false }
        
        let playerMoves = player.playerId == 0 ? moves.X : moves.O
        for winMove in winMoves {
            if winMove.isSubset(of: playerMoves) {
                return true
            }
        }
        return false
    }
    
    func isLoss(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else { return false }
        
        if isWin(for: player.opponent) {
            return true
        }
        return false
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let _ = player as? Player else { return nil }
        let intMoves = remainingMoves
        if intMoves.isEmpty { return nil }
        
        var moves = [Move]()
        for move in intMoves {
            moves.append(Move(move))
        }
        if moves.isEmpty { return nil }
        return moves
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard  let move = gameModelUpdate as? Move else { return }
        advance(with: move.index)
    }

    // MARK: - Scoring
    
    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {
            return 0
        }
        
        if isWin(for: player) { return 5000 }
        if isLoss(for: player) { return -5000 }
        
        let playerMoves = player.isX ? moves.X : moves.O
        let opponentMoves = player.opponent.isX ? moves.X : moves.O
        
        let playerScore = movesCanLeadToWin(playerMoves: playerMoves, opponentMoves: opponentMoves)
        let opponentScore = movesCanLeadToWin(playerMoves: opponentMoves, opponentMoves: playerMoves)
        let score = playerScore - opponentScore
        
        return score == 0 ? playerScore : score
    }
    // not part of GKGameModel, just helper function
    func movesCanLeadToWin(playerMoves: Set<Int>, opponentMoves: Set<Int>) -> Int {
        var wins = winMoves
        
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
