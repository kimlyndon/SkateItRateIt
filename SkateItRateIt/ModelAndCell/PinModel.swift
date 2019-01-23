//
//  PinModel.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//
// dictionary init code attributed to Fahad Shafique


import Foundation
import MapKit

class PinInfo: NSObject {
    var locationName: String?
    var coordinate: CLLocationCoordinate2D?
    var rating: [Int]?
    var id: String?
    var photoUrl: [String]?
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    init(dictionary : Dictionary<String, Any>){
        if let spot = dictionary["locationName"] as? String {
            self.locationName = spot
        }
        
        
        let locationDictionary  =  dictionary["location"] as! Dictionary<String, Any>
        self.coordinate = CLLocationCoordinate2D.init(latitude: locationDictionary["Lat"] as! Double, longitude: locationDictionary["long"]  as! Double)
    }
    
    func makeDictionary() -> Dictionary<String, Any>  {
        let  dictionary = [
            "location" : ["Lat":self.coordinate?.latitude, "long":self.coordinate?.longitude],
            "locationName" : self.locationName,
            "rating" : self.rating
            ] as [String : Any]
       
        return dictionary 
    }
}

