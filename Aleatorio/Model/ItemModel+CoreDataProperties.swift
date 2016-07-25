//
//  ItemModel+CoreDataProperties.swift
//  Aleatorio
//
//  Created by Tatiana Magdalena on 7/24/16.
//  Copyright © 2016 Tatiana Magdalena. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemModel {

    @NSManaged var name: String?
    @NSManaged var isHidden: NSNumber?

}
