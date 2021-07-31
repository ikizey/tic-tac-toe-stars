//
//  TTTRulesBook3x3.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

struct TTTRulesBook3x3: GameRulesBook {
    typealias S = BoardSpace
    typealias P = Player
    typealias M = Move
    
    let boardRows = 3
    let boardColumns = 3
    
    var board: Board<S, M> = {
        var spaces = [S]()
        for i in 0..<9 {
            spaces.append(S(position: i, type: .on))
        }
        return Board(spaces: spaces)
    }()
    
    var players: [P] = [Player.X, Player.O]
    
    let maxPlayers = 2
    
    var currentPlayer: P {
        board.madeMoves.count.isMultiple(of: 2) ? P.X : P.O
    }
    
    func isTie() -> Bool {
        // should only be called if isWin for all players is false
        guard board.isFull else { return false }
        return true
    }
    
    func isWin(for player: P) -> Bool {
        let positions = movesPositions(for: player)
        for winPositionSet in winPositions {
            if winPositionSet.isSubset(of: positions) {
                return true
            }
        }
        return false
    }
    
    private func winningPlayer() -> P? {
        for player in players {
            if isWin(for: player) {
                return player
            }
        }
        return nil
    }
    
    mutating func advance(with move: M) {
        board.make(move: move)
    }
    
    // MARK: - Moves
    private let winPositions = [Set(arrayLiteral: 0, 1, 2), //rows
                                Set(arrayLiteral: 3, 4, 5),
                                Set(arrayLiteral: 6, 7, 8),
                                Set(arrayLiteral: 0, 3, 6), // colums
                                Set(arrayLiteral: 1, 4, 7),
                                Set(arrayLiteral: 2, 5, 8),
                                Set(arrayLiteral: 0, 4, 8), // diagonals
                                Set(arrayLiteral: 2, 4, 6)]
    
    var winSpacesPositions: [Int]? {
        guard board.madeMoves.count >= 5 else { return nil }
        guard let player = winningPlayer() else { return nil }
        
        let playerMoves = movesPositions(for: player)
        
        var winCombination = Set<Int>()
        for winMoves in winPositions {
            if winMoves.isSubset(of: playerMoves) {
                winCombination.formUnion(winMoves)
            }
        }
        return winCombination.isEmpty ? nil : Array(winCombination)
    }
    
    func movesPositions(for player: P) -> Set<Int> {
        let thisPlayerId = player.playerId
        let moves = board.madeMoves.filter { $0.playerId == thisPlayerId }
        let positions = moves.map( {$0.space.position })
        return Set(positions)
    }
    
    func canMake(move: M) -> Bool {
        board.unoccupiedSpaces.contains(move.space)
            && move.space.type == .on
            
            ? true : false
    }
}
