//
//  XMPPMessageEntity+CoreDataProperties.swift
//  
//
//  Created by Dylan Moran on 3/22/23.
//
//

import Foundation
import CoreData


extension XMPPMessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<XMPPMessageEntity> {
        return NSFetchRequest<XMPPMessageEntity>(entityName: "XMPPMessageEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var recipient: String?
    @NSManaged public var sender: String?
    @NSManaged public var timeStamp: Date
    @NSManaged public var read: Bool

}
