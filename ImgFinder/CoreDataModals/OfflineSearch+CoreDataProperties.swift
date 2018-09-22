//
//  OfflineSearch+CoreDataProperties.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 22/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension OfflineSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineSearch> {
        return NSFetchRequest<OfflineSearch>(entityName: "OfflineSearch")
    }

    @NSManaged public var searchText: String?
    @NSManaged public var searchResuts: [String]

}
