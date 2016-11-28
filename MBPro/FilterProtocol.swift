//
//  FilterProtocol.swift
//  FlickrClient
//
//  Created by  Yury_apple_mini on 11/27/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

import UIKit

public typealias Filter = UIImage -> CIImage
public typealias CIParameters = Dictionary<String, AnyObject>

protocol FilterProtocol {
    var dictionarySliders : [String : SliderProperty] {get set}
    func applyFilter() -> Filter
}
