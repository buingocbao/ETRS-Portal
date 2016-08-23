//
//  KPIEmployeeCollectionViewCell.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/20/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class KPIEmployeeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var employeeAvatar: PFImageView!
    @IBOutlet weak var employeeFullName: UILabel!
    
    override func awakeFromNib() {
        employeeAvatar.image = UIImage(named: "Avatar")        
        employeeFullName.text = "Employee"
    }
}
