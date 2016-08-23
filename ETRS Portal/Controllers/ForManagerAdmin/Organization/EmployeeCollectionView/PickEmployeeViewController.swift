//
//  PickEmployeeViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/30/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import CryptoSwift

class PickEmployeeViewController: UIViewController {

    @IBOutlet weak var avatarImg: PFImageView!
    @IBOutlet weak var employeeFullname: UILabel!
    @IBOutlet weak var employeeGroup: UILabel!
    @IBOutlet weak var employeeEmail: UILabel!
    @IBOutlet weak var employeeEmailVerified: UILabel!
    //@IBOutlet weak var employeeSupervisor: UILabel!
    //@IBOutlet weak var employeeDevice: UILabel!
    //@IBOutlet weak var employeeBeacon: UILabel!
    @IBOutlet weak var employeeSupervisorBT: MKButton!
    @IBOutlet weak var employeeBeaconBT: MKButton!
    @IBOutlet weak var employeeDeviceBT: MKButton!
    
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    var employeeObject:User?
    var image:UIImage?
    
    var beacon: Beacon?
    var manager: User?
    var device: String?
    
    override func awakeFromNib() {
        self.contentSizeInPopup = CGSizeMake(500, 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = employeeObject!.FirstName + " " + employeeObject!.LastName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: checkLanguage("save"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveBTTouch"))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.MKColor.Red
        configAvatar()
        configLabels()
        provideTextForLabels()
        configButtons()
    }
    
    func configAvatar() {
        avatarImg.layer.masksToBounds = true
        avatarImg.layer.cornerRadius = 50
        avatarImg.image = image //UIImage(named: "Avatar")
        //avatarImg.file = employeeObject!.Avatar
        //avatarImg.loadInBackground()
    }
    
    func configLabels() {
        employeeFullname.backgroundColor = UIColor.clearColor()
        employeeFullname.textColor = UIColor.MKColor.Blue
        employeeFullname.layer.masksToBounds = true
        //employeeFullname.layer.borderWidth = 0.5
        //employeeFullname.layer.cornerRadius = 3
        //employeeFullname.layer.borderColor = UIColor.MKColor.Blue.CGColor
        employeeFullname.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        employeeFullname.textAlignment = .Center
        
        employeeGroup.backgroundColor = UIColor.clearColor()
        employeeGroup.textColor = UIColor.MKColor.Blue
        employeeGroup.layer.masksToBounds = true
        //employeeGroup.layer.borderWidth = 0.5
        //employeeGroup.layer.cornerRadius = 3
        //employeeGroup.layer.borderColor = UIColor.MKColor.Blue.CGColor
        employeeGroup.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        employeeGroup.textAlignment = .Center
        
        employeeEmail.backgroundColor = UIColor.clearColor()
        employeeEmail.textColor = UIColor.MKColor.Blue
        employeeEmail.layer.masksToBounds = true
        //employeeEmail.layer.borderWidth = 0.5
        //employeeEmail.layer.cornerRadius = 3
        //employeeEmail.layer.borderColor = UIColor.MKColor.Blue.CGColor
        employeeEmail.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        employeeEmail.textAlignment = .Center
        
        employeeEmailVerified.backgroundColor = UIColor.clearColor()
        employeeEmailVerified.textColor = UIColor.MKColor.Blue
        employeeEmailVerified.layer.masksToBounds = true
        //employeeEmailVerified.layer.borderWidth = 0.5
        //employeeEmailVerified.layer.cornerRadius = 3
        //employeeEmailVerified.layer.borderColor = UIColor.MKColor.Blue.CGColor
        employeeEmailVerified.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        employeeEmailVerified.textAlignment = .Center
        
        //employeeSupervisor.backgroundColor = UIColor.clearColor()
        //employeeSupervisor.textColor = UIColor.MKColor.Blue
        //employeeSupervisor.layer.masksToBounds = true
        //employeeSupervisor.layer.borderWidth = 0.5
        //employeeSupervisor.layer.cornerRadius = 3
        //employeeSupervisor.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //employeeSupervisor.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        //employeeSupervisor.textAlignment = .Center
        
        //employeeDevice.backgroundColor = UIColor.clearColor()
        //employeeDevice.textColor = UIColor.MKColor.Blue
        //employeeDevice.layer.masksToBounds = true
        //employeeDevice.layer.borderWidth = 0.5
        //employeeDevice.layer.cornerRadius = 3
        //employeeDevice.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //employeeDevice.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        //employeeDevice.textAlignment = .Center
        
        //employeeBeacon.backgroundColor = UIColor.clearColor()
        //employeeBeacon.textColor = UIColor.MKColor.Blue
        //employeeBeacon.layer.masksToBounds = true
        //employeeBeacon.layer.borderWidth = 0.5
        //employeeBeacon.layer.cornerRadius = 3
        //employeeBeacon.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //employeeBeacon.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        //employeeBeacon.textAlignment = .Center
    }
    
    func provideTextForLabels() {
        employeeFullname.text = employeeObject!.FirstName + " " + employeeObject!.LastName
        
        employeeEmail.text = employeeObject!.email
        var emailVerified = ""
        if employeeObject!.emailVerified == true {
            emailVerified = checkLanguage("email_status_true")
        } else {
            emailVerified = checkLanguage("email_status_false")
        }
        employeeEmailVerified.text = checkLanguage("email_status") + ": " + emailVerified
        switch employeeObject!.Group {
        case "Employee":
            employeeGroup.text = checkLanguage("employee")
            if let supervisorName = employeeObject?.Supervisor {
                //employeeSupervisor.text = "Supervisor: " + supervisorName.FirstName + " " + supervisorName.LastName
                let title = checkLanguage("supervisor") + ": " + supervisorName.FirstName + " " + supervisorName.LastName
                employeeSupervisorBT.setTitle(title, forState: .Normal)
            } else {
                //employeeSupervisor.text = "Supervisor: None"
                let title = checkLanguage("supervisor") + ": None"
                employeeSupervisorBT.setTitle(title, forState: .Normal)
            }
            if employeeObject!.Device == "None" {
                //employeeDevice.text = "Device: None"
                let title = checkLanguage("device") + ": None"
                employeeDeviceBT.setTitle(title, forState: .Normal)
                employeeDeviceBT.enabled = false
            } else {
                let title = checkLanguage("device") + ": " + decryptDeviceInfo()
                //employeeDevice.text = title
                employeeDeviceBT.setTitle(title, forState: .Normal)
            }
            if employeeObject!.Beacon == "None" {
                //employeeBeacon.text = "Beacon: None"
                employeeBeaconBT.setTitle("Beacon: None", forState: .Normal)
                //employeeBeaconBT.enabled = false
            } else {
                let title = "Beacon: " + decryptBeaconInfo()
                //employeeBeacon.text = "Beacon: " + decryptBeaconInfo()
                employeeBeaconBT.setTitle(title, forState: .Normal)
            }
        case "Manager":
            employeeGroup.text = checkLanguage("manager")
        case "Admin":
            employeeGroup.text = checkLanguage("admin")
        default:
            //employeeSupervisor.removeFromSuperview()
            employeeSupervisorBT.removeFromSuperview()
            //employeeDevice.removeFromSuperview()
            employeeDeviceBT.removeFromSuperview()
            //employeeBeacon.removeFromSuperview()
            employeeBeaconBT.removeFromSuperview()
        }
    }
    
    func configButtons() {
        employeeDeviceBT.backgroundColor = UIColor.MKColor.Red
        employeeDeviceBT.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        employeeDeviceBT.tintColor = UIColor.MKColor.Blue
        employeeDeviceBT.layer.masksToBounds = true
        employeeDeviceBT.layer.cornerRadius = 3
        employeeDeviceBT.layer.borderWidth = 0.5
        employeeDeviceBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        
        employeeBeaconBT.backgroundColor = UIColor.MKColor.Red
        employeeBeaconBT.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        employeeBeaconBT.tintColor = UIColor.MKColor.Blue
        employeeBeaconBT.layer.masksToBounds = true
        employeeBeaconBT.layer.cornerRadius = 3
        employeeBeaconBT.layer.borderWidth = 0.5
        employeeBeaconBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        
        employeeSupervisorBT.backgroundColor = UIColor.MKColor.Red
        employeeSupervisorBT.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        employeeSupervisorBT.tintColor = UIColor.MKColor.Blue
        employeeSupervisorBT.layer.masksToBounds = true
        employeeSupervisorBT.layer.cornerRadius = 3
        employeeSupervisorBT.layer.borderWidth = 0.5
        employeeSupervisorBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
    }
    
    func assignBeaconBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("BeaconQueryVC") as! BeaconQueryTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200 , 200)
        popover!.delegate = self
        popover!.sourceView = employeeBeaconBT
        popover!.sourceRect = CGRectMake(employeeBeaconBT.frame.width,employeeBeaconBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func assignSupervisorBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerQueryVC") as! ManagerQueryTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200, 200)
        popover!.delegate = self
        popover!.sourceView = employeeSupervisorBT
        popover!.sourceRect = CGRectMake(employeeSupervisorBT.frame.width,employeeSupervisorBT.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
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
    
    func decryptBeaconInfo() -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let decryptedBeaconInfo = employeeObject!.Beacon.aesDecrypt(key, iv: iv)
        var componentArray = decryptedBeaconInfo.characters.split {$0 == "_"}.map { String($0) }
        let major = componentArray[1]
        let minor = componentArray[2]
        return "\(major)-\(minor)"
    }
    
    func decryptDeviceInfo() -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let decryptedDeviceInfo = employeeObject!.Device.aesDecrypt(key, iv: iv)
        return decryptedDeviceInfo
    }
    
    func createEncryptedBeacon(beaconInfo: String) -> String {
        let key = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let iv = [0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10,0x90,0x30,0x20,0x20,0x00,0x10] as [UInt8]
        let encryptedBeacon = beaconInfo.aesEncrypt(key, iv: iv)
        //print(encryptedBeacon)
        //let decryptedBeacon = encryptedBeacon.aesDecrypt(key, iv: iv)
        //print(decryptedBeacon)
        return encryptedBeacon
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
    
    @IBAction func empBeaconBTEvent(sender: AnyObject) {
        self.assignBeaconBTTouch()
    }
    
    @IBAction func empSupervisorBTEvent(sender: AnyObject) {
        self.assignSupervisorBTTouch()
    }
    
    @IBAction func empDeviceBTEvent(sender: AnyObject) {
        let alert = UIAlertController(title: self.checkLanguage("warning"), message: self.checkLanguage("reset_employee_device"), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: self.checkLanguage("ok"), style: .Default, handler: { (alert) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //
                self.employeeDeviceBT.alpha = 0
                self.employeeDeviceBT.enabled = false
                }, completion: { (finished) -> Void in
                    //
                    self.device = "None"
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        //
                        self.employeeDeviceBT.backgroundColor = UIColor.clearColor()
                        self.employeeDeviceBT.layer.borderWidth = 0.5
                        let title = self.checkLanguage("device") + ": None"
                        self.employeeDeviceBT.setTitle(title, forState: UIControlState.Normal)
                        self.employeeDeviceBT.setTitleColor(UIColor.MKColor.Blue, forState: .Normal)
                        self.employeeDeviceBT.alpha = 1
                        self.employeeDeviceBT.enabled = true
                    })
            })
        }))
        alert.addAction(UIAlertAction(title: self.checkLanguage("cancel"), style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveBTTouch() {
        print("Saving Employee")
        self.showIndicatorActivity()
        var beaconInfo = "No"
        var device = "No"
        if let beacon = self.beacon {
            beaconInfo = createEncryptedBeacon("\(beacon.UUID)_\(beacon.Major)_\(beacon.Minor)")
        }
        if let _ = self.device {
            device = self.device!
        }
        
        let funcParameters = ["username":String(employeeObject!.username!),"beaconInfo":beaconInfo,"device":device]
        print("Resetting")
        PFCloud.callFunctionInBackground("resetUser", withParameters: funcParameters , block: { (response, error) -> Void in
            if error === nil {
                print("Successful Reset for employee: \(self.employeeObject!.username!)")
                if let manager = self.manager {
                    let funcParameters = ["username":String(self.employeeObject!.username!),"supervisorId":manager.objectId!]
                    print("Assigning Supervisor")
                    PFCloud.callFunctionInBackground("changeSupervisor", withParameters: funcParameters , block: { (response, error) -> Void in
                        if error === nil {
                            print("Successful Assign Supervisor for employee: \(self.employeeObject!.username!)")
                        } else {
                            print(error)
                            print("Failed Assign Supervisor for employee: \(self.employeeObject!.username!)")
                        }
                    })
                }
            } else {
                print(error)
                print("Failed Reset for employee: \(self.employeeObject!.username!)")
            }
            self.closeIndicatorActivity()
        })
    }
    
}

extension PickEmployeeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension PickEmployeeViewController: BeaconQueryTableViewControllerDelegate {
    func updateAssignButtonToChosenBeacon(beacon: Beacon) {
        self.beacon = beacon
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.employeeBeaconBT.alpha = 0
            self.employeeBeaconBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.employeeBeaconBT.backgroundColor = UIColor.clearColor()
                    self.employeeBeaconBT.layer.borderWidth = 0.5
                    let major = beacon["Major"] as! String
                    let minor = beacon["Minor"] as! String
                    self.employeeBeaconBT.setTitle("Beacon: \(major)-\(minor)", forState: UIControlState.Normal)
                    self.employeeBeaconBT.setTitleColor(UIColor.MKColor.Blue, forState: .Normal)
                    self.employeeBeaconBT.alpha = 1
                    self.employeeBeaconBT.enabled = true
                })
        })
    }
}

extension PickEmployeeViewController: ManagerQueryTableViewControllerDelegate {
    func updateAssignButtonToChosenManager(manager: User) {
        self.manager = manager
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.employeeSupervisorBT.alpha = 0
            self.employeeSupervisorBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.employeeSupervisorBT.backgroundColor = UIColor.clearColor()
                    self.employeeSupervisorBT.layer.borderWidth = 0.5
                    let title = self.checkLanguage("supervisor") + ": " + manager.FirstName + " " + manager.LastName
                    self.employeeSupervisorBT.setTitle(title, forState: UIControlState.Normal)
                    self.employeeSupervisorBT.setTitleColor(UIColor.MKColor.Blue, forState: .Normal)
                    self.employeeSupervisorBT.alpha = 1
                    self.employeeSupervisorBT.enabled = true
                })
        })
    }
}
