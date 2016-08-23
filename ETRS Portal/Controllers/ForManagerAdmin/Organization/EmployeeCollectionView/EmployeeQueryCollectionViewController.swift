//
//  EmployeeQueryCollectionViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/30/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class EmployeeQueryCollectionViewController: PFQueryCollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var activityIndicatorView: NVActivityIndicatorView?
    var allObjects = [User]()
    var employeeObjects = [User]()
    var managerObjects = [User]()
    var adminObjects = [User]()
    
    let nodeConstructionQueue = NSOperationQueue()
    
    override func awakeFromNib() {
        self.collectionView?.backgroundColor = UIColor.MKColor.Blue
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "User"
        self.loadingViewEnabled = false
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForCollection() -> PFQuery {
        let query = User.query()
        query?.orderByDescending("Group")
        return query!
    }
    
    override func objectsWillLoad() {
        // Show activityIndicatior
        if self.activityIndicatorView == nil {
            let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0, y: 0, width: 100, height: 100), type: NVActivityIndicatorType.BallTrianglePath, color: UIColor.whiteColor(), size: CGSize(width: 100, height: 100))
            activityIndicatorView.center = self.view.center
            self.view.addSubview(activityIndicatorView)
            self.view.bringSubviewToFront(activityIndicatorView)
            self.activityIndicatorView = activityIndicatorView
            self.activityIndicatorView!.startAnimation()
        } else {
            self.activityIndicatorView!.hidden = false
            self.activityIndicatorView!.startAnimation()
        }
    }
    
    override func objectsDidLoad(error: NSError?) {
        print(objects)
        allObjects = objects as! [User]
        employeeObjects = allObjects.filter() {($0 as User).Group.containsString("Employee")}
        managerObjects = allObjects.filter() {($0 as User).Group.containsString("Manager")}
        adminObjects = allObjects.filter() {($0 as User).Group.containsString("Admin")}
        print(employeeObjects.count)
        print(managerObjects.count)
        print(adminObjects.count)
        self.activityIndicatorView!.stopAnimation()
        self.activityIndicatorView!.hidden = true
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return adminObjects.count
        case 1:
            return managerObjects.count
        case 2:
            return employeeObjects.count
        default:
            return 0
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmployeeCell", forIndexPath: indexPath) as! EmployeeCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        switch indexPath.section {
        case 0:
            let adminObject = self.adminObjects[indexPath.row]
            if let _ = adminObject.Avatar {
                adminObject.Avatar!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        cell.configCellWithDefaultAvatar(adminObject, image: image!)
                        //cell.configCellDisplayWithUserInfo(adminObject, image: image!, nodeConstructionQueue: self.nodeConstructionQueue)
                    }
                })
            } else {
                cell.configCellWithDefaultAvatar(adminObject, image: UIImage(named: "Avatar")!)
            }
        case 1:
            let managerObject = self.managerObjects[indexPath.row]
            if let _ = managerObject.Avatar {
                managerObject.Avatar!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        cell.configCellWithDefaultAvatar(managerObject, image: image!)
                        //cell.configCellDisplayWithUserInfo(managerObject, image: image!, nodeConstructionQueue: self.nodeConstructionQueue)
                    }
                })
            } else {
                cell.configCellWithDefaultAvatar(managerObject, image: UIImage(named: "Avatar")!)
            }
        case 2:
            let employeeObject = self.employeeObjects[indexPath.row]
            if let _ = employeeObject.Avatar {
                employeeObject.Avatar!.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        cell.configCellWithDefaultAvatar(employeeObject, image: image!)
                        //cell.configCellDisplayWithUserInfo(employeeObject, image: image!, nodeConstructionQueue: self.nodeConstructionQueue)
                    }
                })
            } else {
                cell.configCellWithDefaultAvatar(employeeObject, image: UIImage(named: "Avatar")!)
            }
        default:
            break
        }
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "EmployeeHeader", forIndexPath: indexPath) as! EmployeeCollectionReusableView
            switch indexPath.section {
            case 0:
                headerView.headerLB.text = checkLanguage("admin")
                headerView.headerLB.backgroundColor = UIColor.MKColor.Red
            case 1:
                headerView.headerLB.text = checkLanguage("manager")
                headerView.headerLB.backgroundColor = UIColor.MKColor.Orange
            case 2:
                headerView.headerLB.text = checkLanguage("employee")
                headerView.headerLB.backgroundColor = UIColor.MKColor.Green
            default:
                break
            }
            reusableView = headerView
        }
        return reusableView
    }
    /*
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 320, height: 128)
    }*/
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Select \(indexPath.section):\(indexPath.row)")
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EmployeeCollectionViewCell
        let image = cell.avatar
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupPickEmployeeVC") as! PickEmployeeViewController
        switch indexPath.section {
        case 0:
            popupVC.employeeObject = adminObjects[indexPath.row]
            popupVC.image = image
        case 1:
            popupVC.employeeObject = managerObjects[indexPath.row]
            popupVC.image = image
        case 2:
            popupVC.employeeObject = employeeObjects[indexPath.row]
            popupVC.image = image
        default:
            break
        }
        showPopupWithTransitionStyle(.Fade, rootViewController: popupVC)
    }
    
    
    // MARK: Other methods
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = "en"
        if let lg = defaults.stringForKey("Language"){
            language = lg
        }
        let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        let string = bundle?.localizedStringForKey(key, value: nil, table: nil)
        return string!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showPopupWithTransitionStyle(transitionStyle: STPopupTransitionStyle, rootViewController: UIViewController) {
        let popupController = STPopupController(rootViewController: rootViewController)
        popupController.cornerRadius = 4
        popupController.transitionStyle = transitionStyle
        popupController.presentInViewController(self)
    }
    
}
