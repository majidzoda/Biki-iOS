//
//  SnowAreaStore.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 1/16/17.
//  Copyright © 2017 Biki. All rights reserved.
//

import Foundation
import Alamofire

enum SnowAreaResult {
    case Success([SnowArea])
    case Failure(Error)
}

class SnowAreaStore {

    
    func fetchSnowAreas(completion: @escaping (SnowAreaResult) -> Void) {
        
        Alamofire.request(BikiAPI.getURL(endPoint: "?rquest=ReadAreaSnow")).response{
            response in
            
            
            let result = self.processSnowAreaRequest(data: response.data as NSData?, error: response.error as NSError?)
            completion(result)
            
        }
    }
    
    
    func  processSnowAreaRequest(data: NSData?, error: NSError?) -> SnowAreaResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        return BikiAPI.snowAreaFromJSONData(data: jsonData as Data)
    }
}
