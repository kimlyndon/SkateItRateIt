//
//  PhotoViewController.swift
//  SkateItRateIt
//
//  Created by Kim Lyndon on 1/8/19.
//  Copyright © 2019 Kim Lyndon. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoViewController: UICollectionViewController {
    
    @IBOutlet weak var photoView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension2)
        
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
        
    }
    
 /*   // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space:CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let dimension2 = (view.frame.size.height - (2 * space)) / 3.0
        
        return CGSize(width: dimension, height: dimension2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("***Collection View: Number of items in section***")
        return photoView.numberOfObjects ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 3 {
            print("***Collection View: Cell For Row at Index Path***")
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        
        
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = cell.bounds
        cell.backgroundColor = UIColor.darkGray
        cell.imageView.alpha = 0.5
        cell.addSubview(activityIndicator)
        cell.imageView.image = #imageLiteral(resourceName: "VirtualTourist_1024")
        activityIndicator.startAnimating()
        
        let aPhoto = image.object(at: indexPath)
        
        if aPhoto.image != nil {
            
            cell.photoView.image = UIImage(data: aPhoto.image!)
            cell.photoView.alpha = 1.0
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            return cell
            
        } else { */
            
    
}

