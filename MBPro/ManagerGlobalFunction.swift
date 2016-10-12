//
//  ManagerGlobalFunction.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/8/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import FlickrKit
import MBProgressHUD


// Singelton
class ManagerGlobalFunction {
  
    // Get instance
    static let sharedInstance = ManagerGlobalFunction()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    // Prepare FKFlickrPhotosSearch object from Flickr Kit
    func getFlickrPhotosSearch (tag searchTag: String?, text searchText: String?, long searchLong: String?, lat searchLat: String?, radius searchRadius: String?, page  searchPage: String? ) -> FKFlickrPhotosSearch {
    
        // Paramets for search
        let search = FKFlickrPhotosSearch()
        
        search.text = searchText
        search.tags = searchTag
        search.lon = searchLong
        search.lat = searchLat
        search.radius = searchRadius
        search.per_page = ManagerGlobalVariable.sharedInstance.per_page
        search.page = searchPage
        
        return search
    }
    
    
     func showActivityIndicator(view view: UIView, inout isLoading: Bool,  text: String = "Loading" ) -> MBProgressHUD {
        let activityIndicator = MBProgressHUD.showHUDAddedTo(view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate
        activityIndicator.label.text = text
        isLoading = true
        
        return activityIndicator
    }

   func hideActivityIndicator(handler: () -> Void) {
        dispatch_after(1, dispatch_get_main_queue(), handler)
    }
    
}