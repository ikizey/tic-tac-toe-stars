//
//  GameBoardCell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

enum SpaceType {
    case on, off
}

protocol GameBoardSpace {
    var position: Int { get }
    var type: SpaceType { get }
}
