//
//  ManagerGlobalValue.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/4/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

// Singelton
class ManagerGlobalVariable {
    // Get instance 
    static let sharedInstance = ManagerGlobalVariable()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}

    ///Global variable
    /// How many rows on CollectionView
    var itemsPerRow: CGFloat = 3
    /// How many photos wil be download per request. read-only competed property
    var per_page: String {
        return String(itemsPerRow * 5)
    }
    
}