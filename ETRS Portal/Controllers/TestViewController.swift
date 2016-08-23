//
//  TestViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/23/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import QuickLook

class TestViewController: UIViewController, QLPreviewControllerDataSource,QLPreviewControllerDelegate {
    
    var timeRecords = [TimeRecording]()
    let fileName = "sample.csv"

    override func viewDidLoad() {
        super.viewDidLoad()
        queryParseMethod()
        //createSampleData()
        // Do any additional setup after loading the view.
    }

    func createSampleData() {
        for index in 1...20 {
            let timeRecording = TimeRecording()
            timeRecording.Employee = "newEmployeeWithBeaconDecryp@gmail.com"
            let startHour = 7 + arc4random_uniform(3)
            let startMinute = arc4random_uniform(59)
            timeRecording.StartTimeRecord = "\(startHour):\(startMinute)"
            let endHour = 16 + arc4random_uniform(4)
            let endMinute = arc4random_uniform(59)
            timeRecording.EndTimeRecord = "\(endHour):\(endMinute)"
            timeRecording.Group = "Employee"
            timeRecording.Day = index
            let month = 1
            timeRecording.Month = month
            timeRecording.Year = 2016
            
            //Set ACL for object Time Record
            let timeRecordACL = PFACL()
            //Read ACL
            timeRecordACL.setPublicReadAccess(false)
            timeRecordACL.setReadAccess(true, forUserId: "CvfMaxNMiU")
            timeRecordACL.setReadAccess(true, forRoleWithName: "Admin")
            timeRecordACL.setReadAccess(true, forRoleWithName: "Manager")
            //Write ACL
            timeRecordACL.setPublicWriteAccess(false)
            timeRecordACL.setWriteAccess(false, forUserId: "CvfMaxNMiU")
            timeRecordACL.setWriteAccess(true, forRoleWithName: "Admin")
            timeRecordACL.setWriteAccess(false, forRoleWithName: "Manager")
            timeRecording.ACL = timeRecordACL
            
            let daymonthyear = "\(index)-\(month)-2015"
            let integrityData = "PortalDevice_B9407F30-F5F8-466E-AFF9-25556B57FE6D_38335_23699_employeewithbeacon@gmail.com_Employee_\(daymonthyear)_\(timeRecording.StartTimeRecord)_In_\(timeRecording.EndTimeRecord)_Out"
            let weekday = getDayOfWeek("2015-\(month)-\(index)")
            if weekday == 1 || weekday == 7 {
                
            } else {
                timeRecording.Integrity = makeIntegrityData(integrityData)
                timeRecording.saveEventually()
            }
            //
        }
        
    }
    func makeIntegrityData(data: String) -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let encryptedData = data.aesEncrypt(key, iv: iv)
        //let decryptedData = encryptedData.aesDecrypt(key, iv: iv)
        //print(decryptedData)
        return encryptedData
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
    
    func queryParseMethod() {
        let query = TimeRecording.query()
        query?.whereKey("Employee", equalTo: "newemployeewithbeacon@gmail.com")
        query?.whereKey("Month", equalTo: 1)
        query?.orderByAscending("Day")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.timeRecords = objects as! [TimeRecording]
            print(self.timeRecords)
            self.createFile()
        })
    }
    
    func createFile() {
        let header = "No,Employee,Date,Start,End"
        var body = ""
        var number = 1
        for index in 0...self.timeRecords.count-1 {
            let employee = timeRecords[index].Employee!
            let date = "\(timeRecords[index].Day)/\(timeRecords[index].Month)/\(timeRecords[index].Year)"
            let start = timeRecords[index].StartTimeRecord!
            var endTime = ""
            if let end = timeRecords[index].EndTimeRecord {
                endTime = end
            }
            body += "\n\(number),\(employee),\(date),\(start),\(endTime)"
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
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        print("Getting item")
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let path = documentsPath.stringByAppendingPathComponent(fileName)
        let doc = NSURL(fileURLWithPath: path)
        return doc
    }
}
