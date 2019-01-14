//
//  PinViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/6/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit

class PinViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
 
  
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
        
    }
    
}
