//
//  GameScene.swift
//  Angry Bird Clone
//
//  Created by Turker Koc on 9.08.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
//    //bird ü kodla oluşturma
//    //kodla oluşturup ayar yapma not olarak kalsın
//    var bird2 = SKSpriteNode()

    //Gamescene.sks de koyduğumuz bird tanımlandı
    var bird = SKSpriteNode()
    var box = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    var gameStarted = false
    var originalPosition : CGPoint!
    var originalPositionBox : CGPoint!
    var originalPositionBox2 : CGPoint!
    var originalPositionBox3 : CGPoint!
    var originalPositionBox4 : CGPoint!
    var originalPositionBox5 : CGPoint!

    var score = 0
    var scoreLabel = SKLabelNode()
    
    
    //bunu ayrı bir swift dosyası açıp içinde tanımlayabilirsin (Flappy Bird oyununda yaptın)
    enum ColliderType: UInt32
    {
        case Bird = 1
        case Box = 2
        //yeni oluşturduğumuza 3 diyemezdik çünkü 1 ve 2 nin çarpmışmasıyla 3 olur.
    }
    
    
    
    override func didMove(to view: SKView)
    {
//        //kodla oluşturulan bird e texture verme
//        let texture2 = SKTexture(imageNamed: "bird.png")
//        //birdle texture bağlama
//        bird2 = SKSpriteNode(texture: texture2)
//        //kuşun ekrandaki yerini belirtme
//        bird2.position = CGPoint(x: 0, y: 0)
//        //kuş ekranda gereğinden büyük gözüküyor diye büyüklüğünü ayarlıyoruz
//        bird2.size = CGSize(width: self.frame.width/13, height: self.frame.height/10)
//        bird2.zPosition = 2
//        self.addChild(bird2)
        
        
        //oyun içindeki hiçbirşey telefon ekran sınırları dışına çıkamıcak
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
//DELEGATE
        //didbegin fonksiyonu için lazım
        physicsWorld.contactDelegate = self
        
//BİRD özellikleri
        let birdTexture = SKTexture(imageNamed: "bird.png")
        
        
        bird = childNode(withName: "bird") as! SKSpriteNode
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 17)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.1
        bird.physicsBody?.affectedByGravity = false
        //kuşun orijinal pozisyonunu belirlemek
        originalPosition = bird.position
        
        //çarpışma için verilen özellikler
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue

//BOX özellikleri
        
        let boxTexture = SKTexture(imageNamed: "box.png")
        let size = CGSize(width: boxTexture.size().width / 6, height: boxTexture.size().height / 6)
        
        box = childNode(withName: "box1") as! SKSpriteNode
        box.physicsBody = SKPhysicsBody(rectangleOf: size)
        box.physicsBody?.isDynamic = true
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.allowsRotation = true
        
        //kutunun orijinal pozisyonu
        originalPositionBox = box.position
        
        
        //kutulara çarpmışma tanıma özelliği verdik
        box.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box2.physicsBody = SKPhysicsBody(rectangleOf: size)
        box2.physicsBody?.isDynamic = true
        box2.physicsBody?.affectedByGravity = true
        box2.physicsBody?.allowsRotation = true
        
        originalPositionBox2 = box2.position

        box2.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue

        
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box3.physicsBody = SKPhysicsBody(rectangleOf: size)
        box3.physicsBody?.isDynamic = true
        box3.physicsBody?.affectedByGravity = true
        box3.physicsBody?.allowsRotation = true
        
        originalPositionBox3 = box3.position
        
        box3.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue

        
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box4.physicsBody = SKPhysicsBody(rectangleOf: size)
        box4.physicsBody?.isDynamic = true
        box4.physicsBody?.affectedByGravity = true
        box4.physicsBody?.allowsRotation = true
        
        originalPositionBox4 = box4.position
        
        box4.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box5.physicsBody = SKPhysicsBody(rectangleOf: size)
        box5.physicsBody?.isDynamic = true
        box5.physicsBody?.affectedByGravity = true
        box5.physicsBody?.allowsRotation = true
        
        originalPositionBox5 = box5.position
        
        box5.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue

        
//SCORE
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)

        
    }
    
    //çarpışma oldu mu
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyA.collisionBitMask  == ColliderType.Bird.rawValue
        {
            score = score + 1
            scoreLabel.text = String(score)
        }
        
    }
    
    

 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //çekme vektörü
        if gameStarted == false
        {
            if let touch = touches.first
            {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false
                {
                    for node in touchNodes
                    {
                        if let sprite = node as? SKSpriteNode
                        {
                            if sprite == bird
                            {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
       
        
        
        
        //Flappy bird benzeri
//        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 90))
//        bird.physicsBody?.affectedByGravity = true

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //çekme vektörü
        if gameStarted == false
        {
            if let touch = touches.first
            {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false
                {
                    for node in touchNodes
                    {
                        if let sprite = node as? SKSpriteNode
                        {
                            if sprite == bird
                            {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //çekme vektörü
        if gameStarted == false
        {
            if let touch = touches.first
            {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false
                {
                    for node in touchNodes
                    {
                        if let sprite = node as? SKSpriteNode
                        {
                            if sprite == bird
                            {
                                let dx = touchLocation.x - originalPosition.x
                                let dy = touchLocation.y - originalPosition.y
                                
                                let impulse = CGVector(dx: -dx, dy: -dy)
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    

    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        
        //kuşu uçurma
        if let birdphysicsBody = bird.physicsBody
        {
            if birdphysicsBody.velocity.dx <= 0.1 && birdphysicsBody.velocity.dy <= 0.1 && birdphysicsBody.angularVelocity <= 0.1 && gameStarted == true
            {
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 0
                bird.position = originalPosition
                box.position = originalPositionBox
                box2.position = originalPositionBox2
                box3.position = originalPositionBox3
                box4.position = originalPositionBox4
                box5.position = originalPositionBox5
                gameStarted = false
                score = 0
                scoreLabel.text = String(score)

            }
        }
    }
}
