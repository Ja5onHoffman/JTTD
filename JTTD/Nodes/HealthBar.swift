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

    var shipHealth: CGFloat = 1.0
    
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
    
    func updateHealth(by health: CGFloat) {
        print("updateHealth")
        shipHealth -= 0.1
        run(SKAction.scaleX(to: shipHealth, duration: 0.1))
    }

}
