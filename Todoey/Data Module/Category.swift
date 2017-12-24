//
//  Category.swift
//  Todoey
//
//  Created by Thiago Andrade on 12/24/17.
//  Copyright © 2017 Andrade. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()               //Realationship in Realm
}
