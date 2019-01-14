//
//  PinViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/6/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit

class PinViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var photoAlbumButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
  
    
    @IBAction func cameraButtonPressed() {
    let pinVc = UIImagePickerController()
        pinVc.sourceType = UIImagePickerController.SourceType.camera
    self.present(pinVc, animated: true, completion: nil)
}
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
       dismiss(animated: true, completion: nil)
        
    }
    
}
