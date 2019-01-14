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


/*
 NOTE KIM:
 
 Here are some points on how the Firebase works.  
- Everything on firebase (FB) has node (firebase calls it “chid” ) and its value.
- FB sends and receives values as key value pairs.
- You can fetch and put any value of the node by  giving reference of the specific node key (e.g. Pins).
- While fetching /sending node ’s value every child node and their corresponding values will be fetch/send all at once ( usually regarded as snapshot ).
- If a specific node does not exist and you try to send it, it ll create a new node (entry). If the node who’s value you are sending exist already, i ll override the existing value (sort of editing).
- Database (who’s reference you get) does not store images (files), for storing images (files) you ll use  https://firebase.google.com/docs/storage/ and you ll upload files by reading here https://firebase.google.com/docs/storage/ios/upload-files once you have uploaded a file you ll store the url of the file in you FB database. so there are two different things. FB Database and FB Storage.
 
 */



class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var pinArray = [PinInfo]()
    
    let newPin =  MKPointAnnotation() //  NOTE KIM:  you don't specifically need to have a class property here, just create a pin and add it to map's pins.
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
        checkLocationServices()
        self.ref.child("Pins").observeSingleEvent(of: .value, with: { (snapshot) in
        })

        
        
        /*
             NOTE KIM: 
         
        - once you have loaded all of the pins you can drop them to the map by a simple add pin method as you ll ilterate the pins you have loaded. e.g. for pin in loadedPins 
         */
        
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerViewOnUserLocation()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithOtherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
            let alertController = UIAlertController(title: "Enable Location Services", message: "This app works only when location services are enabled. Please go to your Settings and enable location services for this app.", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
            break
        case .authorizedAlways:
            break
        }
    }
    
    //Drop pin to current location
    @IBAction func dropIn(_ sender: UIBarButtonItem) {
        mapView.addAnnotation(newPin) //
        self.ref.child("Pins").childByAutoId().setValue(["location":["Lat":35.23344, "long":-80.85261]])
    }
    
    // Long press pin drop
    @IBAction func getTouchLocation(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            //add map annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            //add annotation to map
            self.mapView.addAnnotation(annotation)
            ref.childByAutoId().setValue(["location":["Lat":35.23344, "long":-80.85261]])
        }
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
        
        /*  NOTE KIM:
           mapView.setRegion(region, animated: true)
          - you don't need to set map's location here all of the time this delegate method is called. it is updated on user's device location change and you can only use it for storing user's last location only.
          - For showing user's location on map just call a method of map to show user's location.
         
            newPin.coordinate = location.coordinate
          - Again don't store pin's location like that, you got to drop pin on visible map's centre and not on user location's current location, i believe.
        */
        newPin.coordinate = location.coordinate
        
    }
    
    // When permission auth changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    // Make the annotation a red pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}

