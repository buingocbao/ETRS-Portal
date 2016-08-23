//
//  BeaconCollectionViewCell.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/13/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class BeaconCollectionViewCell: PFCollectionViewCell {

    @IBOutlet weak var beaconImage: UIImageView!
    
    var objectBeacon: Beacon?
    
    var placeholderLayer: CALayer!
    var contentLayer: CALayer?
    var containerNode: ASDisplayNode?
    var nodeConstructionOperation: NSOperation?
    
    //This variable for selected cell
    var avatar:UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //beaconImage.image = UIImage(named: "BeaconAvatar")

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
    
    func configCellWithDefaultAvatar(beaconInfo: Beacon, image: UIImage) {
        //MARK: Node Creation Section
        let avatarImageNode = ASImageNode()
        avatarImageNode.layerBacked = true
        avatarImageNode.contentMode = .ScaleAspectFit
        avatarImageNode.image = image
        avatarImageNode.layer.cornerRadius = 50
        self.avatar = image
        
        //Predefined text
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Left
        let attributesBold = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 22.0)! , NSForegroundColorAttributeName : UIColor.blackColor(), NSParagraphStyleAttributeName : paraStyle]
        let attributesNormal = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 22.0)! , NSForegroundColorAttributeName : UIColor.blackColor(), NSParagraphStyleAttributeName : paraStyle]
        
        let beaconName = ASTextNode()
        beaconName.layerBacked = true
        beaconName.backgroundColor = UIColor.clearColor()
        beaconName.attributedString = NSAttributedString(string: beaconInfo.Context, attributes: attributesBold)
        
        let beaconUUID = ASTextNode()
        beaconUUID.layerBacked = true
        beaconUUID.backgroundColor = UIColor.clearColor()
        beaconUUID.attributedString = NSAttributedString(string: "\(beaconInfo.UUID)", attributes: attributesNormal)
        
        let beaconMajor = ASTextNode()
        beaconMajor.layerBacked = true
        beaconMajor.backgroundColor = UIColor.clearColor()
        beaconMajor.attributedString = NSAttributedString(string: "Major: \(beaconInfo.Major)", attributes: attributesNormal)
        
        let beaconMinor = ASTextNode()
        beaconMinor.layerBacked = true
        beaconMinor.backgroundColor = UIColor.clearColor()
        beaconMinor.attributedString = NSAttributedString(string: "Minor: \(beaconInfo.Minor)", attributes: attributesNormal)
        
        //MARK: Container Node Creation Section
        let containerNode = ASDisplayNode()
        containerNode.layerBacked = true
        containerNode.shouldRasterizeDescendants = true
        self.containerNode = containerNode
        
        //MARK: Node Hierarchy Section
        containerNode.addSubnode(avatarImageNode)
        containerNode.addSubnode(beaconName)
        containerNode.addSubnode(beaconUUID)
        containerNode.addSubnode(beaconMajor)
        containerNode.addSubnode(beaconMinor)
        
        //MARK: Node Layout Section
        containerNode.frame = self.contentView.frame
        avatarImageNode.frame = CGRect(x: 5, y: self.contentView.frame.height/2-50, width: 100, height: 100)
        beaconName.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15-5-30, width: self.contentView.frame.width-10-100-5, height: 30)
        beaconUUID.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15, width: self.contentView.frame.width-10-100-5, height: 30)
        beaconMajor.frame = CGRect(x: 5+100+5, y: self.contentView.frame.height/2-15+5+30, width: 150, height: 30)
        beaconMinor.frame = CGRect(x: 5+100+5+150+5, y: self.contentView.frame.height/2-15+5+30, width: self.contentView.frame.width-10-100-5, height: 30)
        
        //MARK: Node Layer and Wrap Up Section
        self.contentView.layer.addSublayer(containerNode.layer)
        containerNode.setNeedsDisplay()
        self.contentLayer = containerNode.layer
        self.containerNode = containerNode
    }

}
