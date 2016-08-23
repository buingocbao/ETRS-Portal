//
//  BeaconQueryTableViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/19/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol BeaconQueryTableViewControllerDelegate
{
    func updateAssignButtonToChosenBeacon(var beacon : Beacon)
}

class BeaconQueryTableViewController: PFQueryTableViewController {
    
    var delegate: BeaconQueryTableViewControllerDelegate?
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Beacon"
        self.textKey = "Minor"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Beacon")
        query.whereKey("Context", equalTo: "Record").whereKey("Status", equalTo: true)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PFTableViewCell!
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let major = object?["Major"] as? String {
            if let minor = object?["Minor"] as? String {
                cell?.textLabel?.text = "\(major) - \(minor)"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let beacon:Beacon = (objects?[indexPath.row] as! Beacon)
        delegate?.updateAssignButtonToChosenBeacon(beacon)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Other methods
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
