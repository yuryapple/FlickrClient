//
//  ViewController.swift
//  MBPro
//
//  Created by  Yury_apple_mini on 9/29/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import MBProgressHUD
import FlickrKit


class SearchViewController: UICollectionViewController , UITextFieldDelegate , UICollectionViewDelegateFlowLayout {
    
// MARK: - Properties
    ///  This array stores URLs of small photo witch were loaded from Flickr.
    private  var photoURLs: [NSURL]! = []
    
    /// This array will be stored total value
    private  var multipleSegment: [String] = []
    
    /// Reuse identifier for CollectionViewCell SearchViewController.
    private let reuseIdentifier = "FlickrCellForSearch"
    
    /// Text for displaying on Search field
    private var searchText = ""
    
    /// How many pages was loaded from Flickr
    private var pageNumber = 1
    
    /// Section insets
    let sectionInsets = UIEdgeInsets(top:2.0, left: 2.0, bottom: 2.0, right: 2.0)
        /// Progress indicator
    private var activityIndicator: MBProgressHUD? = nil
    
    /// Closer for activate Search fild
    var activateSearchFild : (() -> Void)?
    
    /// Closer for deactivate Search fild
    var deactivateSearchFild : (() -> Void)?
    
    /// Reject all request to server until this var is true
    var isLoadingDateFromServer = false
    
    
    
    
        
// MARK: - IB element
    
    /// Element of NavigationBar for indicates how many pages was loaded from Flickr
    @IBOutlet weak var labelForLoadedPages: UILabel!


    @IBAction func showNearbyTab(sender: AnyObject) {
           self.tabBarController?.selectedIndex = 1
    }

    @IBOutlet weak var segmentControl: UISegmentedControl!
   
    
// MARK: - Native functions of UICollectionViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If device was rotated we must reload Collection View
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotateCollectionView", name:
            UIDeviceOrientationDidChangeNotification, object: nil)
        
            detectNumberPerRow()
        
        
           getNewSkin()
        

    }

    
    
    func getNewSkin () {
        let currentNavigationBar = self.navigationController?.navigationBar
        let currentTabBar =  self.tabBarController?.tabBar
        
        currentNavigationBar?.getNewSkin()
        currentTabBar?.getNewSkin()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        detectShowOrHideBottomBar()
    }
    
    
    // If Scroll is at bottom position  load new page of photos
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (!isLoadingDateFromServer) {
            if (scrollView.contentOffset.y + 1 >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                self.pageNumber += 1
                loadUrlPhotos()
            }
        }
    }
    
  // Show or hide navigation Bar
  override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translationInView(scrollView.superview)
        if (actualPosition.y > 0){
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        detectShowOrHideBottomBar()
    }
    
    
    // Show number of current page and number total loaded pages
     override func scrollViewDidScroll(scrollView: UIScrollView) {
         showNumberOfLoadedPages()
    }
    
    
// MARK: - Helper functions
    
    /**
    Clear all variables of search and set text for search
    */
    private func prepareSegmentControlForSearch() {
        multipleSegment.removeAll()
        for _ in 0...(segmentControl.numberOfSegments - 1) {
            multipleSegment.append(String())
        }
        multipleSegment[segmentControl.selectedSegmentIndex] = searchText
    }

   
    
    // Cancel a search requare
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        deactivateSearchFild!()
        self.collectionView?.userInteractionEnabled = true
        self.navigationController?.view.endEditing(true)
    }



    /**
    If  device was rotated, then app needs to recalculete a Collection View Layout
    */
    func rotateCollectionView() {
        // Do nothing if orientation of device is UpSideDown
        if UIDevice.currentDevice().orientation != UIDeviceOrientation.PortraitUpsideDown {
            detectShowOrHideBottomBar()
            detectNumberPerRow()
            self.collectionView?.reloadData()
            showNumberOfLoadedPages()
        }
    }
    
    /**
    Detect how many cells must be photos per Row and set this value for later uses it
    */
    private func detectNumberPerRow() {
        if UIDevice.currentDevice().orientation.isLandscape {
            ManagerGlobalVariable.sharedInstance.itemsPerRow = 5
        } else {
            ManagerGlobalVariable.sharedInstance.itemsPerRow = 3
        }
    }
    
    
    /**
    Detect how bottom Bar is visible on display
    */
    private func detectShowOrHideBottomBar() {
        if UIDevice.currentDevice().orientation.isLandscape {
             self.tabBarController?.tabBar.hidden = true
        } else {
             self.tabBarController?.tabBar.hidden = false
        }
    }
   
    
    /**
    Flickr return error. Show description of this error
    - parameter errorText: Describe the error
    */
    private func showAlertWithError(errorText : String) {
        // Create Alert
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                self.activateSearchFild!()
                self.photoURLs.removeAll()
                self.collectionView?.reloadData()
            })
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
    Indicates on Navigation Bar how many pages was loaded from Flickr
    */
    private func showNumberOfLoadedPages() {
        if self.photoURLs.isEmpty {
            self.labelForLoadedPages.text =  ""
        } else {
            let height = self.collectionView?.frame.size.height
            let currentPage = ((self.collectionView?.contentOffset.y)! + (0.5 * height!)) / height!
            let totalPages = (self.collectionView?.contentSize.height)! / height!
           
            
            // Initial value contentSize is CGSizeZiro
            if  String(Int(round(totalPages))) == "0"  {
                 labelForLoadedPages.text = String(Int(round(currentPage))) + "/1"
            } else {
                labelForLoadedPages.text = String(Int(round(currentPage))) + "/" + String(Int(round(totalPages)))
            }
        }
    }
    
    /**
    Create and show activity indicator when photos are loading. This used the pod MBProgressHUD.
    */
    private func showActivityIndicator() {
        activityIndicator = ManagerGlobalFunction.sharedInstance.showActivityIndicator(view: self.view, isLoading: &isLoadingDateFromServer)
    }
    
    /**
    Hide activity indicator when photos was loaded. This used the pod MBProgressHUD.
    */
    private func hideActivityIndicator() {
        ManagerGlobalFunction.sharedInstance.hideActivityIndicator(){
                self.activityIndicator!.hideAnimated(false)
                self.isLoadingDateFromServer = false
        }
    }
    
    /**
    Load URLs of photos to array. This function used FlickrKit
    */
    func loadUrlPhotos() {
        showActivityIndicator()

        // Prepare for saerch
        let search = ManagerGlobalFunction.sharedInstance.getFlickrPhotosSearch(tag: multipleSegment[0], text: multipleSegment[1], long: nil, lat: nil, radius: nil, page: String(pageNumber))
        
        FlickrKit.sharedFlickrKit().call(search) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (response != nil) {
                    if self.pageNumber == 1 {
                        //  Remove old URL
                        self.photoURLs.removeAll()
                    }
                    // Pull out the photo urls from the results
                    let topPhotos = response["photos"] as! [NSObject: AnyObject]
                    let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
                    
                    for photoDictionary in photoArray {
                        // Get URL of photo
                        let photoURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall240, fromPhotoDictionary: photoDictionary)
                        self.photoURLs.append(photoURL)
                    }
                    // Reload for show new photos
                    self.collectionView?.reloadData()
                    self.hideActivityIndicator()
                    self.showNumberOfLoadedPages()
                } else {
                    //We have some proublem
                    self.hideActivityIndicator()
                    self.showAlertWithError(error.localizedDescription)
                }
            })
        }
     }
    
    
// MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
         textField.textColor = UIColor.blackColor()
        
         // This closer will be used if this request is canseled
            self.deactivateSearchFild = {

            //Recover initial text
            textField.textColor = UIColor.grayColor()
            textField.text = self.searchText
      
            // 
          //  if self.photoURLs.isEmpty {
           //     self.labelForLoadedPages.text =  ""
           // } else {
               self.showNumberOfLoadedPages()
          //  }
        }
        
        // Freez collection view until Search fild is active
        self.collectionView?.userInteractionEnabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Activate  collection view when Search fild is enactive
        self.collectionView?.userInteractionEnabled = true

        self.searchText = textField.text!
        
         prepareSegmentControlForSearch()
        
        // New request so we need set page 1
        self.pageNumber = 1
        // This closer will be used if this request is bad.
        self.activateSearchFild = {textField.becomeFirstResponder()}
        
        textField.textColor = UIColor.grayColor()
        loadUrlPhotos()
        textField.resignFirstResponder()
        return true
    }
    
// MARK: - UICollectionViewDataSource
  override  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
  override  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoURLs.count
    }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
       let urlRequest = NSURLRequest(URL: self.photoURLs[indexPath.row])
    
    
     print (" \(indexPath)");
    
        // Get photo from Flickr server
        NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (data,response, error) -> Void in
            let image = UIImage(data: data!)
        // Show photo on UI element. So we need mainQueue
        NSOperationQueue.mainQueue().addOperationWithBlock({
            cell.imageView.image = image
        })
        }.resume()
    
       return cell
    }
    
// MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
         sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
          
            // Size of photo on CollectionView
            let paddingSpace = sectionInsets.left * (ManagerGlobalVariable.sharedInstance.itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / ManagerGlobalVariable.sharedInstance.itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
// MARK: -  Prepare segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UICollectionViewCell,
            indexPath = collectionView?.indexPathForCell(cell),
            ZViewController = segue.destinationViewController as? ZoomViewController {
               // Get string of URL  from  Array
               let urlString = self.photoURLs[indexPath.row].absoluteString
               ZViewController.urlStringForSmallPhoto = urlString
            }
    }
    
}


