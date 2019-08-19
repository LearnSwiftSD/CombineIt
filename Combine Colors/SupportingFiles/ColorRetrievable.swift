//
//  ColorRetrievable.swift
//  Combine Colors
//
//  Created by Stephen Martinez on 8/17/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

protocol ColorRetrievable: AnyObject {
    
    func didSave(color: FavColor)
    
    func didEdit(color: FavColor)
    
    func didDelete(color: FavColor)
    
}
