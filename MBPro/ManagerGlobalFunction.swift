//
//  ManagerGlobalFunction.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/8/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit
import MBProgressHUD


// Singelton
class ManagerGlobalFunction {
  
    // Get instance
    static let sharedInstance = ManagerGlobalFunction()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
  //  func showActivityIndicator(view view: UIView, inout isLoading: Bool,  text: String = "Loading" ) -> MBProgressHUD {
    func showActivityIndicator(view view: UIView, text: String = "Loading" ) -> MBProgressHUD {

    
        let activityIndicator = MBProgressHUD.showHUDAddedTo(view, animated: true)
        activityIndicator.mode = MBProgressHUDMode.Indeterminate
        activityIndicator.label.text = text
        return activityIndicator
    }

   func hideActivityIndicator(handler: () -> Void) {
       // dispatch_after(0, dispatch_get_main_queue(), handler)
      handler()
    }
    
}