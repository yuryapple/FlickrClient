//
//  NearbyViewController.swift
//  MBPro
//
//  Created by  Yury_apple_mini on 10/2/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import MBProgressHUD
import FlickrKit
import CoreLocation


class NearbyViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate   {
    
    // MARK: - Properties
    ///  This array stores URLs of small photo witch were loaded from Flickr.
    private var photoURLs: [NSURL]! = []
    
    /// Reuse identifier for CollectionViewCell NearbyViewController.
    private let reuseIdentifier = "FlickrCellForNearby"
    
    private var pageNumber = 1
    
    /// Section insets
    private let sectionInsets = UIEdgeInsets(top:2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    /// Progress indicator
    var activityIndicator: MBProgressHUD? = nil
    
    /// Instance of CLLocationManager
    private let locationManager = CLLocationManager()
    
    /// Current longitude
    private var long = ""
    
    /// Current latitude
    private var lat = ""
    
// MARK: - IB elements
    /// Element of NavigationBar for indicates how many kilometers around
    @IBOutlet var nearbyKilometer: UIBarButtonItem!

    /// Show new value of radius, if slider is moving
    @IBAction func showNearbyKilometers(sender: UISlider) {
        nearbyKilometer.title = String(Int(sender.value)) + "km"
    }
  
    /// If slider get a final value then show photo nearby km
    @IBAction func showNearbyPhotos(sender: UISlider) {
        self.pageNumber = 1
        loadUrlPhotos()
    }
    
    @IBAction func showSearchTab(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
// MARK: - Native functions of UICollectionViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial value
        nearbyKilometer.title = "1km"
        
        // Presets for instance location manager
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 300
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        getNewSkin()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Resume detecting current coordinate is view is visible
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Stop detecting current coordinate if view not visible
        locationManager.stopUpdatingLocation()
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 1 >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            self.pageNumber += 1
            loadUrlPhotos()
        }
        
    }
    
    
// MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations[0]
        lat = String(format: "%f", currentLocation.coordinate.latitude)
        long = String(format: "%f", currentLocation.coordinate.longitude)
        self.pageNumber = 1
        loadUrlPhotos()
    }
    
    


// MARK: - Helper functions
    
    func getNewSkin () {
        let currentNavigationBar = self.navigationController?.navigationBar
        currentNavigationBar?.getNewSkin()
    }
    
    
    /**
    Indicates on Navigation Bar how many pages was loaded from Flickr
    */
    private func showNumberOfLoadedPages() {
        
        // loadedNumberPages.title = String(self.pageNumber)
    }
    
    
    /**
    Create and show activity indicator when photos are loading. This used the pod MBProgressHUD.
    */
    private func showActivityIndicator() {
        activityIndicator = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        activityIndicator!.mode = MBProgressHUDMode.Indeterminate
        activityIndicator!.label.text = "Loading"
    }
    
    /**
    Hide activity indicator when photos was loaded. This used the pod MBProgressHUD.
    */
    private func hideActivityIndicator() {
        activityIndicator?.hideAnimated(false, afterDelay: 1)
    }
    
    /**
    Load URLs of photos to array. This function used FlickrKit
    */
    func loadUrlPhotos() {
        // Prepare for saerch
        let search = AdapterRequest.sharedInstance.getFlickrPhotosSearch( tag: nil, text: nil, long: long, lat: lat, radius: nearbyKilometer.title, page: String(pageNumber))
        
        FlickrKit.sharedFlickrKit().call(search as! FKFlickrPhotosSearch) { (response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (response != nil) {
                    self.showActivityIndicator()
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
                }
            })
        }
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
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
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
                let urlString = self.photoURLs[indexPath.row].absoluteString
                ZViewController.urlStringForSmallPhoto = urlString
        }
    }

    
}