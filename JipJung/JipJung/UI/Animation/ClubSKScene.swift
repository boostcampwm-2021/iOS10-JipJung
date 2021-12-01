//
//  LightEffectScene.swift
//  JipJung
//
//  Created by 오현식 on 2021/11/23.
//

import Foundation
import SpriteKit

final class ClubSKScene: SKScene {
    override func didMove(to view: SKView) {
        configureSpriteNode()
        animate()
    }
    
    private var lights = [SKLightNode]()
    private var background = SKSpriteNode()
    
    func configureSpriteNode() {
        configureBackgroundNode()
        configureLightNode()
        addSpriteNode()
    }
    
    func configureLightNode() {
        let light1 = SKLightNode()
        light1.position = CGPoint(x: frame.midX/2, y: frame.maxY)
        light1.categoryBitMask = 0b0001
        light1.falloff = 5.0
        light1.lightColor = .red
        lights.append(light1)
        
        let light2 = SKLightNode()
        light2.position = CGPoint(x: frame.midX, y: frame.maxY)
        light2.categoryBitMask = 0b0001
        light2.falloff = 5.0
        light2.lightColor = .blue
        lights.append(light2)
        
        let light3 = SKLightNode()
        light3.position = CGPoint(x: frame.midX*3/2, y: frame.maxY)
        light3.categoryBitMask = 0b0001
        light3.falloff = 5.0
        light3.lightColor = .green
        lights.append(light3)
    }
    
    func configureBackgroundNode() {
        background = SKSpriteNode(
            color: .white,
            size: CGSize(width: frame.width, height: frame.height)
        )
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.lightingBitMask = 0b0001
    }
    
    func addSpriteNode() {
        lights.forEach { light in
            addChild(light)
        }
        addChild(background)
    }
    
    func animate() {
        var moveActionList: [SKAction] = [SKAction]()
        let moveActionSequence1 = SKAction.sequence(
            [SKAction.move(to: CGPoint(x: frame.midX*3/2, y: frame.maxY),
                           duration: 2.0),
             SKAction.move(to: CGPoint(x: frame.midX/2,
                                       y: frame.maxY),
                           duration: 2.0)])
        moveActionList.append(SKAction.repeatForever(moveActionSequence1))
        
        let moveActionSequence2 = SKAction.sequence(
            [SKAction.move(to: CGPoint(x: frame.midX/2,
                                       y: frame.maxY),
                           duration: 1.0),
             SKAction.move(to: CGPoint(x: frame.midX*3/2,
                                       y: frame.maxY),
                           duration: 2.0),
             SKAction.move(to: CGPoint(x: frame.midX,
                                       y: frame.maxY),
                           duration: 1.0)])
        moveActionList.append(SKAction.repeatForever(moveActionSequence2))
        
        let moveActionSequence3 = SKAction.sequence(
            [SKAction.move(to: CGPoint(x: frame.midX/2,
                                       y: frame.maxY),
                           duration: 2.0),
             SKAction.move(to: CGPoint(x: frame.midX*3/2,
                                       y: frame.maxY),
                           duration: 2.0)])
        moveActionList.append(SKAction.repeatForever(moveActionSequence3))
        
        let fallOffAction1 = SKAction.customAction(withDuration: 0.25) { node, _ in
            guard let node = node as? SKLightNode else {
                return
            }
            node.falloff = 0
        }
        let fallOffAction2 = SKAction.customAction(withDuration: 0.25) { node, _ in
            guard let node = node as? SKLightNode else {
                return
            }
            node.falloff = 5.0
        }
        
        for index in 0..<lights.count {
            let delayAction = SKAction.wait(forDuration: TimeInterval.random(in: 0..<0.008))
            let fallOffActionSequence = SKAction.sequence([delayAction, fallOffAction1, fallOffAction2])
            let fallOffActionLoop = SKAction.repeatForever(fallOffActionSequence)
            
            let actionGroup = SKAction.group([moveActionList[index], fallOffActionLoop])
            lights[index].run(actionGroup)
        }
    }
}
