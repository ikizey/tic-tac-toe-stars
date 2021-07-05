//
//  Board.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

extension GameSession {
    
    struct GameBoard {
        
        static let board = GameBoard()
        
        let maxRows = 3
        let maxColumns = 3
        let cells: [Int]
        
        private init() {
            cells = Array(0..<maxRows * maxColumns)
        }
    }
}
