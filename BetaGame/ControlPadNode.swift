//
//  ControlPad.swift
//  BetaGame
//
//  Created by Joshua Weldon on 4/19/16.
//  Copyright © 2016 Joshua Weldon. All rights reserved.
//

import SpriteKit
import Darwin

protocol ControlPadNodeDelegate: class {
    
    func CPNStateChange(isPressed: Bool)
    
    func CPNAngleChange(angle: CGFloat, inBounds: Bool)
}

class ControlPadNode: SKSpriteNode {
    
    // MARK: Properties

    static let scaleFactor:   CGFloat = 0.30
    static let PI         :   CGFloat = 3.14159
    
    weak var delegate: ControlPadNodeDelegate?
    
    let particleEmitter: SKEmitterNode
    let normalAlpha:     CGFloat = 0.1
    let selectedAlpha:   CGFloat = 0.5
    let radius:          CGFloat
    
    
    // MARK: Initialization
    
    init(size: CGSize) {

        particleEmitter                       = SKEmitterNode()
        particleEmitter.particleLifetime      = 0.5
        particleEmitter.particleBirthRate     = 0
        particleEmitter.particleTexture       = SKTexture(imageNamed: "Particle")
        particleEmitter.particlePositionRange = CGVector(dx: 25, dy: 25)
        particleEmitter.position              = CGPoint(x: 0, y: 0)
        particleEmitter.particleSize          = CGSize(width: 10, height: 10)
        
        radius = size.width / 2
        
        super.init(texture: SKTexture(imageNamed: "ControlPad"), color: UIColor.clear, size: size)
        
        isUserInteractionEnabled = true
        alpha                  = normalAlpha
        
        addChild(particleEmitter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: UIResponder
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        particleEmitter.particleBirthRate = 10
        alpha = selectedAlpha
        
        delegate?.CPNStateChange(isPressed: true)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchPosition  = touch.location(in: self)
            let trackingLength = sqrt(touchPosition.x*touchPosition.x + touchPosition.y*touchPosition.y)
            var angle          = atan(touchPosition.y/touchPosition.x)
            
            if(touchPosition.x < 0){
                if(touchPosition.y < 0){
                    angle -= ControlPadNode.PI
                }
                else{
                    angle += ControlPadNode.PI
                }
            }
            
            if(trackingLength > radius){
                
                let positionX = touchPosition.x * radius / trackingLength
                let positionY = touchPosition.y * radius / trackingLength
                
                particleEmitter.position = CGPoint(x: positionX, y: positionY)
                
                delegate?.CPNAngleChange(angle: angle, inBounds: false)
            }
            else{
                particleEmitter.position = touchPosition
                
                delegate?.CPNAngleChange(angle: angle, inBounds: true)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetContolPad()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetContolPad()
    }
    
    func resetContolPad() {
        
        particleEmitter.position = CGPoint(x: 0, y: 0)
        particleEmitter.particleBirthRate = 0
        
        alpha = normalAlpha
        
        delegate?.CPNStateChange(isPressed: false)
    }
    
    
}

