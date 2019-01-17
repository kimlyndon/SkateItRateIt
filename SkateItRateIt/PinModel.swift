//
//  PinModel.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//


import Foundation
import MapKit

class PinInfo: NSObject {
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var userId: String
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, userId: String) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.userId = userId
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    init(dictionary : Dictionary<String, Any>){
    
        self.locationName = dictionary["locationNAme"] as! String
        self.userId = dictionary["userID"] as! String
        
        let locationDictionary  =  dictionary["location"] as! Dictionary<String, Any>
        self.coordinate = CLLocationCoordinate2D.init(latitude: locationDictionary["Lat"] as! Double, longitude: locationDictionary["long"]  as! Double)
    }
    
    func makeDictionary() -> Dictionary<String, Any>  {
        let  dictionary = [
            "location" : ["Lat":self.coordinate.latitude, "long":self.coordinate.longitude],
            "locationNAme" : self.locationName,
            "userID" : self.userId
            ] as [String : Any]
       
        return dictionary 
    }
}

