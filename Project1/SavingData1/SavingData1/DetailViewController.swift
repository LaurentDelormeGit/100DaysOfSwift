//
//  DetailViewController.swift
//  SavingData1
//
//  Created by Laurent Delorme on 05/09/2019.
//  Copyright © 2019 Laurent Delorme. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var image: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedImage
        
        assert(selectedImage == nil, "var selectedImage is nil")
        
        if let imageToLoad = selectedImage {
            image.image = UIImage(named: imageToLoad)
        }
        
    }
}
