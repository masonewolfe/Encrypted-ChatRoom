//
//  FriendRequest+CoreDataProperties.swift
//  
//
//  Created by Dylan Moran on 4/20/23.
//
//

import Foundation
import CoreData


extension FriendRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendRequest> {
        return NSFetchRequest<FriendRequest>(entityName: "FriendRequest")
    }

    @NSManaged public var friends: Bool
    @NSManaged public var username: String?
    @NSManaged public var base64EncodedEncryptedAESKey: String?
    @NSManaged public var iv: String?

}
