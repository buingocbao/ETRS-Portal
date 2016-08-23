//
//  EmployeeCollectionViewCell.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/30/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EmployeeCollectionViewCell: PFCollectionViewCell {
    
    @IBOutlet weak var defaultAvatar: PFImageView!
    
    var objectUser: User?
    
    var placeholderLayer: CALayer!
    var contentLayer: CALayer?
    var containerNode: ASDisplayNode?
    var nodeConstructionOperation: NSOperation?

    //This variable for selected cell
    var avatar:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultAvatar.image = UIImage(named: "Avatar")
        
        placeholderLayer = CALayer()
        //placeholderLayer.contents = UIImage(named: "EmployeePlaceholder")?.CGImage
        placeholderLayer.contentsGravity = kCAGravityCenter
        placeholderLayer.contentsScale = UIScreen.mainScreen().scale
        placeholderLayer.backgroundColor = UIColor.whiteColor().CGColor
        contentView.layer.addSublayer(placeholderLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        placeholderLayer.frame = bounds
        CATransaction.commit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let operation = nodeConstructionOperation {
            operation.cancel()
        }
        
        containerNode?.recursivelySetDisplaySuspended(true)
        contentLayer?.removeFromSuperlayer()
        contentLayer = nil
        containerNode = nil
    }
    /*
    func configCellDisplayWithUserInfo(userInfo: User, image: UIImage, nodeConstructionQueue: NSOperationQueue) {
        if let oldNodeConstructionOperation = nodeConstructionOperation {
            oldNodeConstructionOperation.cancel()
        }
        
        let newNodeConstructionOperation = nodeConstructionOperationWithUserInfo(userInfo, image: image)
        nodeConstructionOperation = newNodeConstructionOperation
        nodeConstructionQueue.addOperation(newNodeConstructionOperation)
    }*/
    
    func configCellWithDefaultAvatar(userInfo: User, image: UIImage) {
        //MARK: Node Creation Section
        let avatarImageNode = ASImageNode()
        avatarImageNode.layerBacked = true
        avatarImageNode.contentMode = .ScaleAspectFill
        avatarImageNode.image = image
        avatarImageNode.layer.cornerRadius = 50
        self.avatar = image
        
        //Predefined text
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Center
        let attributesBold = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 22.0)! , NSForegroundColorAttributeName : UIColor.MKColor.Blue, NSParagraphStyleAttributeName : paraStyle]
        let attributesNormal = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 22.0)! , NSForegroundColorAttributeName : UIColor.MKColor.Blue, NSParagraphStyleAttributeName : paraStyle]
        
        let empFullname = ASTextNode()
        empFullname.layerBacked = true
        empFullname.backgroundColor = UIColor.clearColor()
        empFullname.attributedString = NSAttributedString(string: userInfo.FirstName + " " + userInfo.LastName, attributes: attributesBold)
        //empFullname.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //empFullname.layer.borderWidth = 1.0
        
        let empGroup = ASTextNode()
        empGroup.layerBacked = true
        empGroup.backgroundColor = UIColor.clearColor()
        empGroup.attributedString = NSAttributedString(string: checkLanguage(userInfo.Group.lowercaseString), attributes: attributesNormal)
        //empGroup.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //empGroup.layer.borderWidth = 1.0
        
        let empEmailStatus = ASTextNode()
        empEmailStatus.layerBacked = true
        empEmailStatus.backgroundColor = UIColor.clearColor()
        var emailVerified = ""
        if userInfo.emailVerified == true {
            emailVerified = checkLanguage("email_status_true")
        } else {
            emailVerified = checkLanguage("email_status_false")
        }
        empEmailStatus.attributedString = NSAttributedString(string: emailVerified, attributes: attributesNormal)
        //empEmailStatus.layer.borderColor = UIColor.MKColor.Blue.CGColor
        //empEmailStatus.layer.borderWidth = 1.0
        
        //MARK: Container Node Creation Section
        let containerNode = ASDisplayNode()
        containerNode.layerBacked = true
        containerNode.shouldRasterizeDescendants = true
        //containerNode.borderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 0.2).CGColor
        //containerNode.borderWidth = 1
        self.containerNode = containerNode
        
        //MARK: Node Hierarchy Section
        containerNode.addSubnode(avatarImageNode)
        containerNode.addSubnode(empFullname)
        containerNode.addSubnode(empGroup)
        containerNode.addSubnode(empEmailStatus)
        
        //MARK: Node Layout Section
        containerNode.frame = self.contentView.frame
        avatarImageNode.frame = CGRect(x: 5, y: self.contentView.frame.height/2-50, width: 100, height: 100)
        empFullname.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15-5-30, width: self.contentView.frame.width-10-100-5, height: 30)
        empGroup.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15, width: self.contentView.frame.width-10-100-5, height: 30)
        empEmailStatus.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15+5+30, width: self.contentView.frame.width-10-100-5, height: 30)
        
        //MARK: Node Layer and Wrap Up Section
        self.contentView.layer.addSublayer(containerNode.layer)
        containerNode.setNeedsDisplay()
        self.contentLayer = containerNode.layer
        self.containerNode = containerNode
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
    
}
