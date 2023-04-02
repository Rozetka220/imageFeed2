//
//  SingleImageViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 01.04.2023.
//

import UIKit

final class SingleImageViewController : UIViewController {
    
    var image: UIImage!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
