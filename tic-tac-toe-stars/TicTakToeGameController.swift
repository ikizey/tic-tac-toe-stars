//
//  GameViewController.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 01.07.2021.
//

import UIKit
import SpriteKit

class TicTakToeGameController: UIViewController {

    var gameScene: TicTacToeScene!
    var newGameScene: NewGameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            let screenSize = UIScreen.main.bounds.size
            
            gameScene = TicTacToeScene(size: screenSize)
            
            newGameScene = NewGameScene(size: screenSize)
            newGameScene.gameScene = gameScene
            
            view.presentScene(newGameScene, transition: SKTransition.moveIn(with: .up, duration: 0.2))
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
