//
//  VisitorProtocol.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/15/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

protocol VisitorProtocol {
    func visitNavigationBar (currentNavigationBar : UINavigationBar)
    func visitTabBar (currentTabBar : UITabBar)
    func visitImageSize (inout currentImageView : UIImage, inout reuseIdentifier : String)
}
