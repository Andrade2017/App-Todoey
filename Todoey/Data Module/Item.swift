//
//  Item.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/24/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")     // realationship in Realm
}
