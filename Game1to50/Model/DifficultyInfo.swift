//
//  Difficulty.swift
//  Game1to50
//
//  Created by Steven Lin on 2020/5/20.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import Foundation

enum DifficultyInfo{
    case Easy
    case Medium
    case Hard
    case Master

    init?(tag:Int) {
        switch tag {
        case 1:
            self = .Easy
        case 2:
            self = .Medium
        case 3:
            self = .Hard
        case 4:
            self = .Master
        default:
          return nil
        }
    }

    var itemCount:Int{
        switch self {
        case .Easy:
            return 4
        case .Medium:
            return 9
        case .Hard:
            return 16
        case .Master:
            return 25
        }
    }
}
