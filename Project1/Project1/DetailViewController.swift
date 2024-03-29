//
//  DetailViewController.swift
//  Project1
//
//  Created by Laurent Delorme on 10/08/2019.
//  Copyright © 2019 Laurent Delorme. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var ImageView: UIImageView!
    var selectedImage: String?
    var pictureIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image \(pictureIndex!)"
        navigationController?.navigationBar.prefersLargeTitles = false

        if let imageToLoad = selectedImage {
            ImageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
