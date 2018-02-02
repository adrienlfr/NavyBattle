//
//  Ship.swift
//  NavyBattle
//
//  Created by Adrien LEFAURE on 02/02/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import Foundation

struct Ship {
    let cases: [CasePosition]
    let striked: Bool = false
    
    var description: String {
        var description = "Bateau"
        switch cases.count {
        case 2:
            description = "Torpilleur"
        case 3:
            description = "Contre-torpilleur"
        default:
            break
        }
        return description
    }
    
    func length() -> Int {
        return cases.count
    }
    
    func isAt(casePosition: CasePosition) -> Bool {
        let isAt = cases.contains(casePosition)
        return isAt
    }
}
