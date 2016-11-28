//
//  OpTile.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/16/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

struct SliderProperty {
    var minimumValue : Float!
    var maximumValue : Float!
    var curruntValue : Float!
    var thumbImage : String?
}



class CrystallizeFilter : FilterProtocol  {
    
    // Get instance
    static let sharedInstance = CrystallizeFilter()

    var dictionarySliders : [String : SliderProperty]
    
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        let sliderRadius = SliderProperty(minimumValue: 1, maximumValue: 10, curruntValue : 5,  thumbImage: "Raduis")
        dictionarySliders = ["InputRadius" : sliderRadius]
    }
    
   
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                kCIInputRadiusKey: self.dictionarySliders["InputRadius"]!.curruntValue,
                kCIInputCenterKey:  CIVector(x: image.size.width / 2, y: image.size.height / 2),
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CICrystallize", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }
    
    
}
