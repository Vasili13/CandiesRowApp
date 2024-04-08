//
//  GameVCViewModel.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import Foundation
import UIKit

//MARK: - Protocol
protocol GameVCViewModelProtocol {
    var holeList: [IndexPath] { get }
    func resetBoard()
    func currentTurnTile() -> CandyType
    func toggleTurn(_ turnImage: UIImageView, title: UILabel)
    func currentTurnTitle() -> String
    func currentTurnColor() -> UIImage
    func currentTurnVictoryMessage() -> String
    func getLowestEmptyBoardItem(_ column: Int) -> BoardItem?
    func updateBoardWithBoardItem(_ boardItem: BoardItem)
    func boardIsFull() -> Bool
    func victoryAchieved() -> Bool
    func numberOfSection() -> Int
    func numberOfItems(in section: Int) -> Int
}

final class GameVCViewModel: GameVCViewModelProtocol {
    
    //MARK: - Variables
    private var currentTurn = Turn.blue
    private var board = [[BoardItem]]()
    var holeList = [IndexPath]()
    
    //MARK: - Methods

    func toggleTurn(_ turnImage: UIImageView, title: UILabel) {
        if purpleTurn() {
            currentTurn = Turn.blue
            turnImage.image = UIImage(named: "blueCandy")
            title.text = "Player 1"
            title.textColor = UIColor(red: 67/255, green: 173/255, blue: 255/255, alpha: 1)
        } else {
            currentTurn = Turn.purple
            turnImage.image = UIImage(named: "purpleCandy")
            title.text = "Player 2"
            title.textColor = UIColor(red: 237/255, green: 72/255, blue: 224/255, alpha: 1)
        }
    }

    private func purpleTurn() -> Bool {
        return currentTurn == Turn.purple
    }

    private func blueTurn() -> Bool {
        return currentTurn == Turn.blue
    }

    func currentTurnTile() -> CandyType {
        return blueTurn() ? CandyType.blue : CandyType.purple
    }
    
    func currentTurnTitle() -> String {
        return blueTurn() ? "Player 2" : "Player 1"
    }

    func currentTurnColor() -> UIImage {
        return blueTurn() ? UIImage(named: "blueCandy")! : UIImage(named: "purpleCandy")!
    }

    func currentTurnVictoryMessage() -> String {
        return blueTurn() ? "Player 2" : "Player 1"
    }
    
    func numberOfSection() -> Int {
        board.count
    }

    func numberOfItems(in section: Int) -> Int {
        board[section].count
    }

    func resetBoard() {
        board.removeAll()

        for row in 0...5 {
            var rowArray = [BoardItem]()
            for column in 0...6 {
                let indexPath = IndexPath(item: column, section: row)
                let boardItem = BoardItem(indexPath: indexPath, tile: CandyType.empty)
                rowArray.append(boardItem)
            }
            board.append(rowArray)
        }
    }

    private func getBoardItem(_ indexPath: IndexPath) -> BoardItem {
        return board[indexPath.section][indexPath.item]
    }

    func getLowestEmptyBoardItem(_ column: Int) -> BoardItem? {
        for row in (0...5).reversed() {
            let boardItem = board[row][column]
            if boardItem.emptyTile() {
                return boardItem
            }
        }
        return nil
    }

    func updateBoardWithBoardItem(_ boardItem: BoardItem) {
        if let indexPath = boardItem.indexPath {
            board[indexPath.section][indexPath.item] = boardItem
        }
    }

    func boardIsFull() -> Bool {
        for row in board {
            for column in row {
                if column.emptyTile() {
                    return false
                }
            }
        }
        return true
    }

    func victoryAchieved() -> Bool {
        return horizontalVictory() || verticalVictory() || diagonalVicotry()
    }
    
    //MARK: - Diagonal

    private func diagonalVicotry() -> Bool {
        for column in 0...board.count {
            if checkDiagonalColumn(column, true, true) {
                return true
            }
            if checkDiagonalColumn(column, true, false) {
                return true
            }
            if checkDiagonalColumn(column, false, true) {
                return true
            }
            if checkDiagonalColumn(column, false, false) {
                return true
            }
        }

        return false
    }

    private func checkDiagonalColumn(_ columnToCheck: Int, _ moveUp: Bool, _ reverseRows: Bool) -> Bool {
        var movingColumn = columnToCheck
        var consecutive = 0
        if reverseRows {
            for row in board.reversed() {
                if movingColumn < row.count && movingColumn >= 0 {
                    if row[movingColumn].tile == currentTurnTile() {
                        consecutive += 1
                        if consecutive >= 4 {
                            generateModifiedIndexPaths(indexPath: row[movingColumn].indexPath)
                            return true
                        }
                    } else {
                        consecutive = 0
                    }
                    movingColumn = moveUp ? movingColumn + 1 : movingColumn - 1
                }
            }
        } else {
            for row in board {
                if movingColumn < row.count && movingColumn >= 0 {
                    if row[movingColumn].tile == currentTurnTile() {
                        consecutive += 1
                        if consecutive >= 4 {
                            generateModifiedIndexPaths1(indexPath: row[movingColumn].indexPath)
                            return true
                        }
                    } else {
                        consecutive = 0
                    }
                    movingColumn = moveUp ? movingColumn + 1 : movingColumn - 1
                }
            }
        }

        return false
    }
    
    private func generateModifiedIndexPaths(indexPath: IndexPath) {
        let modifiedIndexPath1 = IndexPath(row: indexPath.row - 1, section: indexPath.section + 1)
        let modifiedIndexPath2 = IndexPath(row: modifiedIndexPath1.row - 1, section: modifiedIndexPath1.section + 1)
        let modifiedIndexPath3 = IndexPath(row: modifiedIndexPath2.row - 1, section: modifiedIndexPath2.section + 1)
        
        holeList = [indexPath, modifiedIndexPath1, modifiedIndexPath2, modifiedIndexPath3]
    }
    
    private func generateModifiedIndexPaths1(indexPath: IndexPath) {
        let modifiedIndexPath1 = IndexPath(row: indexPath.row - 1, section: indexPath.section - 1)
        let modifiedIndexPath2 = IndexPath(row: modifiedIndexPath1.row - 1, section: modifiedIndexPath1.section - 1)
        let modifiedIndexPath3 = IndexPath(row: modifiedIndexPath2.row - 1, section: modifiedIndexPath2.section - 1)
        
        holeList = [indexPath, modifiedIndexPath1, modifiedIndexPath2, modifiedIndexPath3]
    }

    //MARK: - Vertical
    private func verticalVictory() -> Bool {
        for column in 0...board.count {
            if checkVerticalColumn(column) {
                return true
            }
        }

        return false
    }

    private func checkVerticalColumn(_ columnToCheck: Int) -> Bool {
        var consecutive = 0
        for row in board {
            if row[columnToCheck].tile == currentTurnTile() {
                consecutive += 1
                if consecutive >= 4 {
                    filterVertical(item: row[columnToCheck].indexPath)
                    return true
                }
            } else {
                consecutive = 0
            }
        }
        return false
    }
    
    private func filterVertical(item: IndexPath) {
        let res = generateIndexPaths(indexPath: item, count: 4)
        self.holeList = res
    }
    
    private func generateIndexPaths(indexPath: IndexPath, count: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        var currentIndexPath = indexPath
        
        for _ in 0..<count {
            indexPaths.append(currentIndexPath)
            currentIndexPath = IndexPath(row: currentIndexPath.row, section: currentIndexPath.section - 1)
        }
        
        return indexPaths
    }

    //MARK: - Horizontal
    func horizontalVictory() -> Bool {
        for row in board {
            var consecutive = 0
            for column in row {
                if column.tile == currentTurnTile() {
                    consecutive += 1

                    if consecutive >= 4 {
                        filterHorizintalCases(list: row)
                        return true
                    }
                } else {
                    consecutive = 0
                }
            }
        }
        return false
    }
    
    func filterHorizintalCases(list: [BoardItem]) {
        
        let sortedItems = list.sorted(by: { $0.indexPath.row < $1.indexPath.row })
        var result: [BoardItem] = []

        for i in 0..<sortedItems.count {
            if i < 4 {
                result.append(sortedItems[i])
            }
        }
        let indexPath = result.compactMap {$0.indexPath}
        self.holeList = indexPath
    }
}
