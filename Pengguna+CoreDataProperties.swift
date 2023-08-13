//
//  Pengguna+CoreDataProperties.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 13/08/23.
//
//

import Foundation
import CoreData


extension Pengguna {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pengguna> {
        return NSFetchRequest<Pengguna>(entityName: "Pengguna")
    }

    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var post: NSSet?
    
    public var postArray: [Posts] {
        let set = post as? Set<Posts> ?? []
        
        return set.sorted {
            $0.wrappedPost > $1.wrappedPost
        }
    }
 
}

// MARK: Generated accessors for post
extension Pengguna {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: Posts)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: Posts)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}

extension Pengguna : Identifiable {

}
