//
//  PickerItem.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/21/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import UIKit

class PickerItem: UIView {

    var isVisible: Bool = true
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var visibilityButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    var deleteTaped: Bool = false
    
    
    @IBAction func deleteItem(sender: UIButton) {
        
        self.deleteTaped = true
    }
//    @IBAction func changeVisibility(sender: UIButton) {
//
//        if <#condition#> {
//            <#code#>
//        }
//        
//    }
//    
//    override init(frame: CGRect) { // for using CustomView in code
//        super.init(frame: frame)
//        self.commonInit()
//    }
//    
//
}
