//
//  DriverFlickrKit.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import FlickrKit

class DriverFlickrKit: DriverFlickrProtocol {
    
    init() {
        FlickrKit.sharedFlickrKit().initializeWithAPIKey(ManagerGlobalVariable.sharedInstance.apiKey, sharedSecret: ManagerGlobalVariable.sharedInstance.secret)
    }
    
// MARK: -  DriverFlickrProtocol
    
    // Prepare FKFlickrPhotosSearch object from Flickr Kit
    func getFlickrPhotosSearch (tag searchTag: String?, text searchText: String?, long searchLong: String?, lat searchLat: String?, radius searchRadius: String?, page  searchPage: String? ) -> AnyObject {
        
        // Paramets for search
        let search = FKFlickrPhotosSearch()
        
        search.text = searchText
        search.tags = searchTag
        search.lon = searchLong
        search.lat = searchLat
        search.radius = searchRadius
        search.extras = "url_o"
        search.per_page = ManagerGlobalVariable.sharedInstance.per_page
        search.page = searchPage
        
        return search
    }
    
    func getNewPortionURLsFromFlickrServer (search: AnyObject , complition :(response : AnyObject, error : NSError?) -> Void)  {
        
        FlickrKit.sharedFlickrKit().call(search as! FKFlickrPhotosSearch) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            complition (response: response,  error: error)
        })
        }
    }
    

    func getURLSmallPhotoFromFlickrServer (infoPhoto: AnyObject ) -> NSURL {
       return FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: infoPhoto as! [NSObject : AnyObject])
    }
    
    
    
    func getAvaliableSizesPhotoFromFlickrServer (photoId: String , complition :(response : AnyObject, error : NSError?) -> Void) {
        
        let photoSizes = FKFlickrPhotosGetSizes()
        photoSizes.photo_id =  photoId
        
        
        FlickrKit.sharedFlickrKit().call(photoSizes) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 complition (response: response,  error: error)
            })
        }

    }
    
    
    deinit {
        print("Upload  DriverFlickrKit ")
    }
    
}
