//
//  BoardItem.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import Foundation
import UIKit

struct BoardItem {
    var indexPath: IndexPath!
    var tile: CandyType!
    
    func purpleTile() -> Bool {
        return tile == CandyType.purple
    }
    
    func blueTile() -> Bool {
        return tile == CandyType.blue
    }
    
    func emptyTile() -> Bool {
        return tile == CandyType.empty
    }
    
    func tileColor() -> UIColor {
        if blueTile() {
            return .blue
        }
        
        if purpleTile() {
            return .purple
        }
        
        return .white
    }
}
