//
//  ToDoItem.swift
//  ToDo List with Realm
//
//  Created by Rey Cerio on 2017-05-21.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    dynamic var detail = ""
    dynamic var status = 0
}
