//
//  PinViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/6/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit

class PinViewController: UIViewController, UINavigationControllerDelegate {
    
   
    @IBOutlet weak var getDirectionsButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var picker: UIPickerView!
    
    let reviews = ["Lame! Don't waste your gas. 😒",
                   "Needs improvement. 🤨",
                   "Worth the trip! 😎",
                   "Sick! 😜",
                   "Gnarley! Gotta try it! 🤩"]
    
    var selectedReview: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createReviewPicker()
        picker.delegate = self
        createToolbar()
    }
    
    func createReviewPicker() {
        let reviewPicker = UIPickerView()
        reviewPicker.delegate = self
    }
    
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PinViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getDirections(_ sender: UIBarButtonItem) {
    }
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
}
    

extension PinViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
        
    }

}
