//
//  HealthBar.swift
//  JTTD
//
//  Created by Jason Hoffman on 9/25/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation
import SpriteKit

class HealthBar: SKShapeNode {

    var shipHealth: Int = 100
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }

    init(size: CGSize, color: UIColor) {
        super.init()
        self.fillColor = color
        self.strokeColor = color
        
        let h = size.height / 2

        let r = CGRect(
            x: -(size.width / 2) + 20,
            y: -(h/3) + (size.height / 15),
            width: size.width - 50,
            height: (size.height / 3) - 20)

        self.path = CGPath(rect: r, transform: nil)
    }
    
    // Shouldn't repeat here
    func increaseHealth(by health: Int) {
        if shipHealth < 100 {
            shipHealth += 10
            run(SKAction.scaleX(to: CGFloat(shipHealth) / 100.0, duration: 0.1))
        }
    }
    
    func fullHealth() {
        shipHealth = 100
        run(SKAction.scaleX(to: 100.0, duration: 0.1))
    }
    
    func decreaseHealth(by health: Int) {
        if shipHealth > 0 {
            shipHealth -= 10
//            print(shipHealth)
//            print(CGFloat(shipHealth) / 100.0)
            run(SKAction.scaleX(to: CGFloat(shipHealth) / 100.0, duration: 0.1))
        }
    }

}


/*
 
 
 
 
 */
