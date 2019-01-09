//
//  PinModel.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

// This file is for the Firebase Realtime Database JSON data.

class PinModel {
    
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var photos: NSSet?
    var rating: Double?
    
    init(id: String?, latitude: Double?, longitude: Double?, photos: NSSet?, rating: Double?) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.photos = photos
        self.rating = rating
    }
    
}
