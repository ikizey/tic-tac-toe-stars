//
//  Cell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 31.07.2021.
//

struct BoardSpace: GameBoardSpace & Hashable {
    var position: Int
    var type: SpaceType
    
    init(position: Int) {
        self.position = position
        self.type = .on
    }
    
    init(position: Int, type: SpaceType) {
        self.position = position
        self.type = type
    }
}
