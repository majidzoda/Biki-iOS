//
//  LineStore.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 11/9/16.
//  Copyright © 2016 Biki. All rights reserved.
//

/*
 (
 11953,
 2,
 (
 (
 "40.8360197681",
 "-73.9242972433"
 ),
 (
 "40.8373163244",
 "-73.9233021580"
 )
 )
 */

import UIKit
import GoogleMaps
import Alamofire

enum LineResult {
    case Success([Line])
    case Failure(Error)
}

enum BikiError: Error {
    case InvalidJSONData
}

class LineStore {
    
    func fetchRecentLines(completion: @escaping (LineResult) -> Void) {
        
        Alamofire.request(BikiAPI.getURL(endPoint: "?rquest=ReadStreet")).response{
            response in
            
            
            let result = self.processRecentLinesRequest(data: response.data as NSData?, error: response.error as NSError?)
            completion(result)
            
        }
    }
    
    
    func  processRecentLinesRequest(data: NSData?, error: NSError?) -> LineResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return BikiAPI.linesFromJSONData(data: jsonData)
    }
}
