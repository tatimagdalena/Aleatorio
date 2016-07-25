//
//  RangeExtension.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/24/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//

import Foundation

extension Range where Element: Hashable {
    func random(without excluded:[Element]) -> Element {
        let valid = Set(self).subtract(Set(excluded))
        let random = Int(arc4random_uniform(UInt32(valid.count)))
        return Array(valid)[random]
    }
}