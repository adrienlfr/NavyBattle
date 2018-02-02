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





typealias NextCasePositionToPlay = (_: CasePosition?) -> CasePosition






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
    var gameBoard = GameBoard()
    var lastCasePositionPlayed: CasePosition?
    repeat {
        var playingAt = "Playing at "
        let caseToPlay = nextCasePositionToPlay(lastCasePositionPlayed)
        playingAt += "\(caseToPlay.description)... "
        if let ship = gameBoard.isAShipAtThisPosition(caseToPlay) {
            gameBoard.switchCaseStateTo(caseToPlay, .red)
            if gameBoard.isShipEntirelyStriked(ship) {
                playingAt += "\(ship.description) coulé"
            } else {
                playingAt += "\(ship.description) touché"
            }
        } else {
            gameBoard.switchCaseStateTo(caseToPlay, .white)
            playingAt += "À l'eau"
        }
        lastCasePositionPlayed = caseToPlay
        print(playingAt)
        gameBoard.displayBoard()
    } while gameBoard.allShipsStricked() == false
}

main(nextPositionToPlayWillBeAtRight(previousOne:))
