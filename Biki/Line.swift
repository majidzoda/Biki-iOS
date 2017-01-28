//
//  Line.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 11/9/16.
//  Copyright © 2016 Biki. All rights reserved.
//

import Foundation
import GoogleMaps

class Line {
    let id: String
    let riskLevel: Int
    let coordinates: [CLLocationCoordinate2D]
    
    init(id: String, riskLevel: Int, coordinates: [CLLocationCoordinate2D]){
        self.id = id
        self.riskLevel = riskLevel
        self.coordinates = coordinates
    }
}

