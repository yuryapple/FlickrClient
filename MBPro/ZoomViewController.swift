//
//  ZoomViewController.swift
//  MBPro
//
//  Created by  Yury_apple_mini on 10/1/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class ZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var zoomViewPhoto: ZoomView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
  
  

    var urlStringForSmallPhoto : String!

    
    override func viewDidLoad() {
        // If navigation bar hidden, show it
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.hidden = true
        
        zoomViewPhoto.actionForDoubleTap = {self.updateMinZoomScaleForSize(self.view.bounds.size)}
        
        let urlRequest = getUrlRequestForBigPhoto()
        
        // Get photo from Flickr server
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data,response, error) -> Void in
            let image = UIImage(data: data!)
            // Show photo on UI element. So we need mainQueue
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.zoomViewPhoto.image = image
            })
            }.resume()
    }

    
    private func getUrlRequestForBigPhoto () -> NSURLRequest {
     let urlStringForBigPhoto = urlStringForSmallPhoto.stringByReplacingOccurrencesOfString("_m.", withString: "_b.")
     let urlForBigPhoto = NSURL(string: urlStringForBigPhoto)
     let urlRequestForBigPhoto =  NSURLRequest(URL: urlForBigPhoto!)
     return urlRequestForBigPhoto
        
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