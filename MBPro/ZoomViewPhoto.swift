//
//  ZoomViewPhoto.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/8/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//


import UIKit

class ZoomView: UIImageView {

    /// Closer for normal size
    var actionForDoubleTap : (() -> Void)?
    
    
    // Return foto to normal size
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let t = touches.first
        if (t?.tapCount == 2 ){
            actionForDoubleTap!()
        }
    }
}