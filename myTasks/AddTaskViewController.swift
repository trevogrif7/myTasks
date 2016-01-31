//
//  AddTaskViewController.swift
//  myTasks
//
//  Created by Trevor Griffin on 12/23/15.
//  Copyright © 2015 TREVOR E GRIFFIN. All rights reserved.
//

import UIKit
import CoreData

protocol AddTaskViewControllerDelegate {
    func addTask(message: String)
    func addTaskCanceled(message: String)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!

    @IBOutlet weak var subtaskTextField: UITextField!
    
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTaskCanceled("Task was not added!")

    }

    @IBAction func addTaskButtonTapped(sender: UIButton) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedObjectContext = appDelegate.managedObjectContext
       
        let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
        
        let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
            task.task = taskTextField.text?.capitalizedString
        } else {
            task.task = taskTextField.text
        }
        
        task.subtask = subtaskTextField.text
        
        if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
            task.completed = true
        } else {
            task.completed = false
        }

        task.date = dueDatePicker.date
        
        appDelegate.saveContext()
        
        let request = NSFetchRequest(entityName: "TaskModel")
        var results: NSArray = []
        
        do {
            results = try managedObjectContext.executeFetchRequest(request)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        for res in results {
            print(res)
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.addTask("Task added")

    }
}
