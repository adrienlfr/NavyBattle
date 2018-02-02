//
//  GameBoard.swift
//  NavyBattle
//
//  Created by Adrien LEFAURE on 02/02/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import Foundation

struct GameBoard {
    var gameBoard: [CasePosition: CaseState] = [:]
    var ships : [Ship] = []
    
    init() {
        positionShips().forEach { ship in ships.append(ship) }
    }
    
    private func positionShips() -> [Ship] {
        let contreTorpilleurCases = [CasePosition(line: 1, column: "B"), CasePosition(line: 2, column: "B"), CasePosition(line: 3, column: "B")]
        let contreTorpilleur = Ship(cases: contreTorpilleurCases)
        let torpilleurCases = [CasePosition(line: 4, column: "E"), CasePosition(line: 4, column: "F")]
        let torpilleur = Ship(cases: torpilleurCases)
        return [torpilleur, contreTorpilleur]
    }
    
    func displayBoard() {
        var headline = "  "
        for column in columns {
            headline += "|\(column)"
        }
        headline += "|"
        print(headline)
        for line in lines {
            var printLine = String(format: "%*2d", 2, line) // https://en.wikipedia.org/wiki/Printf_format_string
            printLine += "|"
            for column in columns {
                let casePosition = CasePosition(line: line, column: column)
                var character: Character = " "
                if let caseState = gameBoard[casePosition] {
                    character = caseState.rawValue
                }
                printLine.append(character)
                printLine += "|"
            }
            print(printLine)
        }
    }
    
    func isShipEntirelyStriked(_ ship: Ship) -> Bool {
        var entirelyStriked = true
        for casePosition in ship.cases {
            if gameBoard[casePosition] == nil {
                entirelyStriked = false
                break
            }
        }
        return entirelyStriked
    }
    
    func allShipsStricked() -> Bool {
        var allShipsStricked = true
        for ship in ships {
            if isShipEntirelyStriked(ship) == false {
                allShipsStricked = false
                break
            }
        }
        return allShipsStricked
    }
    
    func isAShipAtThisPosition(_ casePosition: CasePosition) -> Ship? {
        for ship in ships {
            if ship.isAt(casePosition: casePosition) {
                return ship
            }
        }
        return nil
    }
    
    mutating func switchCaseStateTo(_ caseToPlay: CasePosition, _ caseState: CaseState) {
        gameBoard[caseToPlay] = caseState
    }
}
