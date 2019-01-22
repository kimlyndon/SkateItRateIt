//
//  PhotoEditorViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/14/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import FirebaseStorage

class PhotoEditorViewController: UIViewController,  UINavigationControllerDelegate  {
    
    var storageRef: StorageReference!
    let storage = Storage.storage()
    let imageCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var photoAlbumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStorage()
        imagePicker.delegate = self
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
    func pick(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func generateImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
     let pictureViewController = PhotoViewController()
        present(pictureViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cameraButtonPressed() {
      pick(sourceType: .camera)
    
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        pick(sourceType: .photoLibrary)
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let images = generateImage()
        let activityViewController = UIActivityViewController(activityItems: [images], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {activity, didComplete, item, error in if didComplete {
            self.saveButtonPressed(self.saveButton)
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            }
        }
        present(activityViewController, animated: true, completion: nil)
        
        
    }
}

extension PhotoEditorViewController: UIImagePickerControllerDelegate {

    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        // constant to hold the information about the photo
     /*  if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
            
            // call function to upload photo message
            uploadPhotos(photoData: photoData)
        }
        picker.dismiss(animated: true, completion: nil)
    } */
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhotos(photoData: Data) {
        
        // build a path using the user’s ID and a timestamp
        let imagePath = "spot_photos/" + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        // set content type to “image/jpeg” in firebase storage metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // create a child node at imagePath with imageData and metadata
        storageRef!.child(imagePath).putData(photoData, metadata: metadata) { (metadata, error) in
            if error != nil {
                print("Error uploading photo")
                return
            }
            // add imageURL to database
           // self.saveButton([PinInfo.photoUrl: self.storageRef!.child((metadata?.path)!).description])
        }
}

}

}
