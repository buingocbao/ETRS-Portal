//
//  ExportViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/24/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import QuickLook

class ExportViewController: UIViewController {

    @IBOutlet weak var headerLB: UILabel!
    @IBOutlet weak var pickedEmpView: UIView!
    @IBOutlet weak var exportBT: MKButton!
    @IBOutlet weak var pickMonthBT: MKButton!
    @IBOutlet weak var pickYearBT: MKButton!
    
    var backButton: MKButton = MKButton()
    var empCheckmark: CheckmarkSegmentedControl?
    var yearCheckMark: CheckmarkSegmentedControl?
    var monthCheckMark: CheckmarkSegmentedControl?
    var pickedMonth = NSDate.today().month
    var pickedYear = NSDate.today().year
    
    var pickedEmpDelegate: EmployeeQueryTableViewDelegate?
    var pickedEmps = [User]()
    
    var hideView: UIView?
    
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLB.text = checkLanguage("export_record")
        self.view.backgroundColor = UIColor.MKColor.BlueGrey
        configBackButton()
        configEmpCheckMark()
        createHideView()
    }

    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.rippleLocation = .Center
        backButton.ripplePercent = 1.75
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        //backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        //backButton.setTitle("X", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        
        exportBT.layer.shadowOpacity = 0.75
        exportBT.layer.shadowRadius = 3.5
        exportBT.layer.shadowColor = UIColor.blackColor().CGColor
        exportBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        exportBT.maskEnabled = true
        exportBT.layer.cornerRadius = 5
        
        pickMonthBT.layer.shadowOpacity = 0.75
        pickMonthBT.layer.shadowRadius = 3.5
        pickMonthBT.layer.shadowColor = UIColor.blackColor().CGColor
        pickMonthBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        pickMonthBT.maskEnabled = true
        pickMonthBT.layer.cornerRadius = 5
        pickMonthBT.setTitle(String(pickedMonth), forState: .Normal)
        
        pickYearBT.layer.shadowOpacity = 0.75
        pickYearBT.layer.shadowRadius = 3.5
        pickYearBT.layer.shadowColor = UIColor.blackColor().CGColor
        pickYearBT.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        pickYearBT.maskEnabled = true
        pickYearBT.layer.cornerRadius = 5
        pickYearBT.setTitle(String(pickedYear), forState: .Normal)
    }
    
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func configEmpCheckMark() {
        // Group segment
        let checkmark: CheckmarkSegmentedControl = CheckmarkSegmentedControl(frame: CGRect(x: self.view.frame.width/4, y: 100, width: self.view.frame.width/2, height: 80))
        checkmark.backgroundColor = UIColor.clearColor()
        checkmark.titleColor = UIColor.whiteColor()
        checkmark.options = [
            CheckmarkOption(title: checkLanguage("all_employee"), borderColor: UIColor.whiteColor(), fillColor: UIColor.MKColor.Blue),
            CheckmarkOption(title: checkLanguage("selected_employees"), borderColor: UIColor.whiteColor(), fillColor: UIColor.MKColor.Blue)
        ]
        checkmark.addTarget(self, action: "empOptionSelected", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(checkmark)
        self.empCheckmark = checkmark
    }
    
    func empOptionSelected() {
        print("Selected option: \(self.empCheckmark!.options[empCheckmark!.selectedIndex])")
        if self.empCheckmark!.options[empCheckmark!.selectedIndex].title == checkLanguage("all_employee") {
            createHideView()
        } else {
            self.hideView?.removeFromSuperview()
            self.pickedEmpView.userInteractionEnabled = true
        }
    }
    
    func createHideView() {
        let hideView = UIView(frame: self.pickedEmpView.frame)
        hideView.backgroundColor = UIColor.MKColor.BlueGrey
        hideView.alpha = 0.8
        self.view.addSubview(hideView)
        self.hideView = hideView
        self.pickedEmpView.userInteractionEnabled = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickEmployeeSegue" {
            let empPick = segue.destinationViewController as! EmployeeQueryTableViewController
            empPick.delegate = self
        }
    }
    
    func getLastDayOfTheMonth(today: String) -> Int {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        // Setup the calendar object
        let calendar = NSCalendar.currentCalendar()
        // Create an NSDate for the first and last day of the month
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: todayDate)
        // Getting the First and Last date of the month
        components.day = 1
        components.month  += 1
        components.day     = 0
        let lastDateOfMonth: NSDate = calendar.dateFromComponents(components)!
        return lastDateOfMonth.day
    }
    
    func showIndicatorActivity() {
        //Create the visual effect
        //You can choose between ExtraLight, Light and Dark
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Dark)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        blurView.center = self.view.center
        self.view.addSubview(blurView)
        self.blurView = blurView
        
        let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        vibrancyView.frame = blurView.frame
        vibrancyView.center = blurView.center
        blurView.contentView.addSubview(vibrancyView)
        
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
            type: activityTypes)
        activityIndicatorView.center = self.view.center
        vibrancyView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView?.hidden = false
        self.activityIndicatorView?.startAnimation()
        self.view.userInteractionEnabled = false
    }
    
    func closeIndicatorActivity() {
        self.blurView?.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    //MARK: Event
    @IBAction func exportBTEvent(sender: AnyObject) {
        if self.empCheckmark!.options[empCheckmark!.selectedIndex].title == checkLanguage("all_employee") {
            doCheckFunction(true)
        } else {
            doCheckFunction(false)
        }
    }
    
    func doCheckFunction(isAll: Bool) {
        if isAll == true {
            showIndicatorActivity()
            queryEmployees(true)
        } else {
            if self.pickedEmps.count == 0 {
                let alert = UIAlertController(title: self.checkLanguage("warning"), message: self.checkLanguage("pick_at_least_one_emp"), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                showIndicatorActivity()
                queryTimeRecord(self.pickedEmps, isAll: false)
            }
        }
    }
    
    func queryEmployees(isAll: Bool) {
        //Export all employees
        let query = User.query()
        query?.whereKey("Group", equalTo: "Employee")
        query?.orderByAscending("FirstName")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                let empResults = objects as! [User]
                self.queryTimeRecord(empResults, isAll: isAll)
            } else {
                print(error)
                self.closeIndicatorActivity()
            }
        })
        
    }
    
    func queryTimeRecord(empResults: [User], isAll: Bool) {
        if isAll == true {
            //Query all records
            let query = TimeRecording.query()
            query?.whereKey("Month", equalTo: self.pickedMonth)
            query?.whereKey("Year", equalTo: self.pickedYear)
            query?.orderByAscending("Employee")
            query?.orderByAscending("Day")
            query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    let recordResults = objects as! [TimeRecording]
                    self.doExportAllFunction(empResults, recordResults: recordResults)
                } else {
                    print(error)
                    self.closeIndicatorActivity()
                }
            })
        } else {
            var subQueries = [PFQuery]()
            //Query picked employees record
            for empResult in empResults {
                let query = TimeRecording.query()
                query?.whereKey("Month", equalTo: self.pickedMonth)
                query?.whereKey("Year", equalTo: self.pickedYear)
                query?.whereKey("Employee", equalTo: empResult.email!)
                //query?.orderByAscending("Employee")
                //query?.orderByAscending("Day")
                //query?.whereKey("Employee", containsString: empResult.email!)
                subQueries.append(query!)
            }
            let combinedQuery = PFQuery.orQueryWithSubqueries(subQueries)
            combinedQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    let recordResults = objects as! [TimeRecording]
                    self.doExportAllFunction(empResults, recordResults: recordResults)
                } else {
                    print(error)
                    self.closeIndicatorActivity()
                }
            })
        }
    }
    
    func doExportAllFunction(empResults: [User], recordResults: [TimeRecording]) {
        let fileName = "Record.csv"
        var header1 = "Employee"
        var header2 = "\n"
        var body = ""
        let numberOfDaysInMonth = getLastDayOfTheMonth("\(self.pickedYear)-\(self.pickedMonth)-1")
        
        for day in 1...numberOfDaysInMonth {
            header1 += ",\(day),"
            header2 += ",In,Out"
        }
        
        for employee in empResults {
            let fullName = "\n" + employee.FirstName + " " + employee.LastName
            let empRecordsMatched = recordResults.filter({ $0.Employee == employee.email })
            if empRecordsMatched.count == 0 {
                var row = ""
                for _ in 1...numberOfDaysInMonth {
                    row += ",,"
                }
                body += fullName + row
            } else {
                var row = ""
                for day in 1...numberOfDaysInMonth {
                    let record = empRecordsMatched.filter({ $0.Day == day })
                    if record.count != 0 {
                        let start = record[0].StartTimeRecord!
                        let end = record[0].EndTimeRecord!
                        row += ",\(start),\(end)"
                    } else {
                        row += ",,"
                    }
                }
                body += fullName + row
            }
            
        }

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent(fileName)
        //let contentsOfFile = "No,Employee,Date,Start,End\n1,\(employee),\(date),\(start),\(endTime)"
        let contentsOfFile = header1 + header2 + body
        do {
            try contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            print("Created")
            print(path)
            closeIndicatorActivity()
            self.viewFile()
        } catch {
            print("Failed")
            closeIndicatorActivity()
        }
    }
    
    func viewFile() {
        let previewController = QLPreviewController()
        previewController.delegate = self
        previewController.dataSource = self
        self.presentViewController(previewController, animated: true, completion: nil)
    }
    
    @IBAction func pickMonthBTEvent(sender: AnyObject) {
        showPickMonthPopover()
    }
    
    @IBAction func pickYearBTEvent(sender: AnyObject) {
        showPickYearPopover()
    }
    
    func showPickMonthPopover() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PickMonthVC") as! PickMonthViewController
        popoverContent.delegate = self
        popoverContent.pickedYear = self.pickedYear
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(220 , 170)
        popover!.delegate = self
        popover!.permittedArrowDirections = .Left
        popover!.sourceView = pickMonthBT
        popover!.sourceRect = CGRectMake(pickMonthBT.frame.width, pickMonthBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func showPickYearPopover() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PickYearVC") as! PickYearViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(220 , 170)
        popover!.delegate = self
        popover!.permittedArrowDirections = .Left
        popover!.sourceView = pickYearBT
        popover!.sourceRect = CGRectMake(pickYearBT.frame.width, pickYearBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
}

extension ExportViewController: EmployeeQueryTableViewDelegate {
    func updatePickedEmployees(employees: [User]) {
        self.pickedEmps = employees
        print(self.pickedEmps.count)
    }
}

extension ExportViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension ExportViewController: PickMonthViewControllerDelegate {
    func sendMonthValue(value: Int) {
        self.pickedMonth = value
        pickMonthBT.setTitle(String(self.pickedMonth), forState: .Normal)
    }
}

extension ExportViewController: PickYearViewControllerDelegate {
    func sendYearValue(value: Int) {
        self.pickedYear = value
        pickYearBT.setTitle(String(self.pickedYear), forState: .Normal)
    }
}

extension ExportViewController: QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        print("Getting item")
        let fileName = "Record.csv"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent(fileName)
        let doc = NSURL(fileURLWithPath: path)
        return doc
    }
}

