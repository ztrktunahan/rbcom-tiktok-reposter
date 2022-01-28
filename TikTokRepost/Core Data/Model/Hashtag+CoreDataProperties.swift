//
//  Hashtag+CoreDataProperties.swift
//  TikTokRepost
//
//  Created by Влад Лыков on 12.09.2021.
//
//

import Foundation
import CoreData


extension Hashtag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hashtag> {
        return NSFetchRequest<Hashtag>(entityName: "Hashtag")
    }

    @NSManaged public var defaultTag: Bool
    @NSManaged public var tags: String?
    @NSManaged public var title: String?

}
