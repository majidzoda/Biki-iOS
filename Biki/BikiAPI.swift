//
//  BikiAPI.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 11/9/16.
//  Copyright © 2016 Biki. All rights reserved.
//



import Foundation
import GoogleMaps
import Alamofire


struct BikiAPI {
    
    private static let baseURLString = "http://ec2-54-84-189-11.compute-1.amazonaws.com/api.php"
    
    
    private static func bikiURL(endPoint: String) -> String {
        return baseURLString+endPoint
    }
    
    static func getURL(endPoint: String) -> String {
        return bikiURL(endPoint: endPoint)
    }
    
    
    
    
    static func linesFromJSONData(data: NSData) -> LineResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data as Data, options: []) as? [[AnyObject]]
            
            guard let
                linesArray = jsonObject,
                let line = linesArray[0] as? [AnyObject],
                let id = line[0] as? String,
                let riskLevel = line[1] as? String,
                let coordinates = line[2] as? [AnyObject],
                let latLon = coordinates[0] as? [AnyObject],
                let lat = latLon[0] as? String,
                let lon = latLon[1] as? String else {
                    // The JSON structure doesn't match our expectations
                    return .Failure(BikiError.InvalidJSONData)
            }
            
            var finalLines = [Line]()
            for lineJSON in linesArray {
                if let line = lineFromJSONObject(json: lineJSON) {
                    finalLines.append(line)
                }
            }
            
            if finalLines.count == 0 && linesArray.count > 0 {
                // We weren't able to parse any of the lines
                // Maybe the JSON format for lines has changed
                return .Failure(BikiError.InvalidJSONData)
            }
            return .Success(finalLines)
        } catch let error {
            return .Failure(error)
        }
    }
    
    private static func lineFromJSONObject(json: [AnyObject]) -> Line? {
        var co = [CLLocationCoordinate2D]()
        
        guard let
            id = json[0] as? String,
            let riskLevel = json[1] as? String,
            let coordinates = json[2] as? [AnyObject] else {
                // Don't have enough information to construct a Line
                return nil
        }
        
        for point in coordinates {
            guard let
                p = point as? [AnyObject],
                let latString = p[0] as? String,
                let lonString = p[1] as? String,
                let lat = Double(latString),
                let lon = Double(lonString) else { return nil }
            
            co.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        
        return Line(id: id, riskLevel: Int(riskLevel)!, coordinates: co)
    }
    
    
    
    
    
    // MARK: Snow
    static func snowAreaFromJSONData(data: Data) -> SnowAreaResult{
        do{
            guard let snowAreaArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[AnyObject]] else {
                print("No array")
                return .Failure(BikiError.InvalidJSONData)
            }
            
            var finalSnowAreas = [SnowArea]()

            for snowArea in snowAreaArray{
                if let area = snowAreaFROMJSONObject(json: snowArea){
                    finalSnowAreas.append(area)
                }
            }
            
            if finalSnowAreas.count == 0 && snowAreaArray.count > 0{
                return .Failure(BikiError.InvalidJSONData)
            }
            
            return .Success(finalSnowAreas)
            
            
            
        } catch let error {
                return .Failure(error)
        }
    }
    
    private static func snowAreaFROMJSONObject(json: [AnyObject]) -> SnowArea?{
        var pointsPoint = [Point]()
        
        guard let areaNumber = json[0] as? String,
            let gridCode = json[1] as? String,
            let points = json[2] as? [AnyObject] else
            {
                print("Wrong snowAraa")
                return nil
            }
        
        for point in points{
            guard let p = point as? [AnyObject],
            let latString = p[0] as? String,
            let lonString = p[1] as? String,
            let lat = Double(latString),
                let lon = Double(lonString) else {
                    return nil
            }
            let pointPoint = Point(lat: lat, lon: lon)
            pointsPoint.append(pointPoint)
            
        }
        
        return SnowArea(snowArea: Int(areaNumber)!, gridCode: Int(gridCode)!, points: pointsPoint)
    }
 
    // MARK: Rain
    static func rainAreaFromJSONData(data: Data) -> RainAreaResult{
        do{
            guard let rainAreaArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[AnyObject]] else {
                print("No array")
                return .Failure(BikiError.InvalidJSONData)
            }
            
            var finalTainAreas = [RainArea]()
            
            for rainArea in rainAreaArray{
                if let area = rainAreaFROMJSONObject(json: rainArea){
                    finalTainAreas.append(area)
                }
            }
            
            if finalTainAreas.count == 0 && rainAreaArray.count > 0{
                return .Failure(BikiError.InvalidJSONData)
            }
            
            return .Success(finalTainAreas)
            
            
            
        } catch let error {
            return .Failure(error)
        }
    }
    
    private static func rainAreaFROMJSONObject(json: [AnyObject]) -> RainArea?{
        var pointsPoint = [Point]()
        
        guard let areaNumber = json[0] as? String,
            let gridCode = json[1] as? String,
            let points = json[2] as? [AnyObject] else
        {
            print("Wrong snowAraa")
            return nil
        }
        
        for point in points{
            guard let p = point as? [AnyObject],
                let latString = p[0] as? String,
                let lonString = p[1] as? String,
                let lat = Double(latString),
                let lon = Double(lonString) else {
                    return nil
            }
            let pointPoint = Point(lat: lat, lon: lon)
            pointsPoint.append(pointPoint)
            
        }
        
        return RainArea(snowArea: Int(areaNumber)!, gridCode: Int(gridCode)!, points: pointsPoint)
    }
    
}
