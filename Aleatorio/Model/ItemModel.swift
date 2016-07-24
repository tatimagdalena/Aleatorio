//
//  ItemModel.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/24/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import UIKit

class ItemModel: NSObject {

    var name: String!
    var isHidden: Bool!

    override init() {
        super.init()
    }
    
    init(name: String, isHidden: Bool) {
        super.init()
        
        self.name = name
        self.isHidden = isHidden
    }
}
