//
//  GameSession.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import GameplayKit

class GameSession: NSObject {
    
    var withAI = false

    var board = GameBoard()
    
    var currentPlayer: Player {
        board.allMoves.count.isMultiple(of: 2) ? Player.X : Player.O
    }
    
    func progress(with index: Int) {
        if currentPlayer.isX {
            board.moves.X.insert(index)
        } else {
            board.moves.O.insert(index)
        }
    }
}


extension GameSession: GKGameModel {
    
    // MARK: - NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameSession()
        copy.setGameModel(self)
        return copy
    }
    
    
    func setGameModel(_ gameModel: GKGameModel) {
        print(#function)
        if let gameSessionCopy = gameModel as? GameSession {
            board.moves.X = gameSessionCopy.board.moves.X
            board.moves.O = gameSessionCopy.board.moves.O
        }
    }
    
    // MARK: - GKGameModel
    
    var players: [GKGameModelPlayer]? {
        return [Player.X, Player.O]
    }
    
    var activePlayer: GKGameModelPlayer? {
        currentPlayer
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Player else { return false }
        
        let playerMoves = player.playerId == 0 ? board.moves.X : board.moves.O
        for winMove in board.winMoves {
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
        let intMoves = board.remainingMoves
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
        progress(with: move.index)
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Player else {
            return 0
        }
        
        if isWin(for: player) { return 5000 }
        if isLoss(for: player) { return -5000 }
        
        let moves1 = player.isX ? board.moves.X : board.moves.O
        let moves2 = player.opponent.isX ? board.moves.X : board.moves.O
        
        
        print(">>player: \(player.playerId), moves: \(moves1)")
        print("oppplayer: \(player.opponent.playerId), moves: \(moves2)")
        var wins1 = board.winMoves
        for (i, win) in wins1.enumerated().reversed() {
            let intersection = win.intersection(moves2)
            if !intersection.isEmpty {
                wins1.remove(at: i)
            }
        }
        print("wins: \(wins1)")
        var intersections1 = [Int]()
        for winMove in wins1 {
            intersections1.append(winMove.intersection(moves1).count)
            //print("my moves: \(moves1)")
            //print("moves | wins \(winMove.intersection(moves1))")
            //print(winMove.intersection(moves1).count)
            //print("------------------")
        }
        print("||: \(intersections1)")
        print(">>>>>>>: \(intersections1.filter({$0 != 0}).count)")
        print("------------------")
        
        
        
        var wins2 = board.winMoves
        for (i, win) in wins1.enumerated().reversed() {
            let intersection = win.intersection(moves1)
            if !intersection.isEmpty {
                wins2.remove(at: i)
            }
        }
        print("wins: \(wins2)")
        let intersections2 = [Int]()
        for winMove in wins2 {
            intersections1.append(winMove.intersection(moves2).count)
            //print("my moves: \(moves1)")
            //print("moves | wins \(winMove.intersection(moves1))")
            //print(winMove.intersection(moves1).count)
            //print("------------------")
        }
        print("||: \(intersections2)")
        print(">>>>>>>: \(intersections2.filter({$0 != 0}).count)")
        print("------------------")
        
        var score = intersections1.filter({$0 != 0}).count - intersections2.filter({$0 != 0}).count
        if score == 0 {
            score = intersections1.filter({$0 != 0}).count
        }
        
        return score
    }
}
