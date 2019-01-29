//
//  PinViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/6/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import CoreLocation
import Reachability

class PinViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var getDirectionsButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var photoView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var ratingControl: RatingControl!
    
    let locationManager = CLLocationManager()
    
    var pinInfoRef : PinInfo! // a reference that would contain the pin we want to manipulate (add photo, review, rating etc).
    var selectedAnnotation = SRPointAnnotation()
    
    let reviews = [" ",
                   "Lame! Don't waste your gas. 😒",
                   "Needs improvement. 🤨",
                   "Not bad, but not memorable either. 😒",
                   "Sick! 😜",
                   "Gnarley! Gotta try it! 🤩"]
    
    var selectedReview: Int?
    
    var photosArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createReviewPicker()
        createToolbar()
        
        //Set the Flow Layout
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension2)
        
        photoView.delegate = self
        photoView.dataSource = self
      
    }

    override func viewWillAppear(_ animated: Bool) {
        
         self.photosArray = [String]()
        for url in self.pinInfoRef.photoUrl{
            self.photosArray.append(url)
        }
        self.photoView.reloadData()
        FlickrClient.sharedInstance().downloadPhotosForLocation1(lat:self.pinInfoRef.coordinate?.latitude ?? 0.0 , lon:self.pinInfoRef.coordinate?.longitude ?? 0.0) { (success, urlArray) in
            if success{
                if let array = urlArray {
                    for url in array {
                        self.photosArray.append(url.absoluteString)
                    }
                }
                DispatchQueue.main.async {
                    self.photoView.reloadData()
                }
                
            }
        }
    }
    
    func createReviewPicker() {
        let reviewPicker = UIPickerView()
        reviewPicker.delegate = self
        textField.inputView = reviewPicker
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PinViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getDirections(_ sender: UIBarButtonItem) {
        
        let startPoint  = "?saddr=\(self.locationManager.location?.coordinate.latitude ?? 0.0),\(self.locationManager.location?.coordinate.longitude ?? 0.0)"
        let endpoint = "&daddr=\(self.pinInfoRef!.coordinate?.latitude ?? 0.0),\(self.pinInfoRef.coordinate?.longitude ?? 0.0)"
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string:
                "comgooglemaps://\(startPoint)\(endpoint)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem){
        if let sr = selectedReview{
            self.pinInfoRef.reviews.append(sr)
        }
        if  self.ratingControl.rating > 0{
            self.pinInfoRef.ratings.append(self.ratingControl.rating)
        }
        if let identity = self.pinInfoRef.id {
            Database.database().reference().child("Pins/" + "\(identity)").setValue(self.pinInfoRef.makeDictionary())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoEditorSegue" {
            if let destinationVC = segue.destination as? PhotoEditorViewController {
                destinationVC.pinInfoRef = self.pinInfoRef
            }
        }
    }
}


extension PinViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Picker
    
    //Number of columns of data in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of rows of data in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reviews.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reviews[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedReview = row
        textField.text =  reviews[row]
        
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (3 * space)) / 3.0
        
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("***Collection View: Number of items in section***")
        return  self.photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 3 {
            print("***Collection View: Cell For Row at Index Path***")
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.imageView.kf.setImage(with:  URL.init(string:  self.photosArray[indexPath.row]), placeholder:#imageLiteral(resourceName: "loading image"))
        return cell
        
    }
    
    func downloadSinglePhoto1(photoURL: URL) -> Data? {
        
        return FlickrClient.sharedInstance().makeImageDataFrom1(flickrURL: photoURL)
    }
    
}



