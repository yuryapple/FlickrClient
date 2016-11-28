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


struct FlickrPhotoInfo {
    var photoURL : NSURL!
    var photoID: String!
    var farm : Int!
    var server : String!
    var secret : String!
    var avaliableOriginalSize : Bool!
}



class SearchViewController: UICollectionViewController , UITextFieldDelegate , UICollectionViewDelegateFlowLayout {
    
// MARK: - Properties
    ///  This array stores URLs of small photo witch were loaded from Flickr.
    private  var PhotoInfoArray: [FlickrPhotoInfo]! = []
    
    ///  This array stores URLs of small photo witch were loaded from Flickr.
    //private  var photoIDs: [String]! = []
    
    
    /// This array will be stored total value
    private  var multipleSegment: [String] = []
    
    /// Reuse identifier for CollectionViewCell SearchViewController.
   // private let reuseIdentifier = "FlickrCellForSearch"
    
    /// Text for displaying on Search field
    private var searchText = ""
    
    /// How many pages was loaded from Flickr
    private var pageNumber = 1

    /// How many pages was loaded from Flickr
    private var currentNumberPage = 1
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "getNewSkin",
            name: BuilderDidSetGlobalValues,
            object: nil)
    }

    
    
    func getNewSkin () {
        
        let currentNavigationBar = self.navigationController?.navigationBar
        let currentTabBar =  self.tabBarController?.tabBar
        
        currentNavigationBar?.getNewSkin()
        currentTabBar?.getNewSkin()
        PhotoCell.getNewSkin()
            
        self.collectionView?.reloadData()
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
                self.PhotoInfoArray.removeAll()
             //   self.photoIDs.removeAll()
                self.collectionView?.reloadData()
            })
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
    Indicates on Navigation Bar how many pages was loaded from Flickr
    */
    private func showNumberOfLoadedPages() {
        if self.PhotoInfoArray.isEmpty {
            self.labelForLoadedPages.text =  ""
        } else {
            let height = self.collectionView?.frame.size.height
            let numberCurrentPageForShow = ((self.collectionView?.contentOffset.y)! + (0.5 * height!)) / height!
            let totalPages = (self.collectionView?.contentSize.height)! / height!
           
            
            // Initial value contentSize is CGSizeZiro
            if  String(Int(round(totalPages))) == "0"  {
                 labelForLoadedPages.text = String(Int(round(numberCurrentPageForShow))) + "/1"
            } else {
                labelForLoadedPages.text = String(Int(round(numberCurrentPageForShow))) + "/" + String(Int(round(totalPages)))
            }
            
            markPagesAsUselessInCache(Int(round(numberCurrentPageForShow)))
        }
    }
    
    
    private func markPagesAsUselessInCache (numberCurrentPageForShow : Int) {
        if currentNumberPage != numberCurrentPageForShow {
            currentNumberPage = numberCurrentPageForShow
            CacheOfApplication.sharedInstance.markPagesAsUselessAboveAndBelowFromCurrentPage(currentNumberPage)
        }
    }
    
    
    /**
    Create and show activity indicator when photos are loading. This used the pod MBProgressHUD.
    */
    private func showActivityIndicator() {
//        activityIndicator = ManagerGlobalFunction.sharedInstance.showActivityIndicator(view: self.view, isLoading: &isLoadingDateFromServer)
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
       // showActivityIndicator()

        // Prepare for saerch
        let search = AdapterRequest.sharedInstance.getFlickrPhotosSearch(tag: multipleSegment[0], text: multipleSegment[1], long: nil, lat: nil, radius: nil, page: String(pageNumber))
        
        AdapterRequest.sharedInstance.getNewPortionURLsFromFlickrServer(search) {(response, error) -> Void in
     //     dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let er = error {
                    self.showError (er)
                } else {
                    self.fillPhotoInfoArray(response)
                }
          //  })
        }
     }
    
    
    
    func showError (error: NSError) {
        //We have some proublem
        self.hideActivityIndicator()
        self.showAlertWithError(error.localizedDescription)
    }
    
    
    
    func prepareBeforeLoadingFirstPage () {
      self.pageNumber = 1
      self.collectionView!.performBatchUpdates({
            //  Remove old URL
            self.PhotoInfoArray.removeAll()
            self.collectionView?.reloadSections(NSIndexSet(index: 0))
            print("reload")
            CacheOfApplication.sharedInstance.removeAllObjects()
            print("complition")
        }, completion: nil)

    }
    
    
    
    func fillPhotoInfoArray (response: AnyObject) {
            if self.pageNumber == 1 {
           //     prepareBeforeLoadingFirstPage ()
            }
        
    
            // Pull out the photo urls from the results
            let topPhotos = response["photos"] as! [NSObject: AnyObject]
            let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
            
            for photoDictionary in photoArray {
                // Get URL of photo
                var photoInf = FlickrPhotoInfo()
                
                photoInf.photoURL = AdapterRequest.sharedInstance.getURLSmallPhotoFromFlickrServer(photoDictionary)
                photoInf.photoID = String(photoDictionary["id"]!)
                photoInf.farm = photoDictionary["farm"] as! Int
                photoInf.server = String(photoDictionary["server"]!)
                photoInf.secret = String(photoDictionary["secret"]!)
                photoInf.avaliableOriginalSize = (photoDictionary["url_o"]) != nil
     
                PhotoInfoArray.append(photoInf)
                uppdatesItem (self.PhotoInfoArray.count-1)
            }
                // Reload for show new photos
             //   self.collectionView?.reloadData()
             //   self.hideActivityIndicator()
                self.showNumberOfLoadedPages()
    }
    
    
    func uppdatesItem (itemIndex : Int) {
        
     //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        
            
            print("1   Item -   \( itemIndex)")
            print("2   Items in sect -   \( self.collectionView?.numberOfItemsInSection(0))")
        
        
        self.collectionView!.performBatchUpdates({
            let indexPathArray : [NSIndexPath] = [NSIndexPath(forItem: itemIndex, inSection: 0)]
            self.collectionView?.insertItemsAtIndexPaths(indexPathArray)
                }, completion: nil)
        
            
            
         //   dispatch_async(dispatch_get_main_queue(), { () -> Void in
             //   self.collectionView!.performBatchUpdates({
                    
                 //   self.collectionView?.reloadItemsAtIndexPaths(indexPathArray)
            
            
                    
 
              //      }, completion: { (finished) -> Void in
               //         if finished {
                //            print("Update")
                //        } else {
                 //           print("Not update")
                  //      }
              //  })
         //   })
            
    //    })

    
    
    }
    
    
// MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
         textField.textColor = UIColor.blackColor()
        
         // This closer will be used if this request is canseled
            self.deactivateSearchFild = {

            //Recover initial text
            textField.textColor = UIColor.grayColor()
            textField.text = self.searchText
                
            self.showNumberOfLoadedPages()
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
        
        // New request so we need set page 1 and clear arrays
        prepareBeforeLoadingFirstPage()
        
        
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
    
        print("3   number Of Items In Section \(PhotoInfoArray.count)")
    
        return self.PhotoInfoArray.count
    }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
       let urlRequest = NSURLRequest(URL: self.PhotoInfoArray[indexPath.row].photoURL)
       let avaliableOriginalSize  =  self.PhotoInfoArray[indexPath.row].avaliableOriginalSize
    
       print("4   Load")
    
       AdapterRequest.sharedInstance.prepareAndShowCell(urlRequest, cell: cell, indexPhoto: indexPath.row, avaliableOriginSize: avaliableOriginalSize)

    
    
    
    print("9   return cell")
    print(" ")
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
               let urlString = self.PhotoInfoArray[indexPath.row].photoURL.absoluteString
               print (" \(urlString)")
                
                let  photoI = self.PhotoInfoArray[indexPath.row].photoID
     
                
               ZViewController.urlStringForSmallPhoto = urlString

               ZViewController.photoId = String(photoI)
               ZViewController.indexSelectCell = indexPath.row
            }
    }
    
}


