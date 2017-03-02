//
//  CustomTabBar.swift
//  PeerToPeer
//
//  Created by Dominik Sadowski on 3/1/17.
//  Copyright © 2017 Dominik Sadowski. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chat = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        let firstTab = UINavigationController(rootViewController: chat)
        firstTab.title = "Chat"
        
        let fileSharing = FileSharing(collectionViewLayout: UICollectionViewFlowLayout())
        let secondTab = UINavigationController(rootViewController: fileSharing)
        secondTab.title = "File Sharing"
        
        let myConnections = MyConnections(collectionViewLayout: UICollectionViewFlowLayout())
        let thirdTab = UINavigationController(rootViewController: myConnections)
        thirdTab.title = "My Connections"
        
        self.viewControllers = [thirdTab, firstTab, secondTab]
        
        tabBar.isTranslucent = false
    }
}
