//
//  GameScene.swift
//  BetaGame
//
//  Created by Joshua Weldon on 4/16/16.
//  Copyright (c) 2016 Joshua Weldon. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, ControlPadNodeDelegate {
    
    static let shipSpeedFactor: CGFloat = 4
    
    let spaceship:          SKSpriteNode
    let controlPad:         ControlPadNode
    var touchEnabled:       Bool
    
    override init(size: CGSize) {
        
        let controlPadLength = size.height * ControlPadNode.scaleFactor
        
        spaceship  = SKSpriteNode(imageNamed: "Spaceship")
        controlPad = ControlPadNode(size: CGSize(width: controlPadLength, height: controlPadLength))
        
        touchEnabled = true
        
        super.init(size: size)
        
        controlPad.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        
        myLabel.text     = "Level 1"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)

        spaceship.position  = CGPoint(x: size.width * 3/4, y: size.height/2)
        spaceship.setScale(0.2)
        
        controlPad.position = CGPoint(x: size.width/4, y: size.height/2)

        
        self.addChild(myLabel)
        self.addChild(spaceship)
        self.addChild(controlPad)
    }
    
    
    // MARK: UIResponder
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if(!touchEnabled){
            return
        }
        
        for touch in touches {
            
            let touchPosition = touch.location(in: self)
            let action        = SKAction.move(to: touchPosition, duration: 0.3)
            
            controlPad.run(action)
            
            //let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            //sprite.xScale = 0.5
            //sprite.yScale = 0.5
            //sprite.position = location
            
            //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            //sprite.runAction(SKAction.repeatActionForever(action))
            
            //self.addChild(sprite)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        if(!touchEnabled){
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    // MARK: ControlNodeDelegate
    
    func CPNStateChange(isPressed: Bool) {
        
        touchEnabled = !isPressed
        
    }
    
    func CPNAngleChange(angle: CGFloat, inBounds: Bool) {
        
        let rotate = SKAction.rotate(toAngle: angle, duration: 0.5)
        var move: SKAction
        
        spaceship.run(rotate)
        
        if(!inBounds){
            
            let vector = CGVector(dx: cos(angle) * GameScene.shipSpeedFactor, dy: sin(angle) * GameScene.shipSpeedFactor)
            
            move   = SKAction.move(by: vector, duration: 2)
    
            spaceship.run(move)
        }
        
        
    }
}
