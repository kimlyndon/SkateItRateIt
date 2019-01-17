//
//  PinModel.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//


import Foundation
import MapKit

class PinInfo: NSObject, MKAnnotation {
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let userId: String
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, userId: String) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.userId = userId
        
        
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

