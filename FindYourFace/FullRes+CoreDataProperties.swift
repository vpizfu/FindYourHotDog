//
//  FullRes+CoreDataProperties.swift
//  
//
//  Created by Roman on 9/7/20.
//
//

import Foundation
import CoreData


extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var thumbnail: Thumbnail?

}
