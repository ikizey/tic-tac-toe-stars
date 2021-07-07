//
//  BoardCell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import SpriteKit

class BoardCell: SKShapeNode {

    var index: Int!
    
    private let textures = Texutre.textures
    private var image: SKSpriteNode!

    func update(byPlayer playerId: Int? = nil) {
        if let playerId = playerId {
            image = SKSpriteNode(texture: textures[playerId])
            addChild(image)
        }
        image.run(SKAction.spinAndSound)
    }
    
    func clear() {
        guard image != nil else { return }
        
        image.run(SKAction.remove)
    }
}

// MARK: - Actions

extension SKAction {
    static var remove: SKAction = {
        let scaleOut = SKAction.scale(by: 0, duration: 1)
        let rm = SKAction.customAction(withDuration: 1, actionBlock: { node, duration in
            node.removeFromParent()
        })
        let spinOutAndScaleGroup = SKAction.group([SKAction.randomSpin, scaleOut])
        return SKAction.sequence([spinOutAndScaleGroup, rm])
    }()
    
    static var spinAndSound: SKAction = {
        let scaleIn = SKAction.scale(by: 1.2, duration: 0.25)
        let playTapSound = SKAction.playSoundFileNamed("Move.wav", waitForCompletion: false)
        let spinInAndScaleGroup = SKAction.group([SKAction.randomSpin, scaleIn])
        let spinAndScale = SKAction.sequence([spinInAndScaleGroup,
                                              spinInAndScaleGroup.reversed()])
        return SKAction.group([spinAndScale, playTapSound])
    }()
    
    private static var randomSpin: SKAction {
        //let direction = CGFloat([-1, 1].randomElement()!) // not fun
        let rotations = CGFloat.random(in: 2...4)
        let action = SKAction.rotate(byAngle: /*direction * */.pi * rotations, duration: 0.5)
        return action
    }
}

// MARK: - Textures

extension BoardCell {
    
    struct Texutre {
        static let textures = [SKTexture(imageNamed: "star"), SKTexture(imageNamed: "butterfly")]
        private init() {}
    }
}
