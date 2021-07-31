//
//  Board.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

import Foundation

protocol GameBoard {
    associatedtype S: GameBoardSpace & Hashable
    associatedtype M: GameMove & Equatable
    
    var spaces: [S] { get set }
    var isFull: Bool { get }
    var madeMoves: [M] { set get }
    var unoccupiedSpaces: [S] { get }
    
    mutating func make(move: M)
    mutating func reset()
}
