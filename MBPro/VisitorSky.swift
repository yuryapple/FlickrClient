//
//  VisitorSky.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/15/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class VisitorSkinSky: VisitorProtocol {

    /// Reuse identifier for CollectionViewCell SearchViewController.
    private let reuseIdentifierCell = "FlickrCellForSearchAluminium"
    
   private  let  image = UIImage(named: "Aluminium.png")
   private  let  imageSize = UIImage(named: "OriginalSizeAluminium.png")
    
    
    func visitNavigationBar (currentNavigationBar : UINavigationBar) {
        currentNavigationBar.setBackgroundImage(image, forBarMetrics: .Default)
    }
    
    func visitTabBar (currentTabBar : UITabBar) {
        currentTabBar.autoresizesSubviews = false
        currentTabBar.clipsToBounds = true
        currentTabBar.backgroundImage = image
    }
    
    func visitImageSize (inout currentImageView : UIImage , inout reuseIdentifier : String) {
        currentImageView = imageSize!
        reuseIdentifier = reuseIdentifierCell
    }
    
    
}
