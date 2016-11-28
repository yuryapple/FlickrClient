//
//  CacheOfApplication.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/1/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class CacheOfApplication: NSCache  {
    // Get instance
    static let sharedInstance = CacheOfApplication()
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        super.init()
    }
    
    
    
    
    func addPhotoDateToCache (indexPhoto : Int, data : NSData ) {
        let cacheDada = NSPurgeableData()
        cacheDada.appendData(data)
        CacheOfApplication.sharedInstance.setObject(cacheDada, forKey: indexPhoto)
    }
    
    
    
    /// Pages may be discarded if memory is tight.
    func markPagesAsUselessAboveAndBelowFromCurrentPage (currentPage: Int) {
        
        let lastNumberPageFromAboveRange = (currentPage - ManagerGlobalVariable.sharedInstance.preCachedPages) - 1
        let firstNumberPageFromBelowRange = (currentPage + ManagerGlobalVariable.sharedInstance.preCachedPages) + 1
        
       
        if lastNumberPageFromAboveRange > 0 {
            markPagesAsUselessFromAboveRangeStartTo (lastNumberPageFromAboveRange)
        }
        
        markPagesAsUselessFromBelowRangeStartTo (firstNumberPageFromBelowRange)
    }
    
    
    
    
    private func markPagesAsUselessFromAboveRangeStartTo (page : Int) {
       var numberThisPage = page
        
        while existThisPageInCache(numberThisPage) {
            markThisPageAsUseless(numberThisPage)
            numberThisPage -= 1
        }
        
    }
    

    private func markPagesAsUselessFromBelowRangeStartTo (page : Int) {
        var numberThisPage = page
        
        while existThisPageInCache(numberThisPage) {
            markThisPageAsUseless(numberThisPage)
            numberThisPage += 1
        }
    }
    

    
    private func existThisPageInCache (numberThisPage : Int) -> Bool {
        let range = getFirstAndLastIndexPhotoDataInThisPage(numberThisPage)
        return CacheOfApplication.sharedInstance.objectForKey(range.firstIndexPhotoDataInThisPage) != nil
    }
    
    
    private func markThisPageAsUseless (numberThisPage : Int) {
        let range = getFirstAndLastIndexPhotoDataInThisPage(numberThisPage)
        markAllPhotoDatasInThisPageAsUseless(range.firstIndexPhotoDataInThisPage, ToLastIndex: range.lastIndexPhotoDataInThisPage)
    }
    
    
    
    private func getFirstAndLastIndexPhotoDataInThisPage (numberThisPage : Int) -> (firstIndexPhotoDataInThisPage: Int, lastIndexPhotoDataInThisPage: Int) {
        let itemsInPage = Int(ManagerGlobalVariable.sharedInstance.per_page)
        let lastIndexPhotoDataInThisPage = (numberThisPage * itemsInPage!) - 1
        let firstIndexPhotoDataInThisPage = lastIndexPhotoDataInThisPage - (itemsInPage! - 1)
        return (firstIndexPhotoDataInThisPage, lastIndexPhotoDataInThisPage)
    }

    
    
    private func markAllPhotoDatasInThisPageAsUseless (firstIndexPhotoDataInThisPage: Int, ToLastIndex lastIndexPhotoDataInThisPage : Int) {
        for index in firstIndexPhotoDataInThisPage...lastIndexPhotoDataInThisPage {
            if let photoData  = CacheOfApplication.sharedInstance.objectForKey(index) {
                // Extension NSPurgeableData
                (photoData as! NSPurgeableData).resetAccessCounter()
                print("Index \(index)  was cheked for delete and  \(photoData.isContentDiscarded())" )
            }
        }
    }

    
}