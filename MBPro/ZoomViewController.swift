//
//  ZoomViewController.swift
//  MBPro
//
//  Created by  Yury_apple_mini on 10/1/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import FlickrKit

struct FlickrSizeAvaliable {
    var label : String!
    var height : String? = "height"
    var width : String? = "width"
    var source : String!
}


class ZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var zoomViewPhoto: ZoomView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelAvaliableSizeOfPhoto: UIBarButtonItem!
    
    @IBAction func getAvaliableSize(sender: AnyObject) {
            showAvaliableSize()
        }
  

    var urlStringForSmallPhoto : String!
    var photoId = ""
    var photoSizesArray : [FlickrSizeAvaliable]! = []
    
    
    override func viewDidLoad() {
       
        // If navigation bar hidden, show it
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.hidden = true
        labelAvaliableSizeOfPhoto.title = "📷 Preview"
        
        zoomViewPhoto.actionForDoubleTap = {self.updateMinZoomScaleForSize(self.view.bounds.size)}
        
        AdapterRequest.sharedInstance.getBigPhotoForZoom(urlStringForSmallPhoto, imageZoom: self.zoomViewPhoto)
        
        getNewSkin()
        
        getAvaliableSizeOfPhoto ()
    }

    
    
    func getAvaliableSizeOfPhoto () {
    
   
    
    
        AdapterRequest.sharedInstance.getAvaliableSizesPhotoFromFlickrServer(photoId) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if  (error == nil)  {
                    // Pull out the photo urls from the results
                    let topSizes = response["sizes"] as! [NSObject: AnyObject]
                    let sizesArray = topSizes["size"] as! [[NSObject: AnyObject]]
                    
                    for photoSizeDictionary in sizesArray {
                        
                        
                        var photoSize = FlickrSizeAvaliable()
                        
                        photoSize.label =  photoSizeDictionary["label"]! as? String
                        
                       
                        if ((photoSizeDictionary["height"] as? String) != nil)   {
                           photoSize.height = photoSizeDictionary["height"] as? String
                        }
                        
                        if ((photoSizeDictionary["width"] as? String) != nil)  {
                            photoSize.width = photoSizeDictionary["width"] as? String
                        }
                        
                        photoSize.source =  photoSizeDictionary["source"]! as? String
                        
                        self.photoSizesArray.append(photoSize)
                    
                    }
                }
            })
        }
    }

    
    

    
    func showAvaliableSize () {
    
    //Create the AlertController and add Its action like button in Actionsheet
    let actionSheetController: UIAlertController = UIAlertController(title: "Select", message: "avaliable size", preferredStyle: .ActionSheet)

      let startIndex = photoSizesArray.indexOf{$0.label == "Medium"}
        
        
        for index in startIndex! ... photoSizesArray.count - 1 {
            if ((photoSizesArray[index].height) != nil) {
             let titleButtob = photoSizesArray[index].label + " " + (photoSizesArray[index].height)! + "×" + (photoSizesArray[index].width)!
        
             let actionButton: UIAlertAction = UIAlertAction(title: titleButtob, style: .Default)
                 { action -> Void in
                    print("\(self.photoSizesArray[index].source)")
                    AdapterRequest.sharedInstance.getBigPhotoForZoom(self.photoSizesArray[index].source, imageZoom: self.zoomViewPhoto)
                    self.labelAvaliableSizeOfPhoto.title = "📷 " + self.photoSizesArray[index].label
             }
             actionSheetController.addAction(actionButton)
            }
        }
        
    self.presentViewController(actionSheetController, animated: true, completion: nil)
    
    }
    
    
    
    
    
    
    
    func getNewSkin () {
        let currentNavigationBar = self.navigationController?.navigationBar
        currentNavigationBar?.getNewSkin()
    }
    
    
  
    
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / zoomViewPhoto.bounds.width
        let heightScale = size.height / zoomViewPhoto.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        
        let yOffset = max(0, (size.height - zoomViewPhoto.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - zoomViewPhoto.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }

    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
       
        return zoomViewPhoto
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)  
    }
    
    
    
    
    
}