//
//  CircleSplashDistortion.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//






import UIKit


class CircleSplashDistortionFilter  {
    
    // Get instance
    static let sharedInstance = CircleSplashDistortionFilter()
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    func applyFilter(image : UIImage ) -> UIImage {
        
        let farray = CIFilter.filterNamesInCategory(kCICategoryGradient)
        
        print("\(farray)")
        
        
        let openGLContext = EAGLContext(API: .OpenGLES2)
        let context = CIContext(EAGLContext: openGLContext!)
        
        
        let coreImage = getCoreImage(image)
        
        let filter = CIFilter(name: "CICircleSplashDistortion")
        
        
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        
        
        if let output = filter?.valueForKey(kCIOutputImageKey) as? CIImage {
             let filteredImage = context.createCGImage(output, fromRect: coreImage.extent)
            
            let f = UIImage(CGImage: filteredImage)
            
            return f
        } else {
            return image
        }
        
    }
    
    
    
    
    func getCoreImage(image : UIImage) -> CIImage {
        let cgimg = image.CGImage
        return CIImage(CGImage: cgimg!)
    }
    
    
}


 