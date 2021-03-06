//
//  NewGameScene.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 04.07.2021.
//

import SpriteKit

class NewGameScene: SKScene {
    
    weak var gameScene: TicTacToeScene!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        addBackground()

        addNewGameButton()
        addNewGameWithAIButton()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = center
        background.zPosition = -1
        background.blendMode = .replace
        background.size = size
        addChild(background)
    }
    
    private func addNewGameButton() {
        var pos = center
        pos.y += 70
        addButton(withText: "Start New Game", at: pos)
    }
    
    private func addNewGameWithAIButton() {
        var pos = center
        pos.y -= 70
        addButton(withText: "Start New Game with AI", at: pos)
    }
    
    private func addButton(withText text: String, at position: CGPoint) {
        let label = SKLabelNode()
        label.text = text
        label.fontName = "Chalkduster"
        label.fontColor = UIColor.white
        label.fontSize = 25
        label.position.y -= 10
        
        let buttonSize = CGSize(width: label.frame.size.width + 10, height: label.frame.size.height + 10)
        let buttonFrame = SKShapeNode(rectOf: buttonSize)
        
        let buttonBG = SKSpriteNode(color: UIColor.systemIndigo, size: buttonSize)
        buttonBG.position = position
        buttonBG.name = text
        
        buttonBG.addChild(buttonFrame)
        buttonBG.addChild(label)
        addChild(buttonBG)
    }
    
    func handleTouchEnd(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let touchedNodes = nodes(at: touch.location(in: self))
        
        for node in touchedNodes {
            if node.name == "Start New Game" {
                StartNewGame()
                return
            } else if node.name == "Start New Game with AI" {
                StartNewGameWithAI()
                return
            }
        }
    }
    
    func StartNewGame() {
        gameScene.AI = false
        gameScene.newGameScene = self
        view?.presentScene(gameScene, transition: .crossFade(withDuration: 1.2))
    }
    
    func StartNewGameWithAI() {
        gameScene.AI = true
        gameScene.newGameScene = self
        view?.presentScene(gameScene, transition: .crossFade(withDuration: 1.2))
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        handleTouchEnd(touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        handleTouchEnd(touches)
    }
    
}
