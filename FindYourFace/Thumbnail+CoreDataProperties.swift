//
//  Thumbnail+CoreDataProperties.swift
//  
//
//  Created by Roman on 9/7/20.
//
//

import Foundation
import CoreData


extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var id: Double
    @NSManaged public var imageData: Data?
    @NSManaged public var fullRes: FullRes?

}
