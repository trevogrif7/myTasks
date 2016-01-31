//
//  TaskModel+CoreDataProperties.swift
//  myTasks
//
//  Created by Trevor Griffin on 1/8/16.
//  Copyright © 2016 TREVOR E GRIFFIN. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TaskModel {

    @NSManaged var completed: NSNumber?
    @NSManaged var date: NSDate?
    @NSManaged var subtask: String?
    @NSManaged var task: String?

}
