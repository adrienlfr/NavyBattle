//
//  NavyBattleGame.swift
//  NavyBattle
//
//  Created by Adrien LEFAURE on 02/02/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import Foundation

struct NavyBattleGame {
    typealias NextCasePositionToPlay = (_: CasePosition?) -> CasePosition
    
    private func nextPositionToPlayWillBeAtRight(previousOne: CasePosition?) -> CasePosition {
        if let previousOne = previousOne {
            if previousOne.line == 10 {
                let index = GameBoard.columns.index(of: previousOne.column)! + 1
                let column = GameBoard.columns[index]
                return CasePosition(line: 1, column: column)
            } else {
                return CasePosition(line: previousOne.line + 1, column: previousOne.column)
            }
        } else {
            return CasePosition(line: 1, column: "A")
        }
    }
    
    private func main(_ nextCasePositionToPlay: NextCasePositionToPlay) {
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
        } while gameBoard.allShipsStricke == false
    }
    
    func start() {
        main(nextPositionToPlayWillBeAtRight(previousOne:))
    }
}
