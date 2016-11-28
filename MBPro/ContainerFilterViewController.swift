//
//  ContainerFilterViewController.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/26/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class ContainerFilterViewController: UIViewController {
    
    var currentFilterOfPhoto : FilterProtocol!

    
  //  var dictionarySliders : [String : SliderProperty]?
    

    @IBAction func applyValueOfSlider(sender: UISlider) {
        
        currentFilterOfPhoto.dictionarySliders[sender.accessibilityIdentifier!]!.curruntValue = sender.value

       //  print("Update  \(dictionarySliders)")
        

        let parentControllerForContainerController = self.parentViewController as! FilterViewController
        parentControllerForContainerController.previewPhotoFilter()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Current \(self)")
        
        
        
        addSliders(currentFilterOfPhoto.dictionarySliders)
   
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addSliders (dictionarySl: [String: SliderProperty]) {
        
        var yStart : CGFloat = 10.0
        
        let hightSlider : CGFloat = 20.0
        let  spaceBetweenSliders: CGFloat = 20.0
        
        for (sliderIdentifire, slider) in dictionarySl {
            
            print("\(slider)")
            
            let frame = CGRectMake(0.0,  yStart ,  300.0, yStart + hightSlider)
            let sl = UISlider.init(frame: frame)
            sl.addTarget(self, action:"applyValueOfSlider:", forControlEvents: UIControlEvents.TouchUpInside)
            sl.minimumValue = slider.minimumValue
            sl.maximumValue = slider.maximumValue
            sl.value = slider.curruntValue
            sl.accessibilityIdentifier = sliderIdentifire
     
            if let thumbImage = slider.thumbImage {
                sl.setThumbImage(UIImage(named: thumbImage), forState: .Normal)
            }
            
            view.addSubview(sl)
            yStart = yStart + hightSlider + spaceBetweenSliders
        }
    }
    
    
    deinit {
        print ("Delete \(self)")
    }
    
}

