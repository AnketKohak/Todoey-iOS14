//
//  Category.swift
//  Todoey
//
//  Created by Anket Kohak on 17/08/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() 
}
