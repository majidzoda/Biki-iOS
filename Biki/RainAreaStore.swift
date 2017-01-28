//
//  RainAreaStore.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 1/16/17.
//  Copyright © 2017 Biki. All rights reserved.
//

import Foundation
import Alamofire

enum RainAreaResult {
    case Success([RainArea])
    case Failure(Error)
}

class RainAreaStore {
    
    
    func fetchRainAreas(completion: @escaping (RainAreaResult) -> Void) {
        
        Alamofire.request(BikiAPI.getURL(endPoint: "?rquest=ReadAreaRain")).response{
            response in
            
            
            let result = self.processRainAreaRequest(data: response.data as NSData?, error: response.error as NSError?)
            completion(result)
            
        }
    }
    
    
    func  processRainAreaRequest(data: NSData?, error: NSError?) -> RainAreaResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return BikiAPI.rainAreaFromJSONData(data: jsonData as Data)
    }
}
