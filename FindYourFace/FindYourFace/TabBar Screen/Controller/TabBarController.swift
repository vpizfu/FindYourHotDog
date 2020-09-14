//
//  TabBarController.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedVC = FeedViewController()
        let mapVC = MapViewController()
        let profileVC = ProfileViewController()
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.modalPresentationStyle = .fullScreen
        profileVC.title = "Profile"
        
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "feed"), selectedImage: UIImage(named: "feedFilled"))
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "map"), selectedImage: UIImage(named: "mapFilled"))
        profileNC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "cat"), selectedImage: UIImage(named: "catFilled"))
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lato", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Lato-Black", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        let controllers = [feedVC, mapVC, profileNC]
        self.viewControllers = controllers
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
