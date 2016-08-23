//
//  PickContextTableViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/15/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol PickContextTableViewControllerDelegate
{
    func updateAssignButtonToChosenContext(var context : String)
}

class PickContextTableViewController: UITableViewController {
    
    var delegate:PickContextTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContextCell", forIndexPath: indexPath)

        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Record"
        case 1:
            cell.textLabel?.text = "Book"
        case 2:
            cell.textLabel?.text = "Kitchen"
        default:
            break
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        delegate?.updateAssignButtonToChosenContext(cell!.textLabel!.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
