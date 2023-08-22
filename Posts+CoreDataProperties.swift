//
//  Posts+CoreDataProperties.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 13/08/23.
//
//

import Foundation
import CoreData


extension Posts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posts> {
        return NSFetchRequest<Posts>(entityName: "Posts")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var post: String?
    @NSManaged public var title: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var penggunas: Pengguna?
    
    public var wrappedPost : String {
        post ?? "Unknown Post"
    }

}

extension Posts : Identifiable {

}
