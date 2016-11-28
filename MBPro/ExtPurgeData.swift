//
//  ExtPurgeData.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/4/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

extension NSPurgeableData {
    func resetAccessCounter () {
        while getAccessCounter() == 0 {
            self.endContentAccess()
        }
    }
    
    private func getAccessCounter () -> Int {
        return self.valueForKey("_accessCount") as! Int
    }
    
}