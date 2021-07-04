//
//  Board.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

extension GameSession {
    
    struct GameBoard {
        
        let maxRows = 3
        let maxColumns = 3
        let cells: [Int]
        
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
            Array(Set(cells).subtracting(allMoves))
        }
        
        var allMoves: Set<Int> {
            moves.X.union(moves.O)
        }
        
        var isFull: Bool {
            moves.X.count == 5
        }
        
        func isPossible(move index: Int) -> Bool {
            remainingMoves.contains(index)
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
        
        init() {
            cells = Array(0..<maxRows * maxColumns)
        }
        
        mutating func reset() {
            moves.X.removeAll()
            moves.O.removeAll()
        }
    }
}
