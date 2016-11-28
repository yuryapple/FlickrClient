//
//  PhotoCell.swift
//  
//
//  Created by  Yury_apple_mini on 9/30/16.
//
//

import UIKit

class PhotoCell: UICollectionViewCell {
    // Get imageSise
    static var imageOfSize =  UIImage()
    static var reuseIdentifier =  String()
    
    class func getNewSkin() {
        let currentSkinVisitor =  ManagerGlobalVariable.sharedInstance.currentSkinVisitor
        currentSkinVisitor.visitImageSize(&imageOfSize, reuseIdentifier: &reuseIdentifier)
    }

     required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
      let imageV = self.viewWithTag(100) as! UIImageView
      imageV.image =  PhotoCell.imageOfSize
    }
    
  
    
    
/*
    func showAvaliableOriginLabel(avaliableOriginSize : Bool) {
       self.performSelectorOnMainThread(Selector(show(avaliableOriginSize)), withObject: self, waitUntilDone: false)

    }
    
    func show(avaliableOriginSize : Bool) {
        print("5   prepareAndShowCell")
        self.viewWithTag(100)?.hidden = !avaliableOriginSize
    }
 */
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageSize: UIImageView!


    
}
