//
//  BuilderGlobalSettings.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/21/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

let BuilderDidSetGlobalValues: String = "BuilderDidSetGlobalValues"

class BuilderGlobalSettings: NSObject  {
    // Get instance
    static let sharedInstance = BuilderGlobalSettings()
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("setGlobalDefaultValue"),
            name: NSUserDefaultsDidChangeNotification,
            object: nil)
        
        self.registerSettingsBundle()
    }
    
    /**
    Set global default value 
    */
    func setGlobalDefaultValue() {
        
        setGlobalValueForCurrentSkin()
        setGlobalValueForCurrentDriverOfFlickrServer()
        NSNotificationCenter.defaultCenter().postNotificationName(BuilderDidSetGlobalValues, object: nil)
    }
    
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
    }
    
    
    
    
    
   private func setGlobalValueForCurrentSkin () {
        //Get the defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Set current skin
        switch (defaults.integerForKey("currentSkin")) {
        case (1):
            ManagerGlobalVariable.sharedInstance.currentSkinVisitor = GeneratorVisitorKhaki().genetateVisitor()
        default:
            ManagerGlobalVariable.sharedInstance.currentSkinVisitor = GeneratorVisitorSky().genetateVisitor()
        }
    }
    
    
   private func setGlobalValueForCurrentDriverOfFlickrServer () {
        //Get the defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //Set current driver for Flickr server
        switch (defaults.integerForKey("currentDriver")) {
        case (1):
            ManagerGlobalVariable.sharedInstance.currentDriverForFlickrServer = DriverFlickrAPI()
        default:
            ManagerGlobalVariable.sharedInstance.currentDriverForFlickrServer = DriverFlickrAPI()
        }
    }
    
    
}


