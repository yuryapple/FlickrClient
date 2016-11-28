//
//  FilterViewController.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/22/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    var closerOfPhotoFilter : Filter?
    
    var currentFilterOfPhoto : FilterProtocol?
    
    var rectOfPhoto : CGSize?
    
    var indexPhotoInCache : Int?
    var imageData : AnyObject?
    

    
    
    @IBAction func radiusUp(sender: AnyObject) {
        previewPhotoFilter ()
    }
    
    
    @IBAction func angelUp(sender: UISlider) {
          previewPhotoFilter ()
    }
    
 
    
    
    @IBOutlet weak var radiusLabel: UILabel!

    @IBOutlet weak var angelLabel: UILabel!
    
    
    @IBOutlet weak var imagePreview: UIImageView!
   
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentFilterOfPhoto = Edges
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        imageData = CacheOfApplication.sharedInstance.objectForKey(indexPhotoInCache!)
           
        
        imagePreview.image = UIImage(data: imageData as! NSData )
        
        previewPhotoFilter()
            
        
 //       radiusSlider.minimumValue = Float(rectOfPhoto!.width) / 2
 //       radiusSlider.maximumValue = Float(rectOfPhoto!.width)
  

      
     
   //     currentFilterOfPhoto = applyFilter()
        
  
    }

/*
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                kCIInputIntensityKey: 1,
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CIEdges", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }
    
    

    
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                kCIInputRadiusKey: 10,
                kCIInputCenterKey:  CIVector(x: 50, y: 50),
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CIPointillize", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }
  
    
  
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                kCIInputRadiusKey: self.radiusSlider.value,
                kCIInputCenterKey:  CIVector(x:self.rectOfPhoto!.width / 2, y: self.rectOfPhoto!.height / 2),
                kCIInputAngleKey : self.angelSlider.value,
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CITwirlDistortion", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }

  
    
    func applyFilter() -> Filter {
        
        return { image in
            
            let cgimg = CIImage(CGImage: image.CGImage!)
            
            let parameters : CIParameters = [
                kCIInputRadiusKey: self.radiusSlider.value,
                kCIInputCenterKey:  CIVector(x:self.rectOfPhoto!.width / 2, y: self.rectOfPhoto!.height / 2),
                kCIInputImageKey: cgimg]
            let filter = CIFilter(name:"CICrystallize", withInputParameters:parameters)
            return filter!.outputImage!
        }
    }
    
    
  */
    
    
    
    

    func previewPhotoFilter () {
        
        imagePreview.image = UIImage(data: imageData as! NSData )
        
        let context = CIContext()

        closerOfPhotoFilter = currentFilterOfPhoto!.applyFilter()
        
        let output =  closerOfPhotoFilter!(imagePreview.image!)
        
        let filteredImage = context.createCGImage(output, fromRect: output.extent)
        
        imagePreview.image  = UIImage(CGImage: filteredImage)

        }
    
    
    // MARK: - Prepare for seque
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if segue.identifier == "FilterSettings" {
            print("Array  \(self.childViewControllers)")
        
            let controller = segue.destinationViewController as! ContainerFilterViewController
            controller.currentFilterOfPhoto = currentFilterOfPhoto
        }
    }
    

}