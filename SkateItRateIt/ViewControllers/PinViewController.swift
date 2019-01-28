//
//  PinViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/6/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import Kingfisher
import Reachability

class PinViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var getDirectionsButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var photoView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var ratingControl: RatingControl!
    
    let reviews = [" ",
                   "Lame! Don't waste your gas. 😒",
                   "Needs improvement. 🤨",
                   "Worth the trip! 😎",
                   "Sick! 😜",
                   "Gnarley! Gotta try it! 🤩"]
    
    var selectedReview: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createReviewPicker()
        createToolbar()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension2)
        
        photoView.delegate = self
        
        
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
        
       // let directionsURL = URL(string: "https://www.google.com/maps/dir/?api=1&origin&destination")
        // OR: let directionsURL = "https://www.google.com/maps/search/?api=1&query=\(selectedPin.coordinate.latitude),\(selectedPin.coordinate.longitude)" and add "selectedPin" to PinModel? 
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        selectedReview = reviews[row]
        textField.text = selectedReview
        
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        return CGSize(width: dimension, height: dimension2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("***Collection View: Number of items in section***")
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 3 {
            print("***Collection View: Cell For Row at Index Path***")
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        
        //MARK: Activity Indicator
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = cell.bounds
        cell.backgroundColor = UIColor.darkGray
        cell.imageView.alpha = 0.5
        cell.addSubview(activityIndicator)
        cell.imageView.image = #imageLiteral(resourceName: "loading image")
        activityIndicator.startAnimating()
        
        let aPhoto = UIImageView.init()
        
        if let image = aPhoto.image {
            
            cell.imageView.image = image
            cell.imageView.alpha = 1.0
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        
        }
            return cell

        }
    
    func downloadSinglePhoto1(photoURL: URL) -> Data? {
        
        return FlickrClient.sharedInstance().makeImageDataFrom1(flickrURL: photoURL)
    }
    
}


