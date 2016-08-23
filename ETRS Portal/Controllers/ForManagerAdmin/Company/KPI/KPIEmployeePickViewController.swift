//
//  KPIEmployeePickViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/19/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import Charts
import QuickLook

class KPIEmployeePickViewController: UIViewController {
    
    var backButton: MKButton = MKButton()
    var reloadButton: MKButton = MKButton()

    @IBOutlet weak var headerLB: UILabel!
    @IBOutlet weak var employeeCollectionView: UICollectionView!
    
    @IBOutlet weak var employeeGraphView: UIView!
    @IBOutlet weak var empChartview: CombinedChartView!
    
    var employeeArray = [User]()
    
    var alwaysActivityIndicatorView: NVActivityIndicatorView?
    var graphActivityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    var pickedEmp = User()
    var pickedEmpTR = [TimeRecording]()
    var pickedMonth = NSDate.today().month
    var pickedYear = NSDate.today().year
    var flag = true
    var combine = false
    
    @IBOutlet weak var monthPickerBT: MKButton!
    @IBOutlet weak var yearPickerBT: MKButton!
    @IBOutlet weak var startRecordBT: MKButton!
    @IBOutlet weak var endRecordBT: MKButton!
    @IBOutlet weak var combineChartBT: MKButton!
    @IBOutlet weak var exportBT: MKButton!
    
    @IBOutlet weak var saveGraphImageBT: MKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeGraphView.alpha = 0
        headerLB.text = checkLanguage("kpi_employee")
        employeeCollectionView.delegate = self
        employeeCollectionView.dataSource = self
        configBackButton()
        queryParseMethod()
        configActivityIndicator()
        configReloadButton()
        configCharts()
        configSideButtons()
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
    }
    
    func backButtonClick(button:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func queryParseMethod() {
        let query = User.query()
        query?.whereKey("Group", equalTo: "Employee")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                self.employeeArray = objects as! [User]
                self.employeeCollectionView.reloadData()
                self.alwaysActivityIndicatorView?.stopAnimation()
                self.alwaysActivityIndicatorView?.hidden = true
            }
        })
    }
    
    func configActivityIndicator() {
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:self.view.frame.width-10-30, y: 10, width: 30, height: 30), type: NVActivityIndicatorType.BallTrianglePath, color: UIColor.whiteColor(), size: CGSize(width: 30, height: 30))
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubviewToFront(activityIndicatorView)
        self.alwaysActivityIndicatorView = activityIndicatorView
        self.alwaysActivityIndicatorView!.startAnimation()
    }
    
    func configReloadButton() {
        // Back Button
        reloadButton.frame = CGRect(x:self.view.frame.width-10-30-60, y: 5, width: 50, height: 50)
        reloadButton.backgroundColor = UIColor.clearColor()
        reloadButton.cornerRadius = 20.0
        reloadButton.backgroundLayerCornerRadius = 20.0
        reloadButton.maskEnabled = false
        reloadButton.rippleLocation = .Center
        reloadButton.ripplePercent = 1.75
        reloadButton.layer.shadowOpacity = 0.75
        reloadButton.layer.shadowRadius = 3.5
        reloadButton.layer.shadowColor = UIColor.blackColor().CGColor
        reloadButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        reloadButton.setImage(UIImage(named: "Reload"), forState: UIControlState.Normal)
        //backButton.setTitle("X", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        reloadButton.addTarget(self, action: "reloadButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(reloadButton)
        self.view.bringSubviewToFront(reloadButton)
    }
    
    func reloadButtonClick(button:UIButton) {
        self.alwaysActivityIndicatorView?.hidden = false
        self.alwaysActivityIndicatorView?.startAnimation()
        queryParseMethod()
    }
    
    func configCharts() {
        empChartview.delegate = self
        empChartview.noDataText = checkLanguage("no_chart_data")
        empChartview.highlightEnabled = true
        empChartview.dragEnabled = true
        empChartview.setScaleEnabled(true)
        empChartview.drawGridBackgroundEnabled = false
        empChartview.pinchZoomEnabled = true
        
        empChartview.backgroundColor = UIColor.MKColor.BlueGrey
        
        empChartview.descriptionText = ""
        empChartview.descriptionTextColor = UIColor.whiteColor()
        
        //setChart(getLastDayOfTheMonth(), range: Double(getLastDayOfTheMonth()))
        
        empChartview.legend.form = ChartLegend.ChartLegendForm.Line
        //empChartview.legend.font = UIFont(name: "Helvetica Neue-Light", size: 20)!
        empChartview.legend.textColor = UIColor.whiteColor()
        empChartview.legend.position = ChartLegend.ChartLegendPosition.BelowChartLeft
        
        let xAxis = empChartview.xAxis
        //xAxis.labelFont = UIFont(name: "Helvetica Neue-Light", size: 22)!
        xAxis.labelTextColor = UIColor.whiteColor()
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.spaceBetweenLabels = 1
        
        let startLimit = ChartLimitLine(limit: 8, label: "Start Standard")
        startLimit.lineWidth = 2
        startLimit.lineColor = UIColor.whiteColor()
        startLimit.lineDashLengths = [5,5]
        startLimit.labelPosition = ChartLimitLine.ChartLimitLabelPosition.RightTop
        startLimit.valueFont = UIFont.systemFontOfSize(10)
        
        let endLimit = ChartLimitLine(limit: 18, label: "End Standard")
        endLimit.lineWidth = 2
        endLimit.lineColor = UIColor.whiteColor()
        endLimit.lineDashLengths = [5,5]
        endLimit.labelPosition = ChartLimitLine.ChartLimitLabelPosition.RightTop
        endLimit.valueFont = UIFont.systemFontOfSize(10)
        
        let leftAxis = empChartview.leftAxis
        leftAxis.labelTextColor = UIColor.whiteColor()
        leftAxis.customAxisMax = 24
        leftAxis.drawGridLinesEnabled = false
        leftAxis.addLimitLine(startLimit)
        leftAxis.addLimitLine(endLimit)

        empChartview.rightAxis.enabled = false
        empChartview.animate(xAxisDuration: 2.5)
    }
    
    func createGraphActivityIndicator() {
        //Create the visual effect
        //You can choose between ExtraLight, Light and Dark
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Dark)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: self.employeeGraphView.frame.width, height: self.employeeGraphView.frame.height)
        //blurView.center = self.employeeGraphView.center
        self.employeeGraphView.addSubview(blurView)
        self.blurView = blurView
        
        let vibrancyView: UIVisualEffectView = UIVisualEffectView(effect: UIVibrancyEffect(forBlurEffect: blurEffect))
        vibrancyView.frame = blurView.frame
        vibrancyView.center = blurView.center
        blurView.contentView.addSubview(vibrancyView)
        
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.employeeGraphView.frame.width/2-50, y: self.employeeGraphView.frame.height/2-50, width: 100, height: 100),
            type: activityTypes)
        //activityIndicatorView.center = self.view.center
        vibrancyView.addSubview(activityIndicatorView)
        self.graphActivityIndicatorView = activityIndicatorView
        self.graphActivityIndicatorView?.hidden = false
        self.graphActivityIndicatorView?.startAnimation()
    }
    
    func closeGraphicIndicatorActivity() {
        self.blurView?.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    func configSideButtons() {
        monthPickerBT.maskEnabled = false
        monthPickerBT.ripplePercent = 1.2
        monthPickerBT.backgroundAniEnabled = false
        monthPickerBT.rippleLocation = .Center
        monthPickerBT.layer.borderColor = UIColor.whiteColor().CGColor
        monthPickerBT.layer.borderWidth = 0.5
        monthPickerBT.setTitle(String(self.pickedMonth), forState: .Normal)
        
        yearPickerBT.maskEnabled = false
        yearPickerBT.ripplePercent = 1.2
        yearPickerBT.backgroundAniEnabled = false
        yearPickerBT.rippleLocation = .Center
        yearPickerBT.layer.borderColor = UIColor.whiteColor().CGColor
        yearPickerBT.layer.borderWidth = 0.5
        yearPickerBT.setTitle(String(self.pickedYear), forState: .Normal)
        
        startRecordBT.maskEnabled = false
        startRecordBT.ripplePercent = 1.2
        startRecordBT.backgroundAniEnabled = false
        startRecordBT.rippleLocation = .Center
        startRecordBT.layer.borderColor = UIColor.whiteColor().CGColor
        startRecordBT.layer.borderWidth = 0.5
        startRecordBT.setTitle(checkLanguage("start_record_BT_title"), forState: .Normal)
        
        endRecordBT.maskEnabled = false
        endRecordBT.ripplePercent = 1.2
        endRecordBT.backgroundAniEnabled = false
        endRecordBT.rippleLocation = .Center
        endRecordBT.layer.borderColor = UIColor.whiteColor().CGColor
        endRecordBT.layer.borderWidth = 0.5
        endRecordBT.setTitle(checkLanguage("end_record_BT_title"), forState: .Normal)
        
        combineChartBT.maskEnabled = false
        combineChartBT.ripplePercent = 1.2
        combineChartBT.backgroundAniEnabled = false
        combineChartBT.rippleLocation = .Center
        
        exportBT.maskEnabled = false
        exportBT.ripplePercent = 1.2
        exportBT.backgroundAniEnabled = false
        exportBT.rippleLocation = .Center
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
    
    //MARK: Event
    @IBAction func monthPickerBTEvent(sender: AnyObject) {
        showPickMonthPopover()
    }
    @IBAction func yearPickerBTEvent(sender: AnyObject) {
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
        popover!.permittedArrowDirections = .Right
        popover!.sourceView = monthPickerBT
        popover!.sourceRect = CGRectMake(0, monthPickerBT.frame.height/2,0,0)
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
        popover!.permittedArrowDirections = .Right
        popover!.sourceView = yearPickerBT
        popover!.sourceRect = CGRectMake(0, yearPickerBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func startRecordBTEvent(sender: AnyObject) {
        self.flag = true
        queryTimeRecords()
    }
    
    @IBAction func endRecordBTEvent(sender: AnyObject) {
        self.flag = false
        queryTimeRecords()
    }
    
    @IBAction func combineChartBTEvent(sender: AnyObject) {
        if self.combine == false {
            self.combineChartBT.setBackgroundImage(UIImage(named: "Combine_Chosen"), forState: .Normal)
            self.combine = true
            queryTimeRecords()
        } else {
            self.combineChartBT.setBackgroundImage(UIImage(named: "Combine"), forState: .Normal)
            self.combine = false
            queryTimeRecords()
        }
    }
    
    @IBAction func exportBTEvent(sender: AnyObject) {
        doExportFunction()
    }
    
    func doExportFunction() {
        let fileName = "Record.csv"
        let header = "No,Employee,Date,Start,End,Reason"
        var body = ""
        var number = 1
        for index in 0...self.pickedEmpTR.count-1 {
            let employee = self.pickedEmpTR[index].Employee!
            let date = "\(self.pickedEmpTR[index].Day)/\(self.pickedEmpTR[index].Month)/\(self.pickedEmpTR[index].Year)"
            let start = self.pickedEmpTR[index].StartTimeRecord!
            var endTime = ""
            if let end = self.pickedEmpTR[index].EndTimeRecord {
                endTime = end
            }
            var reason = ""
            if let rs = self.pickedEmpTR[index].Reason {
                reason = rs
            }
            body += "\n\(number),\(employee),\(date),\(start),\(endTime),\(reason)"
            number++
        }
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent(fileName)
        //let contentsOfFile = "No,Employee,Date,Start,End\n1,\(employee),\(date),\(start),\(endTime)"
        let contentsOfFile = header + body
        do {
            try contentsOfFile.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
            print("Created")
            print(path)
            self.viewFile()
        } catch {
            print("Failed")
        }
    }
    
    func viewFile() {
        let previewController = QLPreviewController()
        previewController.delegate = self
        previewController.dataSource = self
        self.presentViewController(previewController, animated: true, completion: nil)
    }

    
    @IBAction func saveGraphImageBTEvent(sender: AnyObject) {
        let alert = UIAlertController(title: self.checkLanguage("warning"), message: self.checkLanguage("save_graph_to_cameraroll"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
            self.empChartview.saveToCameraRoll()
        }))
        alert.addAction(UIAlertAction(title: self.checkLanguage("cancel"), style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension KPIEmployeePickViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.employeeArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmployeeKPICell", forIndexPath: indexPath) as! KPIEmployeeCollectionViewCell
        cell.employeeFullName.text = self.employeeArray[indexPath.row].FirstName + " " + self.employeeArray[indexPath.row].LastName
        cell.employeeAvatar.file = self.employeeArray[indexPath.row].Avatar
        cell.employeeAvatar.loadInBackground()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.employeeCollectionView.userInteractionEnabled = false
        self.employeeCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            //
            self.employeeGraphView.alpha = 0
            }, completion: { (finished) -> Void in
                //
                self.pickedEmp = self.employeeArray[indexPath.row]
                self.queryTimeRecords()
            })
    }
    
    func queryTimeRecords() {
        self.employeeGraphView.alpha = 1
        self.createGraphActivityIndicator()
        let query = TimeRecording.query()
        query?.whereKey("Employee", equalTo: self.pickedEmp.username!)
        query?.whereKey("Month", equalTo: self.pickedMonth)
        query?.whereKey("Year", equalTo: self.pickedYear)
        query?.orderByAscending("Day")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                self.pickedEmpTR = objects as! [TimeRecording]
                self.closeGraphicIndicatorActivity()
                self.employeeCollectionView.userInteractionEnabled = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    //
                    print(self.getLastDayOfTheMonth("\(self.pickedYear)-\(self.pickedMonth)-1"))
                    let lastDayOfTheMonth = self.getLastDayOfTheMonth("\(self.pickedYear)-\(self.pickedMonth)-1")
                    self.setChart(lastDayOfTheMonth, range: Double(lastDayOfTheMonth), empTRObjects: self.pickedEmpTR, flag: self.flag, combine: self.combine)
                    self.empChartview.notifyDataSetChanged()
                    //self.empChartview.animate(xAxisDuration: 2.5)
                    self.empChartview.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
                })
            }
        })
    }
    
    func getMonthString(month: Int) -> String {
        switch month {
        case 1:
            return checkLanguage("january")
        case 2:
            return checkLanguage("february")
        case 3:
            return checkLanguage("march")
        case 4:
            return checkLanguage("april")
        case 5:
            return checkLanguage("may")
        case 6:
            return checkLanguage("june")
        case 7:
            return checkLanguage("july")
        case 8:
            return checkLanguage("august")
        case 9:
            return checkLanguage("september")
        case 10:
            return checkLanguage("october")
        case 11:
            return checkLanguage("november")
        case 12:
            return checkLanguage("december")
        default:
            return ""
        }

    }
}

extension KPIEmployeePickViewController: ChartViewDelegate {
    func setChart(count: Int, range: Double, empTRObjects: [TimeRecording], flag: Bool, combine: Bool) {
        var xVals = [String]()
        
        //var barChartData = BarChartData()
        var weekends = [BarChartDataEntry]()
        
        var yVals = [ChartDataEntry]()

        for var i=1; i<=count; i++ {
            xVals.append(String(i))
            let weekday = getDayOfWeek("\(self.pickedYear)-\(self.pickedMonth)-\(i)")
            if weekday == 7 || weekday == 1 {
                weekends.append(BarChartDataEntry(value: 24, xIndex: i-1))
            }
            for empTRObject in empTRObjects {
                if empTRObject.Day == i {
                    if flag == true {
                        yVals.append(ChartDataEntry(value: Double(changeTRObjectToDouble(empTRObject.StartTimeRecord!)), xIndex: i-1))
                    } else {
                        if let empTRObjectEnd = empTRObject.EndTimeRecord {
                            yVals.append(ChartDataEntry(value: Double(changeTRObjectToDouble(empTRObjectEnd)), xIndex: i-1))
                        }
                    }
                }
            }
        }
        
        let weekendSet = BarChartDataSet(yVals: weekends, label: "Weekends")
        weekendSet.setColor(UIColor.MKColor.Grey)
        weekendSet.valueTextColor = UIColor.clearColor()
        
        if combine == true {
            var y1Vals = [ChartDataEntry]()
            for var i=1; i<=count; i++ {
                for empTRObject in empTRObjects {
                    if empTRObject.Day == i {
                        y1Vals.append(ChartDataEntry(value: Double(changeTRObjectToDouble(empTRObject.StartTimeRecord!)), xIndex: i-1))
                    }
                }
            }
            
            var y2Vals = [ChartDataEntry]()
            for var i=1; i<=count; i++ {
                for empTRObject in empTRObjects {
                    if empTRObject.Day == i {
                        if let empTRObjectEnd = empTRObject.EndTimeRecord {
                            y2Vals.append(ChartDataEntry(value: Double(changeTRObjectToDouble(empTRObjectEnd)), xIndex: i-1))
                        }
                    }
                }
            }
            
            if y1Vals.count != 0 && y2Vals.count != 0{
                //chartName: "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)",
                let chartNameIn = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - In Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                let set1 = LineChartDataSet(yVals: y1Vals, label: chartNameIn)
                set1.axisDependency = ChartYAxis.AxisDependency.Left
                set1.setColor(UIColor.MKColor.Green)
                set1.lineWidth = 2.0
                set1.circleRadius = 3.0
                set1.fillAlpha = 65/225
                set1.fillColor = UIColor.MKColor.Green
                set1.highlightColor = UIColor.whiteColor()
                set1.drawCircleHoleEnabled = false
                set1.valueTextColor = UIColor.whiteColor()
                set1.valueFont = UIFont.systemFontOfSize(9)
                
                let chartNameOut = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - Out Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                let set2 = LineChartDataSet(yVals: y2Vals, label: chartNameOut)
                set2.axisDependency = ChartYAxis.AxisDependency.Left
                set2.setColor(UIColor.MKColor.Indigo)
                set2.lineWidth = 2.0
                set2.circleRadius = 3.0
                set2.fillAlpha = 65/225
                set2.fillColor = UIColor.MKColor.Indigo
                set2.highlightColor = UIColor.whiteColor()
                set2.drawCircleHoleEnabled = false
                set2.valueTextColor = UIColor.whiteColor()
                set2.valueFont = UIFont.systemFontOfSize(9)
                
                var dataSets = [ChartDataSet]()
                dataSets.append(set1)
                dataSets.append(set2)
                //dataSets.append(weekendSet)
                
                let data = CombinedChartData(xVals: xVals)
                data.lineData = LineChartData(xVals: xVals, dataSets: dataSets)
                data.barData = BarChartData(xVals: xVals, dataSet: weekendSet)
                //let data = LineChartData(xVals: xVals, dataSets: dataSets)
                //data.setValueTextColor(UIColor.whiteColor())
                //data.setValueFont(UIFont.systemFontOfSize(9))
                self.empChartview.data = data
            } else if y1Vals.count == 0 {
                empChartview.clear()
            } else if y2Vals.count == 0 && y1Vals.count != 0 {
                var chartName = ""
                if flag == true {
                    chartName = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - In Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                } else {
                    chartName = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - Out Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                }
                
                let set1 = LineChartDataSet(yVals: y1Vals, label: chartName)
                set1.axisDependency = ChartYAxis.AxisDependency.Left
                set1.setColor(UIColor.MKColor.Green)
                set1.lineWidth = 2.0
                set1.circleRadius = 3.0
                set1.fillAlpha = 65/225
                set1.fillColor = UIColor.MKColor.Green
                set1.highlightColor = UIColor.whiteColor()
                set1.drawCircleHoleEnabled = false
                set1.valueTextColor = UIColor.whiteColor()
                set1.valueFont = UIFont.systemFontOfSize(9)
                
                var dataSets = [ChartDataSet]()
                dataSets.append(set1)
                //dataSets.append(weekendSet)
                
                let data = CombinedChartData(xVals: xVals)
                data.lineData = LineChartData(xVals: xVals, dataSets: dataSets)
                data.barData = BarChartData(xVals: xVals, dataSet: weekendSet)
                //let data = LineChartData(xVals: xVals, dataSets: dataSets)
                //data.setValueTextColor(UIColor.whiteColor())
                //data.setValueFont(UIFont.systemFontOfSize(9))
                empChartview.data = data
            }
        } else {
            if yVals.count != 0 {
                var chartName = ""
                if flag == true {
                    chartName = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - In Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                } else {
                    chartName = "\(self.getMonthString(self.pickedMonth)), \(self.pickedYear) - Out Record of \(self.pickedEmp.FirstName) \(self.pickedEmp.LastName)"
                }
                
                let set1 = LineChartDataSet(yVals: yVals, label: chartName)
                set1.axisDependency = ChartYAxis.AxisDependency.Left
                set1.setColor(UIColor.MKColor.Green)
                set1.lineWidth = 2.0
                set1.circleRadius = 3.0
                set1.fillAlpha = 65/225
                set1.fillColor = UIColor.MKColor.Green
                set1.highlightColor = UIColor.whiteColor()
                set1.drawCircleHoleEnabled = false
                set1.valueTextColor = UIColor.whiteColor()
                set1.valueFont = UIFont.systemFontOfSize(9)
                
                var dataSets = [ChartDataSet]()
                dataSets.append(set1)
                //dataSets.append(weekendSet)
                
                let data = CombinedChartData(xVals: xVals)
                data.lineData = LineChartData(xVals: xVals, dataSets: dataSets)
                data.barData = BarChartData(xVals: xVals, dataSet: weekendSet)
                //let data = LineChartData(xVals: xVals, dataSets: dataSets)
                //data.setValueTextColor(UIColor.whiteColor())
                //data.setValueFont(UIFont.systemFontOfSize(9))
                empChartview.data = data
            } else {
                empChartview.clear()
            }
        }
    }
    
    func changeTRObjectToDouble(timeRecord: String) -> Double {
        let array = timeRecord.characters.split {$0 == ":"}.map { String($0) }
        let hour = Double(array[0])
        let minute = Double(array[1])
        let hourPercent = hour! + minute!/60
        return hourPercent
    }
    
    func getDayOfWeek(today:String)->Int {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return weekDay
    }
}

extension KPIEmployeePickViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension KPIEmployeePickViewController: PickMonthViewControllerDelegate {
    func sendMonthValue(value: Int) {
        self.pickedMonth = value
        monthPickerBT.setTitle(String(self.pickedMonth), forState: .Normal)
        queryTimeRecords()
    }
}

extension KPIEmployeePickViewController: PickYearViewControllerDelegate {
    func sendYearValue(value: Int) {
        self.pickedYear = value
        yearPickerBT.setTitle(String(self.pickedYear), forState: .Normal)
        queryTimeRecords()
    }
}

extension KPIEmployeePickViewController: QLPreviewControllerDataSource,QLPreviewControllerDelegate {
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