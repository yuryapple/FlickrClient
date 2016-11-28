//
//  FCImageView.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/2/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import MBProgressHUD

class FCImageView: UIImageView {
    
    /// URL of photo
    var photoOfURLRequest : NSURLRequest?
    var indexPhoto : Int?
    
    /// Progress indicator
     var activityIndicator: MBProgressHUD? = nil

    
    //
    func loadPhotoInBackground () {
        if self.photoOfURLRequest != nil {
         print("6   loadPhotoInBackground")
         

            if let imageData = CacheOfApplication.sharedInstance.objectForKey(self.indexPhoto!) {
                 imageData.beginContentAccess()
                 self.image = UIImage(data: imageData as! NSData )
                 print("Get from cache \(indexPhoto!)")
                
            } else {
                loadPhotoFromFlickrServer()
            }
        }
    }
    
    private func loadPhotoFromFlickrServer() {
           print("7   loadPhotoFromFlickrServer")
        
        if activityIndicator != nil {
           hideActivityIndicator()
            
        }
        
         showActivityIndicator()
     // Get photo from Flickr server
        NSURLSession.sharedSession().dataTaskWithRequest(self.photoOfURLRequest!) { (data,response, error) -> Void in
            if error == nil  {
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.hideActivityIndicator()
                    self.image = UIImage(data: data!)
                })
                CacheOfApplication.sharedInstance.addPhotoDateToCache(self.indexPhoto!, data: data!)
                print("Load from server \(self.indexPhoto!)")
                
            } else {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.hideActivityIndicator()
                    self.image = UIImage(named: "TroubleDownload.png")
                })

            
            }
            
            
        }.resume()
     }
    
    
    
    
    
    
    /**
    Create and show activity indicator when photos are loading. This used the pod MBProgressHUD.
    */
    private func showActivityIndicator() {
        print("8   showActivityIndicator")

        self.activityIndicator = ManagerGlobalFunction.sharedInstance.showActivityIndicator(view: self)
    }
    
    /**
    Hide activity indicator when photos was loaded. This used the pod MBProgressHUD.
    */
    private func hideActivityIndicator() {
        ManagerGlobalFunction.sharedInstance.hideActivityIndicator(){
            self.activityIndicator!.hideAnimated(false)
            print("Hide")
         
        }
    }

    
}
