//
//  TabBarController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 13.06.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController =  storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active.png"), selectedImage: nil)
        
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
