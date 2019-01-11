//
//  MapViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 11/20/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var pinInfo = [PinModel]()
    
    let newPin =  MKPointAnnotation()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Did the user enable location services? If not, show alert.
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
            let alertController = UIAlertController(title: "Location Services", message: "Please enable location services", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // What level did the user authorize?
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alertController = UIAlertController(title: "Enable Location Services", message: "This app works only when location services are enabled. Please go to your Settings and enable location services for this app.", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert how to enable
            break
        case .authorizedAlways:
            break
        }
    }
    
    //Drop pin to current location
    @IBAction func dropIn(_ sender: UIBarButtonItem) {
         mapView.addAnnotation(newPin)
         ref.childByAutoId().setValue([pinInfo])
        
    }
}



extension MapViewController: CLLocationManagerDelegate {
   
    // Update as user moves.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Last known location. If no location use guard statement
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
        newPin.coordinate = location.coordinate
        
       
      
    }
    
    // When permission auth changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
}

