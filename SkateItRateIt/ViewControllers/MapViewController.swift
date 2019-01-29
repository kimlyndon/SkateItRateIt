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
import Reachability

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var pinArray = [PinInfo]()
    var selectedAnnotation = SRPointAnnotation()
    
    let newPin =  SRPointAnnotation()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    let annotation = SRPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
        ref.keepSynced(true)
        checkLocationServices()
        self.loadPins()
        
        
        //Reachability
        let reachability = Reachability()
        
        reachability!.whenReachable = { reachability in
            if reachability.connection == .wifi {
                let alertController = UIAlertController(title: "Alert", message: "Reachable via WiFi", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            }
            else {
                let alertController = UIAlertController(title: "Alert", message: "Reachable via Cellular", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        reachability!.whenUnreachable = { reachability in
            let alertController = UIAlertController(title: "Alert", message: "Not Reachable", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        try! reachability!.startNotifier()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerViewOnUserLocation()
    }
    
    
    
    
    //Location
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
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
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
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            let alertController = UIAlertController(title: "Enable Location Services", message: "This app works only when location services are enabled. Please go to your Settings and enable location services for this app.", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            break
        case .authorizedAlways:
            break
        }
        
    }
    
    //Load Pins:
    fileprivate func loadPins() {
        
        var annotations = [SRPointAnnotation]()
        
        //fetch the data from firebase.
        self.ref.child("Pins").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //iterate among children
            for child in snapshot.children.allObjects  as! [DataSnapshot]
            {
                let pin  = PinInfo.init(dictionary:child.value as! Dictionary<String, Any>)
                pin.id = child.key
                if let coordinate = pin.coordinate {
                   
                    
                    //create annotation
                    let annotation = SRPointAnnotation()

                    if let rating = pin.rating {
                        annotation.title = "\(rating)"
                    }
                    if let review = pin.review{
                        annotation.subtitle = "\(review)"
                    }

                    annotation.coordinate = coordinate // user created pin coordinates to add on map.
                    annotation.pinInfoRef = pin // getting pin reference
                    annotations.append(annotation)
                    self.pinArray.append(pin) //add to the array
                }
                
            }
            
            //add annotation to map
            self.mapView.addAnnotations(annotations)
            
        })
        
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
            let pin = PinInfo.init(locationName: "Spot", coordinate: coordinate)
            
            //add map annotation
            let annotation = SRPointAnnotation()
            annotation.coordinate = coordinate
            
            //add annotation to map
            self.mapView.addAnnotation(annotation)
            
            self.ref.child("Pins").childByAutoId().setValue( pin.makeDictionary() )
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        
        // create an object of the model
        let pin = PinInfo.init(locationName: "Spot", coordinate: coordinate)
        self.ref.child("Pins").childByAutoId().setValue( pin.makeDictionary() )
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Update as user moves.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Last known location. If no location use guard statement
        guard let location = locations.last else { return }
        newPin.coordinate = location.coordinate
    }
    
    // When permission auth changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    //Segue to ReviewViewController when user taps pin
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? SRPointAnnotation{
            self.selectedAnnotation = annotation
            performSegue(withIdentifier: "pin", sender: self)
        }
        
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
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.animatesDrop = true
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
            } else {
                
                pinView!.annotation = annotation
            }
            
            return pinView
        }
    }
    
    // Since we pass reference of our model to the next view controller we need to make sure that we override following method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pin" {
            if let destinationVC = segue.destination as? PinViewController {
                destinationVC.pinInfoRef = self.selectedAnnotation.pinInfoRef
            }
        }
    }
}

