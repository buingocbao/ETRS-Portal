//
//  PickColorTableViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/16/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol PickColorTableViewControllerDelegate
{
    func updateAssignButtonToChosenColor(var color : String)
}

class PickColorTableViewController: UITableViewController {

    var delegate:PickColorTableViewControllerDelegate?
    
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
        return 5
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ColorCell", forIndexPath: indexPath)
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Blue"
        case 1:
            cell.textLabel?.text = "LightViolet"
        case 2:
            cell.textLabel?.text = "Mint"
        case 3:
            cell.textLabel?.text = "Pink"
        case 4:
            cell.textLabel?.text = "Violet"
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        delegate?.updateAssignButtonToChosenColor(cell!.textLabel!.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
