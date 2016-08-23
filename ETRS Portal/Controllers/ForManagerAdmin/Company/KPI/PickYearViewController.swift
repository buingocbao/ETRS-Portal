//
//  PickYearViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/21/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

protocol PickYearViewControllerDelegate
{
    func sendYearValue(var value : Int)
}

class PickYearViewController: UIViewController {
    
    var years = [NSDate.today().year-5,NSDate.today().year-4,NSDate.today().year-3,NSDate.today().year-2,NSDate.today().year-1,NSDate.today().year,NSDate.today().year+1,NSDate.today().year+2,NSDate.today().year+3,NSDate.today().year+4]

    @IBOutlet weak var pickYearCollectionView: UICollectionView!
    
    var delegate: PickYearViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = checkLanguage("year")
        pickYearCollectionView.dataSource = self
        pickYearCollectionView.delegate = self
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

extension PickYearViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return years.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PickYearCell", forIndexPath: indexPath) as! PickYearCollectionViewCell
        
        cell.yearLB.text = String(years[indexPath.row])
        cell.yearLB.textColor = UIColor.whiteColor()
        cell.yearLB.layer.masksToBounds = true
        cell.yearLB.layer.cornerRadius = 5
        
        if indexPath.row <= 5 {
            cell.yearLB.backgroundColor = UIColor.MKColor.Blue
        } else {
            cell.yearLB.backgroundColor = UIColor.MKColor.Grey
            cell.userInteractionEnabled = false
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
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        self.delegate?.sendYearValue(years[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
