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
    var rating: String
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, rating: String) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.rating = rating
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    init(dictionary : Dictionary<String, Any>){
    
        self.locationName = dictionary["locationNAme"] as! String
        self.rating = dictionary["rating"] as! String
        
        let locationDictionary  =  dictionary["location"] as! Dictionary<String, Any>
        self.coordinate = CLLocationCoordinate2D.init(latitude: locationDictionary["Lat"] as! Double, longitude: locationDictionary["long"]  as! Double)
    }
    
    func makeDictionary() -> Dictionary<String, Any>  {
        let  dictionary = [
            "location" : ["Lat":self.coordinate.latitude, "long":self.coordinate.longitude],
            "locationNAme" : self.locationName,
            "rating" : self.rating
            ] as [String : Any]
       
        return dictionary 
    }
}

