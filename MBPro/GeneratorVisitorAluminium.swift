//
//  GeneratorVisitorKhaki.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 10/15/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

class GeneratorVisitorAluminium: GeneratorVisitorProtocol {
    
    func genetateVisitor () -> VisitorProtocol  {
        return VisitorSkinAluminium()
    }
}
