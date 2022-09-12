import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // MARK: Properties
    
    var hero: SKSpriteNode!
    var sinceTouch: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    let scrollSpeed: CGFloat = 100
    var scrollLayer: SKNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var spawnTimer: CFTimeInterval = 0
    var buttonRestart: MSButtonNode!
    var buttonExit: MSButtonExitNode!
    var gameState: GameSceneState = .active
    var scoreLabel: SKLabelNode!
    var points = 0
    var mainstoryboard: UIStoryboard = UIStoryboard(name: "Account", bundle: nil)
    
    // MARK: Lifecircle
    
    override func didMove(to view: SKView) {
        
        hero = (self.childNode(withName: "//hero") as! SKSpriteNode)
        
        hero.isPaused = false
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        scrollLayer = self.childNode(withName: "scrollLayer")
        
        obstacleSource = self.childNode(withName: "obstacle")
        
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        
        physicsWorld.contactDelegate = self
        
        buttonRestart = (self.childNode(withName: "buttonRestart") as! MSButtonNode)
        buttonExit = (self.childNode(withName: "buttonExit") as! MSButtonExitNode)
        
        
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        
        buttonRestart.selectedHandler = {
            
            
            let skView = self.view as SKView?
            
            let scene = GameScene(fileNamed: "GameScene") as GameScene?
            
            scene?.scaleMode = .aspectFill
            skView?.presentScene(scene)
            
        }
        
        buttonExit.selectedHandler = { [self] in
            let skView = self.view?.window?.rootViewController?.presentedViewController
            
            skView?.dismiss(animated: true, completion: nil)
        }
        
        buttonRestart.state = .MSButtonNodeStateHidden
        buttonExit.state = .MSButtonNodeStateHidden
        
        scoreLabel.text = "\(points)"
    }

    // MARK: TouchesBegan
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        
        hero.physicsBody?.applyAngularImpulse(1)
        sinceTouch = 0
        
        if gameState != .active { return }
        
    }

    // MARK: Update
    
    override func update(_ currentTime: CFTimeInterval) {
        
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        if sinceTouch > 0.2 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        hero.zRotation.clamp(v1: CGFloat(-90).degreesToRadians(), CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(v1: -1, 3)
        
        sinceTouch += fixedDelta
        
        scrollWorld()
        
        updateObstacles()
        
        spawnTimer += fixedDelta
        
        if gameState != .active { return }
    }
    
    // MARK: DidBegin
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "goal" || nodeB.name == "goal" {
            
            points += 1
            
            
            scoreLabel.text = String(points)
            
            return
        }
        
        if gameState != .active { return }
        
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        gameState = .gameOver
        
        hero.physicsBody?.allowsRotation = false
        
        hero.physicsBody?.angularVelocity = 0
        
        hero.removeAllActions()
        
        buttonRestart.state = .MSButtonNodeStateActive
        buttonExit.state = .MSButtonNodeStateActive
        
        let heroDeath = SKAction.run({
            
            self.hero.zRotation = CGFloat(-90).degreesToRadians()
        })
        
        hero.run(heroDeath)
        
        let shakeScene: SKAction = SKAction.init(named: "Shake")!
        
        for node in self.children {
            
            node.run(shakeScene)
        }
    }
    
    // MARK: Logic Functions
    
    func scrollWorld() {
        
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            if groundPosition.x <= -ground.size.width {
                
                let newPosition = CGPoint(x: ground.size.width - 20, y: groundPosition.y)
                
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            
            if obstaclePosition.x <= -414 {
                obstacle.removeFromParent()
            }
            
        }
        
        if spawnTimer >= 2.5 {
            
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            
            let randomPosition =  CGPoint(x: 414, y: CGFloat.random(in: 0...110))
            
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            spawnTimer = 0
        }
    }
}

// MARK: GameSceneState Enum

enum GameSceneState {
    case active, gameOver
}
