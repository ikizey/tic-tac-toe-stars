//
//  GameRulesBook.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

protocol GameRulesBook {
    associatedtype B: GameBoard
    associatedtype S: GameBoardSpace & Hashable
    associatedtype M: GameMove & Equatable
    associatedtype P: AnyObject
    
    // MARK: - board rules
    var boardRows: Int { get }
    var boardColumns: Int { get }
    
    var board: B { get set }
    var players: [P] { get set }
    
    // MARK: - Board spaces rules
    
    
    // MARK: - Players rules
    var maxPlayers: Int { get }
    var currentPlayer: P { get }
    // optional maxTeams: Int { get }
    
    // MARK: - moves rules
    func canMake(move: M) -> Bool
    
    // MARK: - turns
    
    
    // MARK: - Game Over
    func isTie() -> Bool
    func isWin(for player: P) -> Bool
    
    //optional isLoss(for player: P) -> Bool
    
    // MARK: - win conditions
    // var winSpaces: [S] { get }
    // MARK: - lose conditions
}
