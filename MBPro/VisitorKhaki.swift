//
//  VisitorKhaki.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/15/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class VisitorSkinKhaki: VisitorProtocol {

    let  image = UIImage(named: "Khaki.png")
    
    
    func visitNavigationBar (currentNavigationBar : UINavigationBar) {
        currentNavigationBar.setBackgroundImage(image, forBarMetrics: .Default)
    }
    
    func visitTabBar (currentTabBar : UITabBar) {
        currentTabBar.autoresizesSubviews = false
        currentTabBar.clipsToBounds = true
        currentTabBar.backgroundImage = image
    }
}


