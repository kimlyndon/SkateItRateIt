//
//  MapViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 11/20/18.
//  Copyright © 2018 Kim Lyndon. All rights reserved.
//
//  loadPin method code for Firebase attributed to Fahad Shafique

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var pinArray = [PinInfo]()
    
    let newPin =  MKPointAnnotation() 
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    let annotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
        checkLocationServices()
        self.loadPins()
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
    
    // Check level of user authorization
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
    
    //Load Pins:
    fileprivate func loadPins() {
        
       var annotations = [MKPointAnnotation]()
        
        //fetch the data from firebase.
        self.ref.child("Pins").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //iterate among children
            for child in snapshot.children.allObjects  as! [DataSnapshot]
            {
                let pin  = PinInfo.init(dictionary:child.value as! Dictionary<String, Any>)
                
                //add to the array
                self.pinArray.append(pin)
                
                //create annotation
                let annotation = MKPointAnnotation()
                
                // user created pin coorodates to give coordinates to map.
                annotation.coordinate = pin.coordinate
                
                annotations.append(annotation)
            }
          
        })

        //add annotation to map
        self.mapView.addAnnotations(annotations)
    }
    
    //Drop pin to current location
    @IBAction func dropIn(_ sender: UIBarButtonItem) {
        self.mapView.addAnnotation(self.newPin)
        self.ref.child("Pins").childByAutoId().setValue(["location":["Lat": Double(self.annotation.coordinate.latitude), "long":Double(annotation.coordinate.longitude)]])
    }
    
    // Long press pin drop
    @IBAction func getTouchLocation(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            
            //add map annotation
            self.annotation.coordinate = coordinate
            
            //add annotation to map
            self.mapView.addAnnotation(self.annotation)
            self.ref.child("Pins").childByAutoId().setValue(["location":["Lat": Double(self.annotation.coordinate.latitude), "long":Double(annotation.coordinate.longitude)]])
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        
        // create an object of the model
        let pin = PinInfo.init(locationName: "some name", coordinate: coordinate, rating: "rating")
        self.ref.child("Pins").childByAutoId().setValue( pin.makeDictionary() )
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "pin", sender: self)
    }
    
    // Make the annotation a red pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation){
            return nil
            
        } else {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = false
                pinView!.pinTintColor = .red
                pinView!.animatesDrop = true
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
            } else {
                
                pinView!.annotation = annotation
            }
            
            return pinView
        }
    }
}

