//
//  EmployeeQueryTableViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/29/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol EmployeeQueryTableViewDelegate {
    func updatePickedEmployees(var employees: [User])
}

class EmployeeQueryTableViewController: PFQueryTableViewController {
    
    var delegate: EmployeeQueryTableViewDelegate?
    var selectedEmp = [User]()
    
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
    
    override func objectsWillLoad() {
        self.selectedEmp.removeAll(keepCapacity: false)
        self.tableView.layer.borderColor = UIColor.whiteColor().CGColor
        self.tableView.layer.borderWidth = 1
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "_User")
        query.whereKey("Group", equalTo: "Employee")
        query.orderByAscending("FirstName")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        var cell = tableView.dequeueReusableCellWithIdentifier("EmployeePickCell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "EmployeePickCell")
        }
        
        cell.backgroundColor = UIColor.MKColor.BlueGrey
        cell.accessoryType = .None
        cell.tintColor = UIColor.whiteColor()
        // Extract values from the PFObject to display in the table cell
        if let firstName = object?["FirstName"] as? String {
            if let lastName = object?["LastName"] as? String {
                cell?.textLabel?.text = "\(firstName) \(lastName)"
            }
        }
        
        let employee:User = (objects?[indexPath.row] as! User)
        for var i=0; i<self.selectedEmp.count; i++ {
            if employee == self.selectedEmp[i] {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let employee:User = (objects?[indexPath.row] as! User)
        //self.dismissViewControllerAnimated(true, completion: nil)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell!.accessoryType = .None
            for var i=0; i<selectedEmp.count; i++ {
                let emp = selectedEmp[i]
                if emp == employee {
                    selectedEmp.removeAtIndex(i)
                }
            }
        } else {
            cell!.accessoryType = .Checkmark
            selectedEmp.append(employee)
        }
        delegate?.updatePickedEmployees(selectedEmp)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: Other methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
