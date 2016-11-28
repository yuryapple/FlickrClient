//
//  CommonRequest.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//


import UIKit
import FlickrKit

class AdapterRequest: DriverFlickrProtocol {
    // Get instance
    static let sharedInstance = AdapterRequest()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    var currentDriverForFlickr = ManagerGlobalVariable.sharedInstance.currentDriverForFlickrServer

    
    func prepareAndShowCell(urlRequest: NSURLRequest,  cell: PhotoCell, indexPhoto : Int, avaliableOriginSize : Bool) {
       
      //  cell.showAvaliableOriginLabel(avaliableOriginSize)
        
       // self.performSelectorOnMainThread(Selector(showAvaliableOriginLabel(cell)), withObject: self, waitUntilDone: true)
                print("5   prepareAndShowCell")
                cell.viewWithTag(100)?.hidden = !avaliableOriginSize
      
        
        
        
            let photoView = cell.imageView as! FCImageView
        
            photoView.image =  UIImage(named: "PlaceHolder.png")
            photoView.photoOfURLRequest = urlRequest
            photoView.indexPhoto = indexPhoto
            photoView.loadPhotoInBackground()
    }
    
    

    
    
    
    
    func getBigPhotoForZoom(urlStringForSelectedPhoto : String, imageZoom: ZoomView) {
        let urlRequest = getUrlRequestForSelectedPhoto(urlStringForSelectedPhoto)
        // Get photo from Flickr server
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data,response, error) -> Void in
            let image = UIImage(data: data!)
            
            // Show photo on UI element. So we need mainQueue
            NSOperationQueue.mainQueue().addOperationWithBlock({
                imageZoom.image = image
            })
            }.resume()
    }
    
    
    private func getUrlRequestForSelectedPhoto (urlStringForSelectedPhoto : String) -> NSURLRequest {
        let urlForSelectedPhoto = NSURL(string: urlStringForSelectedPhoto)
        let urlRequestForSelectedPhoto =  NSURLRequest(URL: urlForSelectedPhoto!)
        return urlRequestForSelectedPhoto
        
    }
    
    
// MARK: -  DriverFlickrProtocol
    
    // Prepare FKFlickrPhotosSearch object from Flickr Kit
    func getFlickrPhotosSearch (tag searchTag: String?, text searchText: String?, long searchLong: String?, lat searchLat: String?, radius searchRadius: String?, page  searchPage: String? ) -> AnyObject {
       let search =  currentDriverForFlickr.getFlickrPhotosSearch (tag: searchTag, text: searchText, long: searchLong, lat: searchLat, radius: searchRadius, page:  searchPage)
       return search
    }


    func getNewPortionURLsFromFlickrServer (search: AnyObject , complition :(response : AnyObject, error : NSError?) -> Void) {
        currentDriverForFlickr.getNewPortionURLsFromFlickrServer(search, complition: complition)
    }
    
    
   func getURLSmallPhotoFromFlickrServer (infoPhoto: AnyObject ) -> NSURL {
        return  currentDriverForFlickr.getURLSmallPhotoFromFlickrServer(infoPhoto)
    }
    
    
    func getAvaliableSizesPhotoFromFlickrServer (photoId: String , complition :(response : AnyObject, error : NSError?) -> Void) {
        currentDriverForFlickr.getAvaliableSizesPhotoFromFlickrServer(photoId, complition: complition)
    }

    
}