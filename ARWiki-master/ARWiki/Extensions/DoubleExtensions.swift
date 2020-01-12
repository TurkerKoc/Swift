//
//  DoubleExtensions.swift
//  ARWiki
//
//  Created by Shawn Roller on 10/17/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import Foundation

extension Double {
    
    func deg2Rad() -> Double {
        return self * .pi / 180
    }
    
    func rad2deg() -> Double {
        return self * 180 / .pi
    }
    
}
