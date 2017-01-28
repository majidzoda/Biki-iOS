//
//  RainArea.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 1/16/17.
//  Copyright © 2017 Biki. All rights reserved.
//

import Foundation

class RainArea {
    let snowArea: Int
    let gridCode: Int
    let points: [Point]
    
    init(snowArea: Int, gridCode: Int, points: [Point]) {
        self.snowArea = snowArea
        self.gridCode = gridCode
        self.points = points
    }
    
}
