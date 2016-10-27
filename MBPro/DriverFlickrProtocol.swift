//
//  DriverFlickrProtocol.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

protocol DriverFlickrProtocol {
    func getFlickrPhotosSearch (tag searchTag: String?, text searchText: String?, long searchLong: String?, lat searchLat: String?, radius searchRadius: String?, page  searchPage: String? ) -> AnyObject
    
    func getNewPortionURLsFromFlickrServer (search: AnyObject , complition :(response : AnyObject, error : NSError?) -> Void)
    
    func getURLSmallPhotoFromFlickrServer (infoPhoto: AnyObject ) -> NSURL
    
    func getAvaliableSizesPhotoFromFlickrServer (photoId: String , complition :(response : AnyObject, error : NSError?) -> Void)
    

    
}
