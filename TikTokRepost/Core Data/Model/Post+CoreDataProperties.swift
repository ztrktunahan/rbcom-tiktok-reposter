//
//  Post+CoreDataProperties.swift
//  InstRepost
//
//  Created by Влад Лыков on 06.09.2021.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var caption: String?
    @NSManaged public var date: Date?
    @NSManaged public var url: URL?
    @NSManaged public var videoURL: URL?
    @NSManaged public var imageData: Data?

}
