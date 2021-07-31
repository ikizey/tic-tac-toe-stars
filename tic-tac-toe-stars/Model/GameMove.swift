//
//  GameMove.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

protocol GameMove: AnyObject {
    associatedtype S: GameBoardSpace & Hashable
    
    var playerId: Int { get }
    var space: S { get }
}
