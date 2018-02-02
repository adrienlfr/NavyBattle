//
//  GameBoard.swift
//  NavyBattle
//
//  Created by Adrien LEFAURE on 02/02/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import Foundation

struct GameBoard {
    static let lines = (1...10).map({ return $0 })
    static let columns = "ABCDEFGHIJ".map({ return $0 })
    private let cardinalPoint = ["north", "south", "east", "west"]
    
    var gameBoard: [CasePosition: CaseState] = [:]
    var ships : [Ship] = []
    var allShipsStricke: Bool {
        var allShipsStricked = true
        for ship in ships {
            if isShipEntirelyStriked(ship) == false {
                allShipsStricked = false
                break
            }
        }
        return allShipsStricked
    }
    
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
    
    private func createShip(_ length: Int) -> Ship {
        let randomRow = GameBoard.lines[Int(arc4random_uniform(10))]
        let randomColumn = GameBoard.columns[Int(arc4random_uniform(10))]
        let direction = cardinalPoint[Int(arc4random_uniform(4))]
        
        
        
        let contreTorpilleurCases = [CasePosition(line: 1, column: "B"), CasePosition(line: 2, column: "B"), CasePosition(line: 3, column: "B")]
        let contreTorpilleur = Ship(cases: contreTorpilleurCases)
    }
    
    func displayBoard() {
        var headline = "  "
        for column in GameBoard.columns {
            headline += "|\(column)"
        }
        headline += "|"
        print(headline)
        for line in GameBoard.lines {
            var printLine = String(format: "%*2d", 2, line) // https://en.wikipedia.org/wiki/Printf_format_string
            printLine += "|"
            for column in GameBoard.columns {
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
