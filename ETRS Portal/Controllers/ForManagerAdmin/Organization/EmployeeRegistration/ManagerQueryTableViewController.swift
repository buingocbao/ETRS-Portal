//
//  ManagerQueryTableViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/15/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
protocol ManagerQueryTableViewControllerDelegate
{
    func updateAssignButtonToChosenManager(var manager : User)
}

class ManagerQueryTableViewController: PFQueryTableViewController {
    
    var delegate: ManagerQueryTableViewControllerDelegate?
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "_User"
        self.textKey = "FirstName"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "_User")
        query.whereKey("Group", equalTo: "Manager")
        query.orderByAscending("FirstName")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let firstName = object?["FirstName"] as? String {
            if let lastName = object?["LastName"] as? String {
                cell?.textLabel?.text = "\(firstName) \(lastName)"
            }
        }
        
        if let username = object?["username"] as? String {
            cell?.detailTextLabel?.text = username
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let manager:User = (objects?[indexPath.row] as! User)
        delegate?.updateAssignButtonToChosenManager(manager)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Other methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
