//
//  Board.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

struct Board<S, M>: GameBoard where M: GameMove & Equatable, M.S == S {
    
    var spaces: [S]
    var madeMoves: [M]
    var unoccupiedSpaces: [S] {
        let setSpaces = Set(spaces)
        let setUsedSpaces: Set<S> = Set(madeMoves.map({ $0.space }))
        return Array(setSpaces.subtracting(setUsedSpaces))
    }
    var isEmpty: Bool { madeMoves.isEmpty }
    var isFull: Bool {
        spaces.filter( {$0.type == .on} ).count == madeMoves.count
    }
    
    init(spaces: [S], moves: [M] = [M]()) {
        self.spaces = spaces
        self.madeMoves = moves
    }
    
    mutating func make(move: M) {
        madeMoves.append(move)
    }
    
    mutating func reset() {
        madeMoves.removeAll()
    }
}





