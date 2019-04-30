

import SpriteKit
import GameplayKit


struct PhysicsCategory {
   static let monster: UInt32 = 1 //Really the number "1"
   static let projectile: UInt32 = 2 //Really the number "2"
    static let player: UInt32 = 4
    static let all: UInt32 = UInt32.max
    static let none: UInt32 = 0
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var player = SKSpriteNode(imageNamed: "ninja 1")
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector.zero
        let backgroundMusic = SKAudioNode(fileNamed: "gameMusic")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        backgroundColor = UIColor.white
        //var borders = SKPhysicsBody(edgeLoopFrom: self.frame)
        //self.physicsBody = borders
        createPlayer()
        //for i in 0...6{
       // badGuy()
       // }
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(badGuy), SKAction.wait(forDuration: 1.0)])))
        
}
    
    func createPlayer(){
        
        //player.position = randomPoint()
        player.position = CGPoint(x: 50, y: 200)
        player.scale(to: CGSize(width: 75, height: 75))
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width, height: player.size.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 1
        player.physicsBody?.pinned = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        addChild(player)
        //player.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 50))
        
        
    }
    
    
    func badGuy(){
        var player2 = SKSpriteNode(imageNamed: "ninja 2")
        //player2.position = randomPoint()
        player2.position = CGPoint(x: self.size.width, y: 200)
        player2.scale(to: CGSize(width: 75, height: 75))
        player2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player2.size.width, height: player2.size.height))
        player2.physicsBody?.isDynamic = true
        player2.physicsBody?.affectedByGravity = false
        player2.physicsBody?.allowsRotation = false
        player2.physicsBody?.restitution = 1
        player2.physicsBody?.categoryBitMask = PhysicsCategory.monster
        player2.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        player2.physicsBody?.collisionBitMask = PhysicsCategory.none
        player2.physicsBody?.usesPreciseCollisionDetection = true //Do this if objects are moving fast
        player2.physicsBody?.mass = 1
        player2.physicsBody?.applyImpulse(CGVector(dx: -50, dy: 0))
        let actualDuration = CGFloat.random(in: 2.0...4.0)//creating a random time
        //create the actions
        let actionMove = SKAction.move(to: CGPoint(x: 0, y: 200), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        player2.run(SKAction.sequence([actionMove, actionMoveDone]))
        addChild(player2)
    }
    
    func randomPoint()->CGPoint{
        var xPos = Int.random(in: 0...Int(self.size.width))//randomly generating number between 0 and 500
        var yPos = Int.random(in: 0...Int(self.size.height))
        return CGPoint(x: xPos, y: yPos)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //1) Get the location of where we touched
        guard let touch = touches.first else{return}
        
    let touchLocation = touch.location(in: self)
        //2) Set the location of the star
    let projectile = SKSpriteNode(imageNamed: "star")
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: projectile.size.width, height: projectile.size.height))
        projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.monster
    
        addChild(projectile)
        //3) Get the direction of where to shoot
        
    let offset = touchLocation - projectile.position
    let direction = offset.normalized()
    let shootAmount = direction * 1000
    let realDest = shootAmount + projectile.position
        //4) Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    

    
    
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        let firstBody = contact.bodyA.node as? SKSpriteNode
        let secondBody = contact.bodyB.node as? SKSpriteNode
        firstBody?.removeFromParent()
        secondBody?.removeFromParent()
       
    }
    
    
    //greetings fam
}
