//
//  SepiaTone.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/15/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit


class SepiaToneFilter  {

    // Get instance
    static let sharedInstance = SepiaToneFilter()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}

    func applyFilter(image : UIImage ) -> UIImage {
        
        let farray = CIFilter.filterNamesInCategory(kCICategoryGradient)
      
        print("\(farray)")
        
        
        let openGLContext = EAGLContext(API: .OpenGLES2)
        let context = CIContext(EAGLContext: openGLContext!)
        
         let coreImage = getCoreImage(image)
    
         let filter = CIFilter(name: "CISepiaTone")
        
        
      
      
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
      
        
    
        if let output = filter?.valueForKey(kCIOutputImageKey) as? CIImage {
            
                print("\(context.workingColorSpace)")
           
            
                 let filteredImage = context.createCGImage(output, fromRect: coreImage.extent)
            
            
            
            let im = UIImage(CGImage: filteredImage)
            return im
        } else {
            return image
        }
    
    }

        
        
    
    func getCoreImage(image : UIImage) -> CIImage {
        let cgimg = image.CGImage
        return CIImage(CGImage: cgimg!)
    }
    
    
}
    
    
 