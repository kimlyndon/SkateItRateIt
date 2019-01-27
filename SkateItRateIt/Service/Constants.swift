//
//  Constants.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/27/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

extension FlickrClient {
    struct Constants {
        
        struct Flickr {
            static let APIScheme = "https"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest"
        }
        
        // MARK: Flickr Parameter Keys
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Latitude = "lat"
            static let Longitude = "lon"
            static let Radius = "radius"
            static let ResultsPerPage = "per_page"
            static let format = "format"
            static let NoJSONCallback = "nojsoncallback"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let SearchMethod = "flickr.photos.search"
            static let APIKey = "eaedf0ede48ccdf6f821944917e9d053"
            static let ResponseRadius = "1" // 1 mile radius
            static let ResponseResultsPerPage = "100"
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1" // 1 means "yes"
        }
        
        // MARK: Flickr Response Values
        struct FlickrResponseValues {
            static let OKStatus = "ok"
        }
        
    }
}

