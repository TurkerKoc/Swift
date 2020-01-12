//
//  WikiPage.swift
//  ARWiki
//
//  Created by Shawn Roller on 10/18/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import Foundation

struct WikiPage: Comparable {
    
    var uuid = String()
    var title = String()
    var distance = Float()
    
    static func <(lhs: WikiPage, rhs: WikiPage) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    static func ==(lhs: WikiPage, rhs: WikiPage) -> Bool {
        return lhs.title == rhs.title && lhs.distance == rhs.distance
    }
    
}
