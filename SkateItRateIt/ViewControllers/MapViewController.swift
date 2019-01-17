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

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var pinArray = [PinInfo]()
    
    let newPin =  MKPointAnnotation() //  NOTE KIM:  you don't specifically need to have a class property here, just create a pin and add it to map's pins.
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
        
        
        //https://stackoverflow.com/questions/44354730/loading-map-pins-from-firebase-onto-mapkit-in-swift-for-all-users-to-be-able-to SIMILAR PROJECT WITH SAME QUESTION. WOULD THIS BE THE WAY TO GO?
        
        //OR ADAPT THE FOLLOWING CODE?
        
        //Load Pins: NOT SURE HOW TO REFORMAT THE CODE WITHOUT CORE DATA!
    }
    
    fileprivate func loadPins()
    {
       var annotations = [MKPointAnnotation]()
        
        self.ref.child("Pins").observeSingleEvent(of: .value, with: { (snapshot) in // that's is how we fetch the data from firebase.
            
            for child in snapshot.children.allObjects  as! [DataSnapshot] // here we are iterating among different child we wll be getting formt he firebase
            {
                let pin  = PinInfo.init(dictionary:child.value as! Dictionary<String, Any>) // i have created a new inintialiser for pininfo sp that you can send in dictionary fetched from the firebase and you can create a model out of it.
                self.pinArray.append(pin) // adding to the array so that it can be used later in the controller.
                //create annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = pin.coordinate // user created pin coorodates to give coordinates to map. 
                
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
            self.ref.child("Pins").childByAutoId().setValue(["location":["Lat": Double(self.annotation.coordinate.latitude), "long":Double(annotation.coordinate.longitude)]]) // its better if you create a pininfo object and send that to firebase because that is what you got to be using. just like i did in add pin method.
            
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        
        let pin = PinInfo.init(locationName: "some name", coordinate: coordinate, userId: "anyid") // create an object of the model you have created. now that it has been initialised you can change any of the individial value of it as well. like pin.locationName etc.
        self.ref.child("Pins").childByAutoId().setValue( pin.makeDictionary() ) // now i have added a method in model class to convert the data store in a model to change into dictionary and then i am sedning to firebase.
        
        // And thats all you got to do to store data to firebase, easy isn't it!
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

