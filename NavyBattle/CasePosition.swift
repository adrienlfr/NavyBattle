//
//  CasePosition.swift
//  NavyBattle
//
//  Created by Adrien LEFAURE on 02/02/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import Foundation

struct CasePosition: Hashable {
    
    let line: Int // 0..<10
    let column: Character // A, B...
    
    public static func ==(lhs: CasePosition, rhs: CasePosition) -> Bool {
        return lhs.line == rhs.line && lhs.column == rhs.column
    }
    
    public var hashValue: Int {
        return line.hashValue ^ column.hashValue
    }
    
    var description: String {
        return "\(column)-\(line)"
    }
}
