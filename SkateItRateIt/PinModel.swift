//
//  PinModel.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

// This file is for the Firebase Realtime Database JSON data.

class PinModel {
    /*
     NOTE KIM: we don't need to make struct in class.
     we can just make properties here (if you don't know properties please read about them.. its a must to know)
     once you have created proper properties.. you can make object of this class and once you have made the object
     you acn access the properties and then set the values to store after fetching them from firebase.
     Let me know if you wnat more understanding about what i am saying. 
     */
    struct Pin {
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let photos = "photos"
        static let rating = "rating"
    }
    
}
