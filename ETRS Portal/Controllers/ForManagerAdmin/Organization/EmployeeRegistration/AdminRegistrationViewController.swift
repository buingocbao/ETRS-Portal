//
//  AdminRegistrationViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/11/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import CryptoSwift

class AdminRegistrationViewController: UIViewController {
    
    var stackLeftHeight: CGFloat = 0
    var mainLB: UILabel?
    var accountTF: MKTextField?
    var passwordTF: MKTextField?
    var confirmPassTF: MKTextField?
    var firstNameTF: MKTextField?
    var lastNameTF: MKTextField?
    var checkmark: CheckmarkSegmentedControl?
    var assignSupervisorBT: MKButton?
    var assignBeaconBT: MKButton?
    var musicFileBT: MKButton?
    var commitBT: MKButton?
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    var backButton: MKButton = MKButton()
    
    //This variable is to get Manager from popover
    var manager:User?
    var beacon:Beacon?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configBackButton()
        createLabels()
        createTextFields()
        createButtons()
    }
    
    // MARK : Create UI
    func configUI() {
        self.view.backgroundColor = UIColor.MKColor.Blue
    }
    
    func configBackButton() {
        // Back Button
        backButton.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
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
    
    func createLabels() {
        // Main label
        let mainLB = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        self.stackLeftHeight = mainLB.frame.height
        mainLB.center = self.view.center
        mainLB.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        mainLB.textColor = UIColor.whiteColor()
        mainLB.textAlignment = .Center
        mainLB.text = checkLanguage("create_employee_mainLB")
        self.view.addSubview(mainLB)
        mainLB.translatesAutoresizingMaskIntoConstraints = false
        let topConstraintMainLB = NSLayoutConstraint(item: mainLB, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
        let xCenterConstraintMainLB = NSLayoutConstraint(item: mainLB, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintMainLB = NSLayoutConstraint(item: mainLB, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width)
        let heightConstraintMainLB = NSLayoutConstraint(item: mainLB, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35)
        view.addConstraints([topConstraintMainLB, xCenterConstraintMainLB, widthConstraintMainLB, heightConstraintMainLB])
        self.mainLB = mainLB
    }
    
    func createTextFields() {
        // MARK : The left column / Text Fields
        // Account Text Field
        let accountTF = MKTextField(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40))
        self.stackLeftHeight = accountTF.frame.origin.y + accountTF.frame.height
        accountTF.layer.borderColor = UIColor.clearColor().CGColor
        accountTF.floatingPlaceholderEnabled = true
        accountTF.placeholder = checkLanguage("account")
        accountTF.tintColor = UIColor.whiteColor()
        accountTF.textColor = UIColor.whiteColor()
        accountTF.rippleLocation = .TapLocation
        accountTF.cornerRadius = 0
        accountTF.bottomBorderEnabled = true
        accountTF.borderStyle = UITextBorderStyle.None
        accountTF.minimumFontSize = 17
        accountTF.font = UIFont(name: "HelveticaNeue", size: 30)
        accountTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        accountTF.keyboardType = UIKeyboardType.EmailAddress
        accountTF.autocapitalizationType = .None
        accountTF.delegate = self
        self.view.addSubview(accountTF)
        self.accountTF = accountTF
        
        // Password Text Field
        let passwordTF = MKTextField(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40))
        self.stackLeftHeight = passwordTF.frame.origin.y + passwordTF.frame.height
        passwordTF.layer.borderColor = UIColor.clearColor().CGColor
        passwordTF.floatingPlaceholderEnabled = true
        passwordTF.placeholder = checkLanguage("password")
        passwordTF.tintColor = UIColor.whiteColor()
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.rippleLocation = .TapLocation
        passwordTF.cornerRadius = 0
        passwordTF.bottomBorderEnabled = true
        passwordTF.borderStyle = UITextBorderStyle.None
        passwordTF.minimumFontSize = 17
        passwordTF.font = UIFont(name: "HelveticaNeue", size: 30)
        passwordTF.secureTextEntry = true
        passwordTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        passwordTF.autocapitalizationType = .None
        passwordTF.delegate = self
        self.view.addSubview(passwordTF)
        self.passwordTF = passwordTF
        
        // Confirm Password Text Field
        let confirmPassTF = MKTextField(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40))
        self.stackLeftHeight = confirmPassTF.frame.origin.y + confirmPassTF.frame.height
        confirmPassTF.layer.borderColor = UIColor.clearColor().CGColor
        confirmPassTF.floatingPlaceholderEnabled = true
        confirmPassTF.placeholder = checkLanguage("confirmPassword")
        confirmPassTF.tintColor = UIColor.whiteColor()
        confirmPassTF.textColor = UIColor.whiteColor()
        confirmPassTF.rippleLocation = .TapLocation
        confirmPassTF.cornerRadius = 0
        confirmPassTF.bottomBorderEnabled = true
        confirmPassTF.borderStyle = UITextBorderStyle.None
        confirmPassTF.minimumFontSize = 17
        confirmPassTF.font = UIFont(name: "HelveticaNeue", size: 30)
        confirmPassTF.secureTextEntry = true
        confirmPassTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        confirmPassTF.autocapitalizationType = .None
        confirmPassTF.delegate = self
        self.view.addSubview(confirmPassTF)
        self.confirmPassTF = confirmPassTF

        // First Name Text Field
        let firstNameTF = MKTextField(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40))
        self.stackLeftHeight = firstNameTF.frame.origin.y + firstNameTF.frame.height
        firstNameTF.layer.borderColor = UIColor.clearColor().CGColor
        firstNameTF.floatingPlaceholderEnabled = true
        firstNameTF.placeholder = checkLanguage("firstName")
        firstNameTF.tintColor = UIColor.whiteColor()
        firstNameTF.textColor = UIColor.whiteColor()
        firstNameTF.rippleLocation = .TapLocation
        firstNameTF.cornerRadius = 0
        firstNameTF.bottomBorderEnabled = true
        firstNameTF.borderStyle = UITextBorderStyle.None
        firstNameTF.minimumFontSize = 17
        firstNameTF.font = UIFont(name: "HelveticaNeue", size: 30)
        firstNameTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        firstNameTF.delegate = self
        self.view.addSubview(firstNameTF)
        self.firstNameTF = firstNameTF
        
        // Last Name Text Field
        let lastNameTF = MKTextField(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40))
        self.stackLeftHeight = lastNameTF.frame.origin.y + lastNameTF.frame.height
        lastNameTF.layer.borderColor = UIColor.clearColor().CGColor
        lastNameTF.floatingPlaceholderEnabled = true
        lastNameTF.placeholder = checkLanguage("lastName")
        lastNameTF.tintColor = UIColor.whiteColor()
        lastNameTF.textColor = UIColor.whiteColor()
        lastNameTF.rippleLocation = .TapLocation
        lastNameTF.cornerRadius = 0
        lastNameTF.bottomBorderEnabled = true
        lastNameTF.borderStyle = UITextBorderStyle.None
        lastNameTF.minimumFontSize = 17
        lastNameTF.font = UIFont(name: "HelveticaNeue", size: 30)
        lastNameTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        lastNameTF.delegate = self
        self.view.addSubview(lastNameTF)
        self.lastNameTF = lastNameTF
        
        // Group segment
        let checkmark: CheckmarkSegmentedControl = CheckmarkSegmentedControl(frame: CGRect(x: 0, y: stackLeftHeight+20, width: self.view.frame.width/2-20, height: 80))
        self.stackLeftHeight = checkmark.frame.origin.y + checkmark.frame.height
        checkmark.backgroundColor = UIColor.MKColor.Blue
        checkmark.titleColor = UIColor.whiteColor()
        checkmark.options = [
            CheckmarkOption(title: checkLanguage("employee"), borderColor: UIColor.whiteColor(), fillColor: UIColor.MKColor.Green),
            CheckmarkOption(title: checkLanguage("manager"), borderColor: UIColor.whiteColor(), fillColor: UIColor.MKColor.Orange),
            CheckmarkOption(title: checkLanguage("admin"), borderColor: UIColor.whiteColor(), fillColor: UIColor.MKColor.Red)
        ]
        checkmark.addTarget(self, action: "optionSelected", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(checkmark)
        self.checkmark = checkmark
    }
    
    func optionSelected() {
        print("Selected option: \(self.checkmark!.options[checkmark!.selectedIndex])")
        doAnimating(checkmark!.selectedIndex)
    }
    
    func doAnimating(checkMarkIndex: Int) {
        switch checkMarkIndex {
        case 0:
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //
                self.musicFileBT?.alpha = 0
                self.musicFileBT?.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.assignSupervisorBT?.alpha = 1
                    self.assignSupervisorBT?.enabled = true
                    self.assignBeaconBT?.alpha = 1
                    self.assignBeaconBT?.enabled = true
                })
            })
        case 1:
            //Fade buttons
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //
                self.assignSupervisorBT?.alpha = 0
                self.assignSupervisorBT?.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.musicFileBT?.alpha = 1
                    self.musicFileBT?.enabled = true
                    self.assignBeaconBT?.alpha = 1
                    self.assignBeaconBT?.enabled = true
                })
            })
            
        case 2:
            //Fade buttons
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //
                self.assignSupervisorBT?.alpha = 0
                self.assignSupervisorBT?.enabled = false
                self.musicFileBT?.alpha = 0
                self.musicFileBT?.enabled = false
                self.assignBeaconBT?.alpha = 0
                self.assignBeaconBT?.enabled = false
            }, completion: { (finished) -> Void in
                //
            })
        default:
            return
        }
    }
    
    func createButtons() {
        // Assign Manager Button
        let assignSupervisorBT = MKButton()
        assignSupervisorBT.frame = CGRect(x: 0, y: self.stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40)
        self.stackLeftHeight = assignSupervisorBT.frame.origin.y + assignSupervisorBT.frame.height
        assignSupervisorBT.layer.shadowOpacity = 0.55
        assignSupervisorBT.layer.shadowRadius = 5.0
        assignSupervisorBT.layer.shadowColor = UIColor.blackColor().CGColor
        assignSupervisorBT.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        assignSupervisorBT.backgroundColor = UIColor.MKColor.Green
        assignSupervisorBT.setTitle(self.checkLanguage("assign_supervisor"), forState: UIControlState.Normal)
        assignSupervisorBT.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        assignSupervisorBT.addTarget(self, action: "assignSupervisorBTTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(assignSupervisorBT)
        self.assignSupervisorBT = assignSupervisorBT
        //Checkmark is Employee in default -> make it visible
        self.assignSupervisorBT?.alpha = 1
        self.assignSupervisorBT?.enabled = true
        
        // Assign Beacon Button
        let assignBeaconBT = MKButton()
        assignBeaconBT.frame = CGRect(x: 0, y: self.stackLeftHeight+20, width: self.view.frame.width/2-20, height: 40)
        self.stackLeftHeight = assignBeaconBT.frame.origin.y + assignBeaconBT.frame.height
        assignBeaconBT.layer.shadowOpacity = 0.55
        assignBeaconBT.layer.shadowRadius = 5.0
        assignBeaconBT.layer.shadowColor = UIColor.blackColor().CGColor
        assignBeaconBT.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        assignBeaconBT.backgroundColor = UIColor.MKColor.Green
        assignBeaconBT.setTitle(self.checkLanguage("assign_beacon"), forState: UIControlState.Normal)
        assignBeaconBT.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        assignBeaconBT.addTarget(self, action: "assignBeaconBTTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(assignBeaconBT)
        self.assignBeaconBT = assignBeaconBT
        //Checkmark is Employee in default -> make it visible
        self.assignBeaconBT?.alpha = 1
        self.assignBeaconBT?.enabled = true
        
        // Commit Button
        let commitBT = MKButton()
        commitBT.frame = CGRect(x: 0, y: self.stackLeftHeight + 20, width: self.view.frame.width/2-20, height: 40)
        commitBT.layer.shadowOpacity = 0.55
        commitBT.layer.shadowRadius = 5.0
        commitBT.layer.shadowColor = UIColor.blackColor().CGColor
        commitBT.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        commitBT.backgroundColor = UIColor.MKColor.Red
        commitBT.setTitle(self.checkLanguage("commit_button"), forState: UIControlState.Normal)
        commitBT.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        commitBT.addTarget(self, action: "commitBTTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(commitBT)
        self.commitBT = commitBT
        //Hide this button at first
        self.commitBT?.alpha = 0
        self.commitBT?.enabled = false
    }
    
    func assignSupervisorBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ManagerQueryVC") as! ManagerQueryTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(300 , 300)
        popover!.delegate = self
        popover!.sourceView = assignSupervisorBT
        popover!.sourceRect = CGRectMake(assignSupervisorBT!.frame.width,assignSupervisorBT!.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func assignBeaconBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("BeaconQueryVC") as! BeaconQueryTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(300 , 300)
        popover!.delegate = self
        popover!.sourceView = assignBeaconBT
        popover!.sourceRect = CGRectMake(assignBeaconBT!.frame.width,assignBeaconBT!.frame.height/2,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func commitBTTouch() {
        signUp()
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
    
    // MARK: Do sign up function
    func signUp() {
        self.showIndicatorActivity()
        switch checkmark!.selectedIndex {
        case 0:
            self.doSignUp("Employee")
        case 1:
            //Check that only Admin can create an admin
            if let currentUser = PFUser.currentUser() as? User {
                if currentUser.Group == "Admin" {
                    self.doSignUp("Manager")
                } else {
                    print("Cannot create an Manager if creator is not an Admin")
                    showAlert(false, error: nil)
                }
            }
        case 2:
            //Check that only Admin can create an admin
            if let currentUser = PFUser.currentUser() as? User {
                if currentUser.Group == "Admin" {
                    self.doSignUp("Admin")
                } else {
                    print("Cannot create an Admin if creator is not an Admin")
                    showAlert(false, error: nil)
                }
            }
        default:
            return
        }
    }
    
    func doSignUp(group: String) {
        print("Sign Up \(group)")
        //Get all information
        let username = self.accountTF!.text
        let password = self.passwordTF!.text
        let firstName = self.firstNameTF!.text
        let lastName = self.lastNameTF!.text
        let supervisorId = manager!.objectId
        let beaconInfo = "\(self.beacon!.UUID)_\(self.beacon!.Major)_\(self.beacon!.Minor)"
        let beacon = createEncryptedBeacon(beaconInfo)
        let funcParameters = ["email":username!,
            "password":password!,
            "firstName":firstName!,
            "lastName":lastName!,
            "group":group,
            "supervisorId":supervisorId!,
            "beacon":beacon]
        print("Start sign up")
        PFCloud.callFunctionInBackground("createUser", withParameters: funcParameters , block: { (response, error) -> Void in
            if error === nil {
                print("Successful Sign up for employee: \(username)")
                self.doAssignRole(username!)
            } else {
                print(error)
                self.showAlert(false, error: error)
                print("Failed Sign up for employee: \(username)")
            }
        })
    }
    
    func doAssignRole(username: String) {
        print("Start assign role for: \(username)")
        let userQuery = User.query()
        userQuery!.whereKey("username", equalTo: username)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            userQuery!.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                if error == nil {
                    print("Find user successfully")
                    if let user = object as? User {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //Query role
                            let queryRole = PFRole.query() // You need to get role object
                            queryRole!.whereKey("name", equalTo:user.Group)
                            queryRole!.getFirstObjectInBackgroundWithBlock() {
                                (roleObject, error) -> Void in
                                if error == nil {
                                    print("Find role sucessfully")
                                    // Assign user to group role
                                    let roleToAddUser = roleObject as! PFRole
                                    roleToAddUser.users.addObject(user)
                                    roleToAddUser.saveInBackground()
                                    print("Assign successfully")
                                    self.showAlert(true, error: nil)
                                } else {
                                    print("Assign failed with error: \(error)")
                                    self.showAlert(true, error: nil)
                                }
                            }
                        })
                    }
                } else {
                    print("Find user failed")
                    self.showAlert(false, error: nil)
                }
            })

        })
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
    
    func showAlert(isSucceed: Bool, error: NSError?) {
        self.closeIndicatorActivity()
        if isSucceed {
            //Also show successful view
            let alert = UIAlertController (title: checkLanguage("signUp_success"), message: checkLanguage("signUp_success_mess") + accountTF!.text! + ".", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            //Also clear all textFields
            accountTF?.text = ""
            passwordTF?.text = ""
            confirmPassTF?.text = ""
            firstNameTF?.text = ""
            lastNameTF?.text = ""
        } else {
            //Show error
            let alert = UIAlertView(title: checkLanguage("error"), message: checkLanguage("error_signup") + ": \(error)", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    // MARK : Other methods
    func validate(value: String) -> Bool {
        let emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRule)
        return test.evaluateWithObject(value)
    }
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func doTestAllInformationIsFilled() {
        if accountTF?.text != "" && passwordTF?.text != "" && confirmPassTF?.text != "" && firstNameTF?.text != "" && lastNameTF?.text != "" {
            if validate(accountTF!.text!) && confirmPassTF?.text == passwordTF?.text && self.manager != nil && self.beacon != nil {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.commitBT?.alpha = 1
                    self.commitBT?.enabled = true
                })
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.commitBT?.alpha = 0
                    self.commitBT?.enabled = false
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.commitBT?.alpha = 0
                self.commitBT?.enabled = false
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension AdminRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField === accountTF) {
            passwordTF!.becomeFirstResponder()
        } else if textField === passwordTF {
            confirmPassTF!.becomeFirstResponder()
        } else if textField === confirmPassTF {
            firstNameTF!.becomeFirstResponder()
        } else if textField === firstNameTF {
            lastNameTF!.becomeFirstResponder()
        } else if textField === lastNameTF {
            lastNameTF?.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //accountTF?.textColor = UIColor.whiteColor()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == accountTF && !validate(accountTF!.text!) {
            accountTF?.textColor = UIColor.MKColor.Red
        } else if validate(accountTF!.text!){
            accountTF?.textColor = UIColor.whiteColor()
        }
        
        if textField == confirmPassTF && confirmPassTF?.text != passwordTF?.text && confirmPassTF?.text != "" {
            passwordTF?.textColor = UIColor.MKColor.Red
            confirmPassTF?.textColor = UIColor.MKColor.Red
        } else if confirmPassTF?.text == passwordTF?.text {
            passwordTF?.textColor = UIColor.whiteColor()
            confirmPassTF?.textColor = UIColor.whiteColor()
        }
        
        doTestAllInformationIsFilled()
    }
}

extension AdminRegistrationViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension AdminRegistrationViewController: ManagerQueryTableViewControllerDelegate {
    func updateAssignButtonToChosenManager(manager: User) {
        self.manager = manager
        doTestAllInformationIsFilled()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.assignSupervisorBT?.alpha = 0
            self.assignSupervisorBT?.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.assignSupervisorBT?.backgroundColor = UIColor.clearColor()
                    self.assignSupervisorBT?.layer.borderWidth = 0.5
                    self.assignSupervisorBT?.layer.borderColor = UIColor.whiteColor().CGColor
                    let keyStringCheckLanguage = "supervised_by"
                    self.assignSupervisorBT?.setTitle("\(self.checkLanguage(keyStringCheckLanguage)): \(manager.FirstName) \(manager.LastName)", forState: UIControlState.Normal)
                    self.assignSupervisorBT?.alpha = 1
                    self.assignSupervisorBT?.enabled = true
                })
        })
    }
}

extension AdminRegistrationViewController: BeaconQueryTableViewControllerDelegate {
    func updateAssignButtonToChosenBeacon(beacon: Beacon) {
        self.beacon = beacon
        doTestAllInformationIsFilled()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.assignBeaconBT?.alpha = 0
            self.assignBeaconBT?.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.assignBeaconBT?.backgroundColor = UIColor.clearColor()
                    self.assignBeaconBT?.layer.borderWidth = 0.5
                    self.assignBeaconBT?.layer.borderColor = UIColor.whiteColor().CGColor
                    let keyStringCheckLanguage = "beacon_is"
                    let major = beacon["Major"] as! String
                    let minor = beacon["Minor"] as! String
                    self.assignBeaconBT?.setTitle("\(self.checkLanguage(keyStringCheckLanguage)): \(major) - \(minor)", forState: UIControlState.Normal)
                    self.assignBeaconBT?.alpha = 1
                    self.assignBeaconBT?.enabled = true
                })
        })
    }
}
