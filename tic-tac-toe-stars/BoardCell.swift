//
//  BoardCell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import SpriteKit

class BoardCell: SKShapeNode {

    var index: Int!
    
    let action = Action.do
    
    private var image: SKSpriteNode!
    
    func spinAndScale() {
        image.run(action.spinAndScale)
    }
    
    func spin() {
        image.run(Action.spin)
    }
    
    func mark(with texture: SKTexture) {
        image = SKSpriteNode(texture: texture)
        addChild(image)
        playSound()
        spin()
    }
    
    func unmark() {
        guard let image = image else { return }

        image.run(action.remove)
    }
    
    func playSound() {
        run(action.playTapSound)
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
            remove = SKAction.sequence([scaleOut, rm])
            
            let spinAndScaleGroup = SKAction.group([Action.spin, scaleIn])
            spinAndScale = SKAction.sequence([spinAndScaleGroup,
                                              spinAndScaleGroup.reversed()])
            
            let soundName = "Move.wav"
            playTapSound = .playSoundFileNamed(soundName, waitForCompletion: false)
        }
    }
    
}
