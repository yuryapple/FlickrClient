//
//  DriverFlickrAPI.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class DriverFlickrAPI: DriverFlickrProtocol {
    let apiKey = "348ea26ca45d5f9d3da7fff4822a7fd1";

    
    private func escapedParam (currentParam : String) ->String {
        return  currentParam.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    private func getURLRequestForAvaliableSizesOfPhoto (photoId : String)  -> NSURLRequest {
        
        var URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=\(apiKey)"
        
        URLString += "&photo_id=" + photoId
        
        URLString += "&format=json&nojsoncallback=1"
        
        let url = NSURL(string: URLString)!
        return NSURLRequest(URL: url)
    }
    
    private func parseDataJSON (data : NSData) -> NSDictionary {
        
        var resultsDictionary = NSDictionary()
        
        do {
            resultsDictionary = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
        } catch let JSONError as NSError {
            print(JSONError)
        }

        return resultsDictionary
    }
    
    
 // MARK: -  DriverFlickrProtocol
    
    func getFlickrPhotosSearch (tag searchTag: String?, text searchText: String?, long searchLong: String?, lat searchLat: String?, radius searchRadius: String?, page  searchPage: String? ) -> AnyObject {
        
        var URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)"
    
        
        if (searchTag != "") {
            URLString += "&tags=" + escapedParam(searchTag!)
        }
        
        
        if (searchText != "") {
            URLString += "&text=" + escapedParam(searchText!)
        }
        
        if (searchLong != nil) {
            URLString += "&lon=" + escapedParam(searchLong!)
        }

        if (searchLat != nil) {
            URLString += "&lat=" + escapedParam(searchLat!)
        }
        
        if (searchRadius != nil) {
            URLString += "&radius=" + escapedParam(searchRadius!)
        }
        
        URLString += "&extras=" + escapedParam("url_o")
        
        URLString += "&per_page=" + ManagerGlobalVariable.sharedInstance.per_page
        
        if (searchPage != nil) {
            URLString += "&page=" + escapedParam(searchPage!)
        }
        
        URLString += "&format=json&nojsoncallback=1"
        
        return NSURL(string: URLString)!
    }
    


    
    func getNewPortionURLsFromFlickrServer (search: AnyObject , complition :(response : AnyObject, error : NSError?) ->Void) {
        let searchRequest = NSURLRequest(URL: search as! NSURL)
        
        NSURLSession.sharedSession().dataTaskWithRequest(searchRequest) { (data,response, error) -> Void in
     
            let resultsDictionary = self.parseDataJSON(data!)


            NSOperationQueue.mainQueue().addOperationWithBlock({
             complition (response: resultsDictionary,  error: error)
            })
            }.resume()
    }
    
    
    func getURLSmallPhotoFromFlickrServer (infoPhoto: AnyObject) -> NSURL {
        
        let info = infoPhoto as! NSDictionary
        
        var URLString = "https://farm"
        
        URLString +=  String(info["farm"]!)  + ".staticflickr.com/" +  String(info["server"]!) + "/" + String(info["id"]!) + "_" + String(info["secret"]!) + "_m.jpg"
        
         return NSURL(string: URLString)!
        
        
    }

    
    func getAvaliableSizesPhotoFromFlickrServer (photoId: String , complition :(response : AnyObject, error : NSError?) -> Void) {
        
        let searchRequest = getURLRequestForAvaliableSizesOfPhoto(photoId)
        
        NSURLSession.sharedSession().dataTaskWithRequest(searchRequest) { (data,response, error) -> Void in
            
            let resultsDictionary = self.parseDataJSON(data!)
    
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                complition (response: resultsDictionary,  error: error)
            })
            }.resume()

    }
    

    
}