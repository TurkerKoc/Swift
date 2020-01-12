//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Turker Koc on 10.08.2018.
//  Copyright © 2018 Turker Koc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?

    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    let coinSound = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
    
    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION (Kuş kanat çırpma)
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<Any>()  //array of birds (wings are in diffrent angles)
    var bird = SKSpriteNode()
    var repeatActionBird = SKAction()
    
    
    override func didMove(to view: SKView)
    {
        createScene()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if isGameStarted == false
        {
            //1
            isGameStarted =  true
            bird.physicsBody?.affectedByGravity = true
            createPauseBtn()
            //2
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            //3
            self.bird.run(repeatActionBird)
            
//PİLLARS
            //1
            let spawn = SKAction.run({
                () in
                self.wallPair = self.createWalls()
                self.addChild(self.wallPair)
            })
            //2
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            //3
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePillars = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.008 * distance))
            let removePillars = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePillars, removePillars])
            
            
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
        }
        else
        {
            //4
            if isDied == false 
            {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
            }
        }
        
        
        for touch in touches
        {
            let location = touch.location(in: self)
            //1
            if isDied == true
            {
                if restartBtn.contains(location)
                {
                    if UserDefaults.standard.object(forKey: "highestScore") != nil
                    {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!
                        {
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    }
                    else
                    {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            }
            else
            {
                //2
                if pauseBtn.contains(location){
                    if self.isPaused == false
                    {
                        self.isPaused = true
                        pauseBtn.texture = SKTexture(imageNamed: "play")
                    }
                    else
                    {
                        self.isPaused = false
                        pauseBtn.texture = SKTexture(imageNamed: "pause")
                    }
                }
            }
        }
    }
    

    override func update(_ currentTime: TimeInterval)
    {
        // Background ilerlemesini sağlama
        //ekrandaki her bir kare değiştiğinde bu fonksiyon çağırılır her çağırıldığında aşağıdaki kod ekranın 2 pixel sola kaymasını sağlar
        if isGameStarted == true
        {
            if isDied == false
            {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    if bg.position.x <= -bg.size.width
                    {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }

    func createScene()
    {
        //ekran sınırları belirlendi
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //aşağıdakiler çarpışma algılaması için verilen özellikler
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory //defining the category which it belongs
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory //defining which bodies can collide with it
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory //defining which collisions  create notification
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
//BACKGROUND AYARI
        for i in 0..<2
        {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
    
        //SET UP THE BIRD SPRITES FOR ANIMATION (kanat çırpması için)
        birdSprites.append(birdAtlas.textureNamed("bird1"))
        birdSprites.append(birdAtlas.textureNamed("bird2"))
        birdSprites.append(birdAtlas.textureNamed("bird3"))
        birdSprites.append(birdAtlas.textureNamed("bird4"))
        
        
//GAMELEMENTS içinde yaratılan kuş çağırıldı
        self.bird = createBird()
        self.addChild(bird) //EKLENDİ
        
        //PREPARE TO ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animateBird = SKAction.animate(with: self.birdSprites as! [SKTexture], timePerFrame: 0.1)
        self.repeatActionBird = SKAction.repeatForever(animateBird)
        
//SCORE LABEL
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
//HİGHSCORE LABEL
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
//LOGO
        createLogo()
        
//TAP TO PLAY LABEL
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        
        
    }

    
//ÇARPIŞMALARIN KONTROLÜ
    func didBegin(_ contact: SKPhysicsContact)
    {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory || firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory{
            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            if isDied == false{
                isDied = true
                createRestartBtn()
                pauseBtn.removeFromParent()
                self.bird.removeAllActions()
            }
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            run(coinSound)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
//RESTART BUTTON TIKLANINCA
    func restartScene()
    {
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        createScene()
    }


}
