//
//  EmployeeTabBarViewController.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/24/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class EmployeeTabBarViewController: YALFoldingTabBarController {
    
    let tabItemLeft1: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "TimeRecord"), leftItemImage: nil, rightItemImage: nil)
    let tabItemRight1: YALTabBarItem = YALTabBarItem(itemImage: UIImage(named: "Information"), leftItemImage: nil, rightItemImage: UIImage(named: "Calendar"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Items on the left of tab bar
        super.leftBarItems = [tabItemLeft1]
        //Items on the right of tab bar
        super.rightBarItems = [tabItemRight1]
        //Center button of tab bar
        super.centerButtonImage = UIImage(named: "Add")
        
        //Customize tabBarView
        //Specify height
        super.tabBarViewHeight = YALTabBarViewDefaultHeight
        //Specify insets and offsets
        super.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets
        super.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets
        super.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset
        //Specify colors
        super.tabBarView.backgroundColor = UIColor.MKColor.Blue
        super.tabBarView.tabBarColor = UIColor.MKColor.Green
        //Specify height for additional left and right buttons
        super.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight
    }

}
