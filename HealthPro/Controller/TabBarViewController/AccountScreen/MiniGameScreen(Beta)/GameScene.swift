
import SpriteKit
import GameplayKit

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
    var gameState: GameSceneState = .active
    var scoreLabel: SKLabelNode!
    var points = 0
    
    // MARK: Lifecircle
    
    override func didMove(to view: SKView) {
      /* Setup your scene here */

      /* Recursive node search for 'hero' (child of referenced node) */
      hero = (self.childNode(withName: "//hero") as! SKSpriteNode)

      /* allows the hero to animate when it's in the GameScene */
      hero.isPaused = false
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
      scrollLayer = self.childNode(withName: "scrollLayer")
        
      obstacleSource = self.childNode(withName: "obstacle")
        
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        
        physicsWorld.contactDelegate = self
        
        buttonRestart = (self.childNode(withName: "buttonRestart") as! MSButtonNode)
        
        scoreLabel = (self.childNode(withName: "scoreLabel") as! SKLabelNode)
        
        buttonRestart.selectedHandler = {

          /* Grab reference to our SpriteKit view */
          let skView = self.view as SKView?

          /* Load Game scene */
          let scene = GameScene(fileNamed:"GameScene") as GameScene?

          /* Ensure correct aspect mode */
          scene?.scaleMode = .aspectFill

          /* Restart game scene */
          skView?.presentScene(scene)

        }
        
        buttonRestart.state = .MSButtonNodeStateHidden
        
        scoreLabel.text = "\(points)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      /* Called when a touch begins */

      /* Apply vertical impulse */
      hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        
        hero.physicsBody?.applyAngularImpulse(1)
        sinceTouch = 0
        
        if gameState != .active { return }
        
    }

    override func update(_ currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */

      /* Grab current velocity */
      let velocityY = hero.physicsBody?.velocity.dy ?? 0

      /* Check and cap vertical velocity */
      if velocityY > 400 {
        hero.physicsBody?.velocity.dy = 400
      }
        
        if sinceTouch > 0.2 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }

        /* Clamp rotation */
        hero.zRotation.clamp(v1: CGFloat(-90).degreesToRadians(), CGFloat(30).degreesToRadians())
        hero.physicsBody?.angularVelocity.clamp(v1: -1, 3)

        /* Update last touch timer */
        sinceTouch += fixedDelta
        
        scrollWorld()
        
        updateObstacles()
        
        spawnTimer += fixedDelta
        
        if gameState != .active { return }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        /* Get references to bodies involved in collision */
        let contactA = contact.bodyA
        let contactB = contact.bodyB

        /* Get references to the physics body parent nodes */
        let nodeA = contactA.node!
        let nodeB = contactB.node!

        /* Did our hero pass through the 'goal'? */
        if nodeA.name == "goal" || nodeB.name == "goal" {

          /* Increment points */
          points += 1

          /* Update score label */
          scoreLabel.text = String(points)

          /* We can return now */
          return
        }
      /* Ensure only called while game running */
      if gameState != .active { return }

        /* Reset velocity, helps improve response against cumulative falling velocity */
        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
      /* Change game state to game over */
      gameState = .gameOver

      /* Stop any new angular velocity being applied */
      hero.physicsBody?.allowsRotation = false

      /* Reset angular velocity */
      hero.physicsBody?.angularVelocity = 0

      /* Stop hero flapping animation */
      hero.removeAllActions()

      /* Show restart button */
      buttonRestart.state = .MSButtonNodeStateActive
        
        let heroDeath = SKAction.run({

            /* Put our hero face down in the dirt */
            self.hero.zRotation = CGFloat(-90).degreesToRadians()
        })

        /* Run action */
        hero.run(heroDeath)
        
        let shakeScene:SKAction = SKAction.init(named: "Shake")!

        /* Loop through all nodes  */
        for node in self.children {

            /* Apply effect each ground node */
            node.run(shakeScene)
        }
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: ground.size.width - 20, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    func updateObstacles() {
       /* Update Obstacles */

       obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)

       /* Loop through obstacle layer nodes */
       for obstacle in obstacleLayer.children as! [SKReferenceNode] {

           /* Get obstacle node position, convert node position to scene space */
           let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)

           /* Check if obstacle has left the scene */
        if obstaclePosition.x <= -414 {
           // 26 is one half the width of an obstacle

               /* Remove obstacle node from obstacle layer */
               obstacle.removeFromParent()
           }

       }

        if spawnTimer >= 2.5 {

            /* Create a new obstacle by copying the source obstacle */
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)

            /* Generate new obstacle position, start just outside screen and with a random y value */
            let randomPosition =  CGPoint(x: 414, y: CGFloat.random(in: 0...110))

            /* Convert new node position back to obstacle layer space */
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)

            // Reset spawn timer
            spawnTimer = 0
        }
        
     }
}

enum GameSceneState {
    case active, gameOver
}
