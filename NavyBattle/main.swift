//
//  main.swift
//  NavyBattle
//
//  Created by Richard Bergoin on 26/01/2017.
//  Copyright © 2017 Richard Bergoin. All rights reserved.
//

import Foundation

let lines = (1...10).map({ return $0 })
let columns = "ABCDEFGHIJ".map({ return $0 })

enum CaseState: Character {
    case white = "O"
    case red = "X"
}

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

typealias NextCasePositionToPlay = (_: CasePosition?) -> CasePosition

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
        var isAt = false
        for oneOfMyCasePosition in cases {
            if casePosition == oneOfMyCasePosition {
                isAt = true
                break
            }
        }
        return isAt
    }
}

var gameBoard: [CasePosition: CaseState]

func displayBoard(gameBoard: [CasePosition: CaseState]) {
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

func isShipEntirelyStriked(_ ship: Ship, gameBoard: [CasePosition: CaseState]) -> Bool {
    var entirelyStriked = true
    for casePosition in ship.cases {
        if gameBoard[casePosition] == nil {
            entirelyStriked = false
            break
        }
    }
    return entirelyStriked
}

func allShipsStricked(ships: [Ship], gameBoard: [CasePosition: CaseState]) -> Bool {
    var allShipsStricked = true
    for ship in ships {
        if isShipEntirelyStriked(ship, gameBoard: gameBoard) == false {
            allShipsStricked = false
            break
        }
    }
    return allShipsStricked
}

func isAShipAtThisPosition(_ casePosition: CasePosition, ships: [Ship]) -> Ship? {
    for ship in ships {
        if ship.isAt(casePosition: casePosition) {
            return ship
        }
    }
    return nil
}

func positionShips() -> [Ship] {
    let contreTorpilleurCases = [CasePosition(line: 1, column: "B"), CasePosition(line: 2, column: "B"), CasePosition(line: 3, column: "B")]
    let contreTorpilleur = Ship(cases: contreTorpilleurCases)
    let torpilleurCases = [CasePosition(line: 4, column: "E"), CasePosition(line: 4, column: "F")]
    let torpilleur = Ship(cases: torpilleurCases)
    return [torpilleur, contreTorpilleur]
}

func nextPositionToPlayWillBeAtRight(previousOne: CasePosition?) -> CasePosition {
    if let previousOne = previousOne {
        if previousOne.line == 10 {
            let index = columns.index(of: previousOne.column)! + 1
            let column = columns[index]
            return CasePosition(line: 1, column: column)
        } else {
            return CasePosition(line: previousOne.line + 1, column: previousOne.column)
        }
    } else {
        return CasePosition(line: 1, column: "A")
    }
}

func main(_ nextCasePositionToPlay: NextCasePositionToPlay) {
    let ships = positionShips()
    var gameBoard = [CasePosition : CaseState]()
    var lastCasePositionPlayed: CasePosition?
    repeat {
        var playingAt = "Playing at "
        let caseToPlay = nextCasePositionToPlay(lastCasePositionPlayed)
        playingAt += "\(caseToPlay.description)... "
        if let ship = isAShipAtThisPosition(caseToPlay, ships: ships) {
            gameBoard[caseToPlay] = .red
            if isShipEntirelyStriked(ship, gameBoard: gameBoard) {
                playingAt += "\(ship.description) coulé"
            } else {
                playingAt += "\(ship.description) touché"
            }
        } else {
            gameBoard[caseToPlay] = .white
            playingAt += "À l'eau"
        }
        lastCasePositionPlayed = caseToPlay
        print(playingAt)
        displayBoard(gameBoard: gameBoard)
    } while allShipsStricked(ships: ships, gameBoard: gameBoard) == false
}

main(nextPositionToPlayWillBeAtRight(previousOne:))
