//
//  ViewController.swift
//  ToDo List with Realm
//
//  Created by Rey Cerio on 2017-05-21.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
//    let realm = try! Realm()
    var realm: Realm!
    var todoList: Results<TodoItem> {
        get{
            return realm.objects(TodoItem.self)
        }
    }
    
    //add new item button will pop an alert controller where you can enter the task
    @IBAction func addNew(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
        
        alertController.addTextField { (UITextField) in
            //empty code
        }
        
        let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) in
            
        }
        alertController.addAction(action_cancel)
        
        let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) in
            let textFieldToDo = (alertController.textFields?.first)! as UITextField
            print("You entered \(String(describing: textFieldToDo.text))")
            
            //instantiating a new TodoItem and setting the detail and status
            let todoItem = TodoItem()
            todoItem.detail = textFieldToDo.text!
            todoItem.status = 0
            
            //writing the task into the realm persistent
            try! self.realm.write {
                self.realm.add(todoItem)
                self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count - 1, section: 0)], with: .automatic)
            }
            
        }
        alertController.addAction(action_add)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //putting the tasks into the tableView
        let item = todoList[indexPath.row]
        cell.textLabel!.text = item.detail
        cell.detailTextLabel?.text = "\(item.status)"
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    //mark as done by changing the detailText to 1 from 0 when tapping on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoList[indexPath.row]
        try! self.realm.write {
            if item.status == 0 {
                item.status = 1
            }else{
                item.status = 0
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = todoList[indexPath.row]
            try! self.realm.write {                     //without the ! errors here wont be handled, cause an error.
                self.realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //this migrates the db into appgroup
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
        
        let fileURL = directory.appendingPathComponent(K_DB_NAME)
        realm = try! Realm(fileURL: fileURL)
        
        // this will show you where the files are saved
        print("File url: \(String(describing: realm.configuration.fileURL))")
        
    }
}

