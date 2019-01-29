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
    var id: String?
    var photoUrl = [String]()
    var downloadURL: String?
    var reviews = [Int] ()
    var ratings = [Int] ()
    
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
        
        if let urlArray = dictionary["imageURL"] as? [String] {
            self.photoUrl = urlArray
        }
        
        if let urlArray = dictionary["ratings"] as? [Int] {
            self.ratings = urlArray
        }
        
        if let urlArray = dictionary["reviews"] as? [Int] {
            self.reviews = urlArray
        }
        
        let locationDictionary  =  dictionary["location"] as! Dictionary<String, Any>
        if let lat = locationDictionary["Lat"] as? Double,
            let long = locationDictionary["long"] as? Double {
            
            self.coordinate = CLLocationCoordinate2D.init(latitude:lat, longitude:long )
        }
        
    }
    
    func makeDictionary() -> Dictionary<String, Any>  {
        let  dictionary = [
            "location" : ["Lat":self.coordinate?.latitude, "long":self.coordinate?.longitude],
            "locationName" : self.locationName ?? "" ,
            "ratings" : self.ratings,
            "reviews" : self.reviews,
            "imageURL" : self.photoUrl
            ] as [String : Any]
        
        return dictionary 
    }
}

