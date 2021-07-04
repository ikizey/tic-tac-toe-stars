//
//  BoardCell.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 02.07.2021.
//

import SpriteKit
import AVFoundation

class BoardCell: SKShapeNode {

    var index: Int!
    
    private var image: SKSpriteNode!
    
    private let spinAction = SKAction.rotate(byAngle: .pi * CGFloat.random(in: 2...4),
                                             duration: 0.5)
    
    private let scaleInAction = SKAction.scale(by: 1.2, duration: 0.25)
    private let scaleOutAction = SKAction.scale(by: 0, duration: 1)
    
    private let removeAction = SKAction.customAction(withDuration: 1, actionBlock: { node, duration in
        node.removeFromParent()
    })
    
    func spinAndScale() {
        let spinAndScaleAc = SKAction.group([spinAction, scaleInAction])
        image.run(SKAction.sequence([spinAndScaleAc, scaleInAction.reversed()]))
    }
    
    func spin() {
        image.run(spinAction)
    }
    
    func mark(with texture: SKTexture) {
        image = SKSpriteNode(texture: texture)
        self.addChild(image)
        playSound()
        spin()
    }
    
    func unmark() {
        guard let image = image else { return }
        
        let actions = [scaleOutAction, removeAction]
        image.run(SKAction.sequence(actions))
    }
    
    func playSound() {
        let soundName = "Move.wav"
        self.run(.playSoundFileNamed(soundName, waitForCompletion: false))
    }
}
