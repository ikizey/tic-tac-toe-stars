//
//  BoardCell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import SpriteKit

class BoardCell: SKShapeNode {

    var index: Int!
    
    private let action = Action.do
    private let textures = Texutre.textures
    private var image: SKSpriteNode!

    func update(byPlayer playerId: Int? = nil) {
        if let playerId = playerId {
            image = SKSpriteNode(texture: textures[playerId])
            addChild(image)
        }
        image.run(action.spinAndSound)
    }
    
    func clear() {
        guard image != nil else { return }
        
        image.run(action.remove)
    }
}

// MARK: - Actions

extension BoardCell {
    
    struct Action {
        
        static let `do` = Action()
        
        let scaleIn: SKAction
        let scaleOut: SKAction
        let remove: SKAction
        let spinAndScale: SKAction
        let spinAndSound: SKAction
        
        static var spin: SKAction {
            //let direction = CGFloat([-1, 1].randomElement()!) // not fun
            let rotations = CGFloat.random(in: 2...4)
            let action = SKAction.rotate(byAngle: /*direction * */.pi * rotations, duration: 0.5)
            return action
        }
        
        let playTapSound: SKAction
        
        private init() {
            scaleIn = SKAction.scale(by: 1.2, duration: 0.25)
            
            scaleOut = SKAction.scale(by: 0, duration: 1)
            
            let rm = SKAction.customAction(withDuration: 1, actionBlock: { node, duration in
                node.removeFromParent()
            })
            let spinOutAndScaleGroup = SKAction.group([Action.spin, scaleOut])
            remove = SKAction.sequence([spinOutAndScaleGroup, rm])
            
            let spinInAndScaleGroup = SKAction.group([Action.spin, scaleIn])
            spinAndScale = SKAction.sequence([spinInAndScaleGroup,
                                              spinInAndScaleGroup.reversed()])
            
            let soundName = "Move.wav"
            playTapSound = .playSoundFileNamed(soundName, waitForCompletion: false)
            
            let group = SKAction.group([spinAndScale, playTapSound])
            spinAndSound = group
        }
    }
}

// MARK: - Textures

extension BoardCell {
    
    struct Texutre {
        static let textures = [SKTexture(imageNamed: "star"), SKTexture(imageNamed: "butterfly")]
        private init() {}
    }
}
