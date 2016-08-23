//
//  NewBeaconCollectionViewCell.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/16/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class NewBeaconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beaconImage: UIImageView!
    @IBOutlet weak var beaconMajorMinor: UILabel!
    
    override func awakeFromNib() {
        beaconMajorMinor.layer.borderColor = UIColor.MKColor.Blue.CGColor
        beaconMajorMinor.layer.borderWidth = 0.5
    }
}
