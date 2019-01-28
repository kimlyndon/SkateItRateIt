//
//  PhotoEditorViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/14/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import FirebaseStorage
import Reachability

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
        dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //TODO: Code to save image to collection view
       /* let url = URL(string: <#T##String#>)
        imagePickerView.kf.setImage(with: url) */
        
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
            
            }
        }
        present(activityViewController, animated: true, completion: nil)
        
        
    }
}

extension PhotoEditorViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // constant to hold the information about the photo
        if let photo = info[.originalImage] as? UIImage {
            if  let photoData = photo.jpegData(compressionQuality: 0.8) {
                imagePickerView.image = photo
                
                // call function to upload photo
                uploadPhotos(photoData: photoData)
            }
            
            picker.dismiss(animated: true, completion: nil)
            
                }
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true, completion: nil)
            }
            
            func uploadPhotos(photoData: Data) {
                
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("spot_photos/" + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg")
                
                // Upload the file to the path "images/rivers.jpg"
                riversRef.putData(photoData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print("Unable to upload file.")
                        return
                    }
                   print ("size: ",metadata.size)
                    
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("Unable to access URL") 
                            return
                        }
                        
                        print("download url is: ", downloadURL)
                    }
                    
                }
                
            }
            
        }
    




