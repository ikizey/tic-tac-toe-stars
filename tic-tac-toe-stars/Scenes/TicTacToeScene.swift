//
//  TicTacToeScene.swift
//  tic-tac-toe-stars
//
//  Created by PrincePhoenix on 01.07.2021.
//

import SpriteKit

class TicTacToeScene: SKScene {
    
    weak var newGameScene: NewGameScene!
    var AI: Bool = false {
        didSet {
            gameSession.withAI = AI
        }
    }
    private var cells = [BoardCell]()
    
    private var infoLabel: SKLabelNode!
    private var settingsLabel: SKSpriteNode!
//    var settingsMenu: SettingsMenu!
    
    private var gameSession: GameSession = GameSession()
    private var strategist: Strategist!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()

        strategist = Strategist(model: gameSession)
        strategist.model = gameSession
        
        anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        addBackground()
        addSettingsSprite()
        addCells()
        setInfoLabel()
        //addSettingsMenu()
    }
        
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        #warning("don't create textures all the time")
        let textureName = AI ? "moon" : "sunSettings"
        settingsLabel.run(.setTexture(SKTexture(imageNamed: textureName)))
        
        GameOver()
    }
    
//    private func addSettingsMenu() {
//        let size = CGSize(width: self.size.width - 50, height: self.size.width - 50)
//        let inactivePosition = CGPoint(x: center.x + self.size.width, y: center.y)
//        var menu = SettingsMenu(size: size, inactivePosition: inactivePosition, activePosition: center, isActive: false)
//        menu.createSprite(at: self)
//        settingsMenu = menu
//    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = center
        background.zPosition = -1
        background.blendMode = .replace
        background.size = size
        addChild(background)
    }
    
    private func setInfoLabel() {
        infoLabel = SKLabelNode(fontNamed: "Chalkduster")
        infoLabel.fontSize = 40
        infoLabel.fontColor = UIColor.systemIndigo
        infoLabel.position = infoPosition
        addChild(infoLabel)
        updateInfoLabel()
    }
    
    private func updateInfoLabel() {
        let name = gameSession.currentPlayer.name
        infoLabel.text = "\(name)'s turn"
    }
    
    private func addCells() {
        for index in gameSession.board.cells {
            let cell = BoardCell(rectOf: cellSize)
            cell.index = index
            cell.position = determinePositionForCell(with: index)
            cells.append(cell)
            addChild(cell)
        }
    }
    
    private func determinePositionForCell(with index: Int) -> CGPoint {
        let col = CGFloat(index % gameSession.board.maxColumns)
        let row = CGFloat(Int(index / gameSession.board.maxRows))
        
        let xPos = cellPositionAtIndexZero.x + cellSize.width * col
        let yPos = cellPositionAtIndexZero.y - cellSize.height * row
        return CGPoint(x: xPos, y: yPos)
    }
    
    private func addSettingsSprite() {
        settingsLabel = SKSpriteNode(imageNamed: "sunSettings")
        settingsLabel.name = "sun"
        settingsLabel.zPosition = 2
        settingsLabel.anchorPoint = CGPoint(x: 1, y: 1)
        settingsLabel.position = topRight
        addChild(settingsLabel)
    }
    
    private func handleTouchEnd(_ touches: Set<UITouch>) {
        if gameSession.withAI && gameSession.currentPlayer.isO { return }
        
        guard let touch = touches.first else { return }
        let touchedNodes = nodes(at: touch.location(in: self))
        
        for node in touchedNodes {
            if node.name == "sun" {
//                let rotate = SKAction.rotate(byAngle: .pi * 2, duration: 0.4)
//                node.run(rotate)
//                settingsMenu.isActive.toggle()
                
                view?.presentScene(newGameScene, transition: .crossFade(withDuration: 1.2))
                return
            }
        }
        
        for case let cell as BoardCell in touchedNodes {
            let index = cell.index!
            makeMove(with: index)
            return // otherwise you can activate multiple cells at once
        }
    }

    func makeMove(with index: Int) {
        if gameSession.isPossible(move: index) {
            cells[index].update(byPlayer: gameSession.currentPlayer.playerId)
            gameSession.advance(with: index)
            
            if let winCells = gameSession.winCells {
                winAnimation(with: winCells)
                GameOver()
            } else if gameSession.isEnded {
                GameOver()
            }
        } else {
            cells[index].update()
        }
        updateInfoLabel()
        if gameSession.withAI && gameSession.currentPlayer.isO {
            processAIMove()
        }
    }
      
    private func processAIMove() {
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let bestMove = self.strategist.bestMove else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            let aiTimeCeiling = 0.3
            let delay = max(delta, aiTimeCeiling)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeMove(with: bestMove)
            }
        }
    }
    
    func winAnimation(with indices: Set<Int>) {
        cells.forEach({ if indices.contains($0.index) {$0.update()}})
    }
    
    func GameOver() {
        cells.forEach( {$0.clear()} )
        
        gameSession.restart()
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


// MARK: - Positions
#warning("move somewhere")
extension SKScene {
    
    var padding: CGFloat { 24 }
        
    var center: CGPoint {
        CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    var topRight: CGPoint {
        CGPoint(x: size.width - padding, y: size.height - padding)
    }
    
    var topLeft: CGPoint {
        CGPoint(x: .zero + padding, y: size.height - padding)
    }
    
    var top: CGPoint {
        CGPoint(x: size.width / 2, y: size.height - padding)
    }
    
    
    var infoPosition: CGPoint {
        CGPoint(x: center.x, y: center.y + cellSize.height * 2)
    }
    
    var cellSize: CGSize {
        let thirdOfWidth = size.width / 3 - padding
        return CGSize(width: thirdOfWidth, height: thirdOfWidth)
    }
    
    var cellPositionAtIndexZero: CGPoint {
        CGPoint(x: center.x - cellSize.width, y: center.y + cellSize.height)
    }
}
