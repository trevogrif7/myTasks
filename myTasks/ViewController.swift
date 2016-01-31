//
//  ViewController.swift
//  myTasks
//
//  Created by Trevor Griffin on 12/19/15.
//  Copyright © 2015 TREVOR E GRIFFIN. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as! TaskModel
            
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
        }
        else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            
            addTaskVC.delegate = self
            
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }

    
    // UITableView Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        let cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.dateToString(date: thisTask.date!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    // UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if fetchedResultsController.sections?.count == 1 {
            let fetcedObjects = fetchedResultsController.fetchedObjects!
            
            let testTask: TaskModel = fetcedObjects[0] as! TaskModel
            
            if testTask.completed == true {
                return "Completed"
            }
            else {
                    return "To Do"
                    
            }
        }
        else {
            if section == 0 {
                return "To Do:"
            }
            else {
                return "Completed:"
            }

        }
            
        
     }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel

        if thisTask.completed == true {
            thisTask.completed = false
        } else {
            thisTask.completed = true
        }

    
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    
    // NSFetchedResultsController Delegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // Helper
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        
        return fetchRequest
        
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        
        return fetchedResultsController
    }
    
    // TaskDetailViewControllerEdited
    func taskDetailEdited() {
        showAlert()
    }
    
    func addTask(message: String) {
        showAlert(message)
    }
    
    func addTaskCanceled(message: String) {
        showAlert(message)
    }
    
    func showAlert (message:String = "Congratulations") {
        let alert = UIAlertController(title: "Change Made!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

