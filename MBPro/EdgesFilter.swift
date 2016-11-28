//
//  Edges.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/21/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//



import UIKit



class EdgesFilter : FilterProtocol  {
    
    // Get instance
    static let sharedInstance = EdgesFilter()
    
    var dictionarySliders : [String : SliderProperty]
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        let sliderRadius = SliderProperty(minimumValue: 0, maximumValue: 0.5, curruntValue : 2,  thumbImage: "Raduis")
        dictionarySliders = ["InputIntensity" : sliderRadius]
    }
    
    
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                
                kCIInputIntensityKey: self.dictionarySliders["InputIntensity"]!.curruntValue,
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CIEdges", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }
    
    
}
