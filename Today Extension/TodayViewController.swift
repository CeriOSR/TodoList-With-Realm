//
//  TodayViewController.swift
//  Today Extension
//
//  Created by Rey Cerio on 2017-05-21.
//  Copyright © 2017 Rey Cerio. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

//ADDING YOUR APP TO THE WIDGET
class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    var realm: Realm!
    var todoList: Results<TodoItem> {
        get {
            return realm.objects(TodoItem.self)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: K_GROUP_ID)!
        let fileURL = directory.appendingPathComponent(K_DB_NAME)
        realm = try! Realm(fileURL: fileURL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == .compact){
            preferredContentSize = CGSize.init(width: 320, height: 40)
        }else if (activeDisplayMode == .expanded){
            preferredContentSize = maxSize
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = todoList[indexPath.row]
        cell.textLabel?.text = item.detail
        cell.detailTextLabel?.text = "\(item.status)"
        return cell
    }
    
}

