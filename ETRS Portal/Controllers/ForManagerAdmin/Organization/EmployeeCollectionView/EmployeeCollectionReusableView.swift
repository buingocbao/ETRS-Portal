//
//  EmployeeCollectionReusableView.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/30/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class EmployeeCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var headerLB: UILabel!
    
    override func awakeFromNib() {
        headerLB.layer.masksToBounds = true
        headerLB.layer.borderColor = UIColor.whiteColor().CGColor
        headerLB.layer.borderWidth = 1
        headerLB.layer.cornerRadius = 5
        //headerLB.backgroundColor = UIColor.MKColor.Green
    }
}
