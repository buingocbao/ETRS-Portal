//
//  LoginViewController.swift
//  ETRS
//
//  Created by BBaoBao on 9/9/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var logoView:UIImageView?
    var activityIndicatorView: NVActivityIndicatorView?
    var loginButton:MKButton?
    var forgotPassButton: MKButton?
    var accountTF: MKTextField?
    var passwordTF: MKTextField?
    
    override func viewDidAppear(animated: Bool) {
        deactiveActivityIndicator(activityIndicatorView!)
        activeButton(loginButton!)
        //Check current user (logged last time)
        let currentUser = User.currentUser()
        if currentUser != nil {
            accountTF!.text = currentUser?.username
            deactiveButton(loginButton!)
            activeActivityIndicator(activityIndicatorView!)
            presentHomeVC(currentUser!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackground()
        createLogo()
        createActivityIndicator()
        createButtons()
        createTextFields()
    }
    
    // Create Background View
    func createBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        self.view.addSubview(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
        
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "Login-Background")
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
    }
    
    // Create Logo View
    func createLogo() {
        let logoView = UIImageView(frame: CGRect(x: self.view.frame.width/2-80/2, y: 10, width: 80, height: 80))
        logoView.image = UIImage(named: "Logo")
        self.view.addSubview(logoView)
        self.logoView = logoView
    }
    
    // Create Activity Indicator
    func createActivityIndicator() {
        let activityTypes: NVActivityIndicatorType = .BallTrianglePath
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
            type: activityTypes)
        activityIndicatorView.center = self.view.center
        self.view.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        self.activityIndicatorView?.hidden = true
    }
    
    
    
    // Create Buttons
    func createButtons() {
        // Login Button
        let loginButton = MKButton()
        loginButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50)
        loginButton.center = self.view.center
        loginButton.layer.shadowOpacity = 0.55
        loginButton.layer.shadowRadius = 5.0
        loginButton.layer.shadowColor = UIColor.blackColor().CGColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        loginButton.backgroundColor = UIColor.MKColor.Blue
        loginButton.setTitle(checkLanguage("login"), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginButtonTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginButton)
        self.loginButton = loginButton
        
        // Forgot password
        let forgotPassButton = MKButton()
        forgotPassButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 50)
        forgotPassButton.layer.shadowOpacity = 0.55
        forgotPassButton.layer.shadowRadius = 5.0
        forgotPassButton.layer.shadowColor = UIColor.blackColor().CGColor
        forgotPassButton.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        forgotPassButton.setTitle(checkLanguage("forgot"), forState: UIControlState.Normal)
        forgotPassButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        forgotPassButton.addTarget(self, action: "forgotPassButtonTouch", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(forgotPassButton)
        forgotPassButton.translatesAutoresizingMaskIntoConstraints = false
        let botConstraintBTForgot = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: forgotPassButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let xCenterConstraintBTForgot = NSLayoutConstraint(item: forgotPassButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintBTForgot = NSLayoutConstraint(item: forgotPassButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width)
        let heightConstraintBTForgot = NSLayoutConstraint(item: forgotPassButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50)
        view.addConstraints([botConstraintBTForgot, xCenterConstraintBTForgot, widthConstraintBTForgot, heightConstraintBTForgot])
        self.forgotPassButton = forgotPassButton

    }
    
    // Login Button Touch Events
    func loginButtonTouch() {
        checkLogin()
    }
    
    func forgotPassButtonTouch() {
        if accountTF!.text == "" {
            let alert = UIAlertView(title: checkLanguage("missing"), message: checkLanguage("missing_mess"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            // Send a request to reset a password
            PFUser.requestPasswordResetForEmailInBackground(accountTF!.text!)
            let alert = UIAlertController (title: checkLanguage("pass_reset"), message: checkLanguage("pass_reset_mess") + accountTF!.text! + ".", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.forgotPassButton?.hidden = true
            self.forgotPassButton?.enabled = false
            _ = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "updateForgotButton", userInfo: nil, repeats: false)
        }
    }
    
    func updateForgotButton() {
        UIView.transitionWithView(forgotPassButton!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            //
            self.forgotPassButton?.hidden = false
            self.forgotPassButton?.enabled = true
        }, completion: nil)
    }
    
    // Create Textfields
    func createTextFields() {
        // Password Text Field
        let passwordTF = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 40))
        passwordTF.layer.borderColor = UIColor.clearColor().CGColor
        passwordTF.floatingPlaceholderEnabled = true
        passwordTF.placeholder = checkLanguage("password")
        passwordTF.tintColor = UIColor.whiteColor()
        passwordTF.textColor = UIColor.whiteColor()
        passwordTF.rippleLocation = .Right
        passwordTF.cornerRadius = 0
        passwordTF.bottomBorderEnabled = true
        passwordTF.borderStyle = UITextBorderStyle.None
        passwordTF.minimumFontSize = 17
        passwordTF.font = UIFont(name: "HelveticaNeue", size: 20)
        passwordTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        passwordTF.secureTextEntry = true
        passwordTF.delegate = self
        self.view.addSubview(passwordTF)
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        let botConstraintTFPass = NSLayoutConstraint(item: self.loginButton!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: passwordTF, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let xCenterConstraintTFPass = NSLayoutConstraint(item: passwordTF, attribute: .CenterX, relatedBy: .Equal, toItem: loginButton, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintTFPass = NSLayoutConstraint(item: passwordTF, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2+100)
        let heightConstraintTFPass = NSLayoutConstraint(item: passwordTF, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        view.addConstraints([botConstraintTFPass, xCenterConstraintTFPass, widthConstraintTFPass, heightConstraintTFPass])
        self.passwordTF = passwordTF
        
        // Username Text Field
        let accountTF = MKTextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 40))
        accountTF.layer.borderColor = UIColor.clearColor().CGColor
        accountTF.floatingPlaceholderEnabled = true
        accountTF.placeholder = checkLanguage("account")
        accountTF.tintColor = UIColor.whiteColor()
        accountTF.textColor = UIColor.whiteColor()
        accountTF.rippleLocation = .Right
        accountTF.cornerRadius = 0
        accountTF.bottomBorderEnabled = true
        accountTF.borderStyle = UITextBorderStyle.None
        accountTF.minimumFontSize = 17
        accountTF.font = UIFont(name: "HelveticaNeue", size: 20)
        accountTF.clearButtonMode = UITextFieldViewMode.UnlessEditing
        accountTF.autocapitalizationType = .None
        accountTF.keyboardType = UIKeyboardType.EmailAddress
        accountTF.delegate = self
        self.view.addSubview(accountTF)
        accountTF.translatesAutoresizingMaskIntoConstraints = false
        let botConstraintTFAccount = NSLayoutConstraint(item: self.passwordTF!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: accountTF, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        let xCenterConstraintTFAccount = NSLayoutConstraint(item: accountTF, attribute: .CenterX, relatedBy: .Equal, toItem: loginButton, attribute: .CenterX, multiplier: 1, constant: 0)
        let widthConstraintTFAccount = NSLayoutConstraint(item: accountTF, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.view.frame.width/2+100)
        let heightConstraintTFAccount = NSLayoutConstraint(item: accountTF, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 40)
        view.addConstraints([botConstraintTFAccount, xCenterConstraintTFAccount, widthConstraintTFAccount, heightConstraintTFAccount])
        self.accountTF = accountTF
    }
    
    func checkLogin() {
        let account = self.accountTF!.text
        let password = self.passwordTF!.text
        
        // Validate the text fields
        if account == "" {
            let alert = UIAlertView(title: checkLanguage("invalid"), message: checkLanguage("invalid_acc_empty"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if !validate(account!) {
            self.accountTF?.textColor = UIColor.MKColor.Red
        } else if password == "" {
            let alert = UIAlertView(title: checkLanguage("invalid"), message: checkLanguage("invalid_pass_empty"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if password!.characters.count < 6 {
            let alert = UIAlertView(title: checkLanguage("invalid"), message: checkLanguage("invalid_pass_greater"), delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            deactiveButton(loginButton!)
            activeActivityIndicator(activityIndicatorView!)
            // Send a request to login
            PFUser.logInWithUsernameInBackground(account!, password: password!, block: { (user, error) -> Void in
                if ((user) != nil) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let currentUser = user as! User
                        self.presentHomeVC(currentUser)
                    })
                } else {
                    let alert = UIAlertView(title: self.checkLanguage("error"), message: self.checkLanguage("error_login_fail"), delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    self.deactiveActivityIndicator(self.activityIndicatorView!)
                    self.activeButton(self.loginButton!)
                }
            })
        }
    }
    
    func presentHomeVC(currentUser: User) {
        // Stop the activity indicator
        self.deactiveActivityIndicator(self.activityIndicatorView!)
        self.activeButton(self.loginButton!)
        // Empty textfields
        self.emptyTextFields([accountTF!, passwordTF!])
        
        if currentUser.Group == "Employee" {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EmployeeVC")
            self.presentViewController(viewController, animated: true, completion: nil)
        } else {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AdminManagerVC")
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        
    }
    
    // Other methods
    func deactiveButton(button: MKButton) {
        
        UIView.transitionWithView(loginButton!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            // Body closure
            button.enabled = false
            button.hidden = true
        }, completion: nil)
    }
    
    func activeButton(button: MKButton) {
        UIView.transitionWithView(loginButton!, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            //
            button.enabled = true
            button.hidden = false
        }, completion: nil)
    }
    
    func deactiveActivityIndicator(activityIndicator: NVActivityIndicatorView) {
        activityIndicatorView?.hidden = true
        activityIndicatorView?.stopAnimation()
    }
    
    func activeActivityIndicator(activityIndicator: NVActivityIndicatorView) {
        activityIndicatorView?.hidden = false
        activityIndicatorView?.startAnimation()
    }
    
    func validate(value: String) -> Bool {
        let emailRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let test = NSPredicate(format: "SELF MATCHES %@", emailRule)
        return test.evaluateWithObject(value)
    }
    
    func emptyTextFields(textfields: [UITextField]) {
        for textfield in textfields {
            textfield.text = ""
        }
    }
    
    func checkLanguage(key: String) -> String {
        //Get language setting
        let defaults = NSUserDefaults.standardUserDefaults()
        var language = "vi"
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === accountTF) {
            passwordTF!.becomeFirstResponder()
        } else if textField === passwordTF {
            passwordTF!.resignFirstResponder()
            loginButtonTouch()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        accountTF?.textColor = UIColor.whiteColor()
        return true
    }
}
