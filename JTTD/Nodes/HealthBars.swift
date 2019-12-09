//
//  HealthBars.swift
//  JTTD
//
//  Created by Jason Hoffman on 9/19/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation
import SpriteKit


class HealthBars: SKSpriteNode {
    
//    var shipOneHealth   = 1
//    var shipTwoHealth   = 1
//    var shipThreeHealth = 1
    
    private var shipOneHealth: CGFloat   = 1
    private var shipTwoHealth: CGFloat   = 1
    private var shipThreeHealth: CGFloat = 1

    var shipOne: SKShapeNode!
    var shipTwo: SKShapeNode!
    var shipThree: SKShapeNode!

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(size: CGSize) {
        self.init(imageNamed: "Healthbackground")
        self.name = "healtBars"
        self.zPosition = 199
        self.size = size
        
        let h = size.height / 2
        
        shipOne = SKShapeNode(rect: CGRect(
            x: -(size.width / 2) + 20,
            y: (h / 3) + (size.height / 15),
            width: (size.width - 50) * shipOneHealth,
            height: (size.height / 3) - 20),
            cornerRadius: 10)
        shipOne.fillColor = UIColor.red
        shipOne.strokeColor = UIColor.red
        addChild(shipOne)

        shipTwo = SKShapeNode(rect: CGRect(
            x: -(size.width / 2) + 20,
            y: -(h/3) + (size.height / 15),
            width: (size.width - 50) * shipTwoHealth,
            height: (size.height / 3) - 20),
            cornerRadius: 10)
        shipTwo.fillColor = UIColor.white
        shipTwo.strokeColor = UIColor.white
        addChild(shipTwo)
        
       shipThree = SKShapeNode(rect: CGRect(
            x: -(size.width / 2) + 20,
            y: -h + (size.height / 15),
            width: (size.width - 50) * shipThreeHealth,
            height: (size.height / 3) - 20),
            cornerRadius: 10)
        shipThree.fillColor = UIColor.blue
        shipThree.strokeColor = UIColor.blue
        addChild(shipThree)
    }
    
    func updateHealth(one: CGFloat, two: CGFloat, three: CGFloat) {
        
        if one < shipOneHealth {
            shipOneHealth = one
            self.shipOne.run(SKAction.resize(toWidth: shipOne.xScale * shipOneHealth, duration: 0.1))
        }
        
        if two < shipTwoHealth {
            shipTwoHealth = two
            shipTwo.run(SKAction.resize(toWidth: shipTwo.xScale * shipTwoHealth, duration: 0.1))
        }
        
        if three < shipThreeHealth {
            shipThreeHealth = three
            shipThree.run(SKAction.resize(toWidth: shipThree.xScale * shipThreeHealth, duration: 0.1))
        }
    }
    
    
}
