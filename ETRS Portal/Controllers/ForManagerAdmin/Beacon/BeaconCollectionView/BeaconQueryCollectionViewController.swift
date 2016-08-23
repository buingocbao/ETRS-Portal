//
//  BeaconQueryCollectionViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/13/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class BeaconQueryCollectionViewController: PFQueryCollectionViewController {

    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var activityIndicatorView: NVActivityIndicatorView?
    
    var beaconObjects = [Beacon]()
    
    override func awakeFromNib() {
        self.collectionView?.backgroundColor = UIColor.MKColor.LightGreen
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Configure the PFQueryTableView
        self.parseClassName = "Beacon"
        self.loadingViewEnabled = false
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForCollection() -> PFQuery {
        let query = Beacon.query()
        query?.orderByDescending("Context")
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
        print(objects.count)
        beaconObjects = objects as! [Beacon]
        self.activityIndicatorView!.stopAnimation()
        self.activityIndicatorView!.hidden = true
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BeaconCell", forIndexPath: indexPath) as! BeaconCollectionViewCell
        cell.backgroundColor = UIColor.MKColor.Blue
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        let beaconColor = self.beaconObjects[indexPath.row].Color
        cell.configCellWithDefaultAvatar(self.beaconObjects[indexPath.row], image: UIImage(named: "Beacon-\(beaconColor)")!)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Select \(indexPath.section):\(indexPath.row)")
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupPickBeaconVC") as! PickBeaconViewController
        popupVC.beaconObject = beaconObjects[indexPath.row]
        showPopupWithTransitionStyle(.Fade, rootViewController: popupVC)
    }
    
    /*
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-10, height: 180)
    }*/
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func showPopupWithTransitionStyle(transitionStyle: STPopupTransitionStyle, rootViewController: UIViewController) {
        let popupController = STPopupController(rootViewController: rootViewController)
        popupController.cornerRadius = 4
        popupController.transitionStyle = transitionStyle
        popupController.presentInViewController(self)
    }
}
