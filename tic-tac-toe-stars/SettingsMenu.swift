//
//  SettingsMenu.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 03.07.2021.
//

import SpriteKit

struct SettingsMenu {
    
    var sprite: SKSpriteNode!
    var size: CGSize
    var inactivePosition: CGPoint
    var activePosition: CGPoint
    var isActive: Bool {
        didSet {
            if isActive {
                sprite.run(SKAction.move(to: activePosition, duration: 0.2))
            } else {
                sprite.run(SKAction.move(to: inactivePosition, duration: 0.2))
            }
        }
    }
    private func addCloseSprite() {
        let close = SKSpriteNode(imageNamed: "moon")
        
        close.position = CGPoint(x: size.width - 200, y: size.height - 200) // !! WHY -200 works??
        close.zPosition = 3

        sprite.addChild(close)
        
    }
    
    mutating func createSprite(at scene: SKScene) {
        sprite = SKSpriteNode(color: UIColor.purple, size: size)
        sprite.zPosition = 2
        sprite.position = inactivePosition
        sprite.name = "SettingsWindow"
        
        addCloseSprite()
        scene.addChild(sprite)
    }
    
    
    
}
