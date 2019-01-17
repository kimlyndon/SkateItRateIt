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
    
}
