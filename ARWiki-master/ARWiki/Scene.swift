//
//  Scene.swift
//  ARWiki
//
//  Created by Shawn Roller on 10/16/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Remove a page if it's been tapped
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let hit = nodes(at: location)
        
        if let sprite = hit.first, sprite.name == "page" {
            let scale = SKAction.scale(to: 0, duration: 0.2)
            let fade = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scale, fade])
            let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
            
            if let spriteParent = sprite.parent, spriteParent.name == "page" {
                spriteParent.run(sequence)
            }
            for child in sprite.children {
                if child.name == "page" {
                    child.run(sequence)
                }
            }
            
            sprite.run(sequence)
        }
        
    }
}
