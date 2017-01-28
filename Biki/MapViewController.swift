//
//  MapViewController.swift
//  Biki
//
//  Created by Firdavsii Majidzoda on 11/8/16.
//  Copyright © 2016 Biki. All rights reserved.
//

import GoogleMaps
import AVFoundation
import Alamofire

class MapViewController: UIViewController, GMSMapViewDelegate {
    let riskLevelString = "http://ec2-54-84-189-11.compute-1.amazonaws.com/api.php?rquest=riskLevel"
    
    // MARK: Test Snow Image
    @IBOutlet var snowImage: UIImageView!
    
    
    
    // MARK: Outlets
    @IBOutlet var riskLevelLabel: UILabel!
    @IBOutlet var soundId: UITextField!
    @IBOutlet var googleMapView: GMSMapView!
    
    // MARK: Fields
    private var store: LineStore!
    private var snowAreaStore: SnowAreaStore!
    private var rainAreaStore: RainAreaStore!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineConfiguration()
        rainConfiguration()
        snowConfiguration()
        googleMapViewConfiguration()
        
//        getSnow()
    }
    
    private func lineConfiguration(){
        store = LineStore()
        getLines()
    }
    
    private func snowConfiguration(){
        snowAreaStore = SnowAreaStore()
        getSnowArea()
    }
    
    private func rainConfiguration(){
        rainAreaStore = RainAreaStore()
        getRainArea()
    }
    
    private func googleMapViewConfiguration(){
        googleMapView.animate(to: GMSCameraPosition.camera(withLatitude: 40.763194, longitude: -73.978891, zoom: 11))
        googleMapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if googleMapView.myLocation != nil {
            print(googleMapView.myLocation?.coordinate as Any)
            guard let lat = googleMapView.myLocation?.coordinate.latitude.description,
                let lon = googleMapView.myLocation?.coordinate.longitude.description else {
                    print("no lat and lon")
                    return
            }
            print(lat)
            print(lon)
            riskLevel(params: ["Lon": lon, "Lat": lat])
            
            getLiveWeatherAndDrawOnMap(lat: Double(lat), lon: Double(lon))
            
        } else {
            print("User's location is unknown")
        }

    }
    
    // MARK: TEST BUTTON
    /**
        Get lat & lon fetch risk level, alert user with a sound
     */
    @IBAction func playSound(_ sender: Any) {
        if googleMapView.myLocation != nil {
            print(googleMapView.myLocation?.coordinate as Any)
            guard let lat = googleMapView.myLocation?.coordinate.latitude.description,
            let lon = googleMapView.myLocation?.coordinate.longitude.description else {
                print("no lat and lon")
                return
            }
            print(lat)
            print(lon)
            riskLevel(params: ["Lon": lon, "Lat": lat])
        } else {
            print("User's location is unknown")
        }
    }
    
    /**
        Fetch lines, sort out and draw on the map.
     */
    func getLines() {
        store.fetchRecentLines() {
            (lineResult) -> Void in
            
            switch lineResult {
            case let .Success(lines):
                print("Successfully found \(lines.count) recent lines.")
                for line in lines {
                    let path = GMSMutablePath()
                    for coordinates in line.coordinates {
                        path.add(coordinates)
                    }
                    OperationQueue.main.addOperation {
                        let polyline = GMSPolyline(path: path)
                        switch line.riskLevel{
                        case 1...3:
                            polyline.strokeColor = UIColor.blue
                        case 4...6:
                            polyline.strokeColor = UIColor.yellow
                        case 7...9:
                            polyline.strokeColor = UIColor.red
                        default:
                            break
                        }
                        polyline.map = self.googleMapView
                    }
                }
            case let .Failure(error):
                print("Error fetching recent lines: \(error)")
            }
        }
        
    }
    
    /**
        
     */
    func riskLevel(params: [String:String]){
        Alamofire.request(BikiAPI.getURL(endPoint: "?rquest=riskLevel"),  parameters: params).responseString{
            (response) -> Void in
            

            // Checking if we have a successful result
            guard response.result.isSuccess else {
                // Unsuccessful query
                print("Unssuccesful connection for riskLevel")
                return
            }
            
            
            let result = response.description
            
            let array = result.components(separatedBy: ":")
            let array1 = array[2]
            
            let array2 = array1.components(separatedBy: "\"")
            let level = array2[1]
            self.checkLevel(Level: level)
            
        }
    }
    
    func checkLevel(Level: String) {
        
        guard var level = Int(Level) else {
            print("no int")
            return
        }
        
        let systemSoundID: SystemSoundID!
        
        if soundId.hasText{
            level = Int(soundId.text!)!
            
        }
        if soundId.isFirstResponder{
            soundId.resignFirstResponder()
        }
        riskLevelLabel.text = String(level)
        
        switch level {
        case 1...3:
            break
        case 4...6:
            systemSoundID = UInt32(1005)
            AudioServicesPlaySystemSound (systemSoundID)
        case 6...9:
            systemSoundID = UInt32(1151)
            AudioServicesPlaySystemSound (systemSoundID)
        default:
            break
        }
    }
    
    
    // MARK: Live wheather (Cely)
    private func getLiveWeatherAndDrawOnMap(lat: Double, lon: Double){
        // Develope codes for getting a live weather result.
        
        // TODO: call getSnowArea() method if you get snow 
        // TODO call getRainArea() method if you get rain
    }
    
    
    // MARK: Snow
    
    private func getSnowArea(){
        snowAreaStore.fetchSnowAreas{
            (snowAreaResult) -> Void in
            
            switch snowAreaResult {
            case let .Success(areas):
                print("Successfully found \(areas.count) snow areas.")
                // TODO: Draw snow area
                for area in areas{
                   self.drawPolygonForSnowAreaTest(area: area)
                }
                
            case let .Failure(error):
                print("Error fetching snow areas: \(error)")
            }
        }
    }
    
    private func drawPolygonForSnowAreaTest(area: SnowArea){
        // Create a rectangular path
        let rect = GMSMutablePath()
        
        for point in area.points {
            rect.add(CLLocationCoordinate2D(latitude: point.lon, longitude: point.lat))
        }
        
        
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = .blue
        polygon.strokeColor = .blue
        polygon.strokeWidth = 2
        polygon.map = googleMapView
    }
    
    
    // MARK: Rain
    
    private func getRainArea(){
        rainAreaStore.fetchRainAreas{
            (snowAreaResult) -> Void in
            
            switch snowAreaResult {
            case let .Success(areas):
                print("Successfully found \(areas.count) rain areas.")
            // TODO: Draw snow area
                for area in areas {
                    self.drawPolygonForRainAreaTest(area: area)
                }
                
            case let .Failure(error):
                print("Error fetching rain areas: \(error)")
            }
        }
    }
    
    
    private func drawPolygonForRainAreaTest(area: RainArea){
        // Create a rectangular path
        let rect = GMSMutablePath()
        
        for point in area.points {
            rect.add(CLLocationCoordinate2D(latitude: point.lon, longitude: point.lat))
        }
        
        
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = .green
        polygon.strokeColor = .green
        polygon.strokeWidth = 2
        polygon.map = googleMapView
    }
}
