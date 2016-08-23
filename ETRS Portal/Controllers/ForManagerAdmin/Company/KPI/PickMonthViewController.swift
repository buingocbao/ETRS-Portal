//
//  PickMonthViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/21/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol PickMonthViewControllerDelegate
{
    func sendMonthValue(var value : Int)
}

class PickMonthViewController: UIViewController {

    @IBOutlet weak var pickMonthCollectionView: UICollectionView!
    
    let currentMonth = NSDate.today().month
    
    var delegate: PickMonthViewControllerDelegate?
    
    var pickedYear = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = checkLanguage("month")
        pickMonthCollectionView.dataSource = self
        pickMonthCollectionView.delegate = self
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

}

extension PickMonthViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PickMonthCell", forIndexPath: indexPath) as! PickMonthCollectionViewCell
        
        cell.monthLB.text = String(indexPath.row+1)
        cell.monthLB.textColor = UIColor.whiteColor()
        cell.monthLB.layer.masksToBounds = true
        cell.monthLB.layer.cornerRadius = 5
        if pickedYear == NSDate.today().year {
            if indexPath.row+1 <= self.currentMonth {
                cell.monthLB.backgroundColor = UIColor.MKColor.Blue
            } else {
                cell.monthLB.backgroundColor = UIColor.MKColor.Grey
                cell.monthLB.userInteractionEnabled = false
            }
        } else {
            cell.monthLB.backgroundColor = UIColor.MKColor.Blue
        }
    
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(-40, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        for i in 0...11 {
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! PickMonthCollectionViewCell
            if i == indexPath.row {
                cell.monthLB.backgroundColor = UIColor.MKColor.Red
                collectionView.deselectItemAtIndexPath(indexPath, animated: false)
                self.delegate?.sendMonthValue(i+1)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                cell.monthLB.backgroundColor = UIColor.MKColor.Blue
            }
        }
    }
}