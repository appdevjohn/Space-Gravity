//
//  SPGEnumeratedTypes.swift
//  Space Gravity
//
//  Created by John Champion on 4/29/20.
//  Copyright © 2020 John Champion. All rights reserved.
//

import Foundation

enum ContactCategory: UInt32 {
    case asteroid = 1
    case goal = 2
    case interactive = 3
    case collectable = 4
    case wormhole = 5
    case slalom = 6
    case ship = 8
}
