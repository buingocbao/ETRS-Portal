//
//  PickBeaconViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/14/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class PickBeaconViewController: UIViewController {

    @IBOutlet weak var beaconImage: UIImageView!
    @IBOutlet weak var beaconUUID: UILabel!
    @IBOutlet weak var beaconMajorMinor: UILabel!
    @IBOutlet weak var beaconContextBT: MKButton!
    @IBOutlet weak var beaconStatusBT: MKButton!
    @IBOutlet weak var descripLB: UILabel!
    @IBOutlet weak var descriptTextView: UITextView!
    
    var beaconObject:Beacon!
    var beaconStatus:Bool!
    var beaconContext:String!
    
    var activityIndicatorView: NVActivityIndicatorView?
    var blurView: UIVisualEffectView?
    
    override func awakeFromNib() {
        self.contentSizeInPopup = CGSizeMake(550, 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Beacon"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: checkLanguage("save"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveBTTouch"))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.MKColor.Red
        
        beaconImage.image = UIImage(named: "Beacon-\(beaconObject.Color)")
        beaconStatus = beaconObject.Status
        beaconContext = beaconObject.Context
        
        configView()
        provideText()
    }
    
    func configView() {
        beaconContextBT.maskEnabled = true
        beaconContextBT.layer.borderWidth = 1
        beaconContextBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        beaconContextBT.backgroundColor = .clearColor()
        
        beaconStatusBT.maskEnabled = true
        beaconStatusBT.layer.borderWidth = 1
        beaconStatusBT.layer.borderColor = UIColor.MKColor.Blue.CGColor
        beaconStatusBT.backgroundColor = .clearColor()
    }
    
    func provideText() {
        beaconUUID.text = beaconObject?.UUID
        beaconMajorMinor.text = "Major: \(beaconObject.Major) - Minor: \(beaconObject.Minor)"
        beaconContextBT.setTitle("\(beaconObject.Context)", forState: .Normal)
        descriptTextView.text = beaconObject.Description
        if beaconObject.Status == false {
            let title = checkLanguage("status") + ": " + "INACTIVE"
            beaconStatusBT.setTitle(title, forState: .Normal)
        } else {
            let title = checkLanguage("status") + ": " + "ACTIVE"
            beaconStatusBT.setTitle(title, forState: .Normal)
        }
        
        descripLB.text = checkLanguage("beacon_descriptionLB")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    //MARK: Event
    @IBAction func contextBTEvent(sender: AnyObject) {
        self.assignContextBTTouch()
    }
    
    @IBAction func statusBTEvent(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconStatusBT.alpha = 0
            self.beaconStatusBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    if self.beaconStatus == false {
                        let title = self.checkLanguage("status") + ": " + "ACTIVE"
                        self.beaconStatusBT.setTitle(title, forState: .Normal)
                        self.beaconStatus = true
                    } else {
                        let title = self.checkLanguage("status") + ": " + "INACTIVE"
                        self.beaconStatusBT.setTitle(title, forState: .Normal)
                        self.beaconStatus = false
                    }
                    self.beaconStatusBT.alpha = 1
                    self.beaconStatusBT.enabled = true
                })
        })
    }
    
    func saveBTTouch() {
        print("Saving Beacon")
        self.showIndicatorActivity()
        beaconObject.Context = self.beaconContext
        beaconObject.Status = self.beaconStatus
        beaconObject.Description = self.descriptTextView.text
        beaconObject.saveInBackgroundWithBlock { (succeed, error) -> Void in
            if succeed {
                print("Successfully save beacon")
            } else {
                print("Error: \(error)")
            }
            self.closeIndicatorActivity()
        }
    }
    
    func assignContextBTTouch() {
        let popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("ContextTableVC") as! PickContextTableViewController
        popoverContent.delegate = self
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(200, 150)
        popover!.permittedArrowDirections = UIPopoverArrowDirection.Up
        popover!.delegate = self
        popover!.sourceView = beaconContextBT
        popover!.sourceRect = CGRectMake(beaconContextBT.frame.width/2,beaconContextBT.frame.height,0,0)
        self.presentViewController(nav, animated: true, completion: nil)
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

extension PickBeaconViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
}

extension PickBeaconViewController: PickContextTableViewControllerDelegate {
    func updateAssignButtonToChosenContext(context: String) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            //
            self.beaconContextBT.alpha = 0
            self.beaconContextBT.enabled = false
            }, completion: { (finished) -> Void in
                //
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    //
                    self.beaconContextBT.setTitle(context, forState: .Normal)
                    self.beaconContext = context
                    self.beaconContextBT.alpha = 1
                    self.beaconContextBT.enabled = true
                })
        })
    }
}
