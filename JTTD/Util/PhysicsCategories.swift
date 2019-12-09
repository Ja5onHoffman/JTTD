//
//  PhysicsCategories.swift
//  JTTD
//
//  Created by Jason Hoffman on 7/8/19.
//  Copyright © 2019 Jason Hoffman. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:        UInt32 = 0
    static let Ship:        UInt32 = 0b1
    static let Meteor:      UInt32 = 0b10
    static let Laser:       UInt32 = 0b100
    static let Mother:      UInt32 = 0b1000
    static let Recharge:    UInt32 = 0b10000
}
