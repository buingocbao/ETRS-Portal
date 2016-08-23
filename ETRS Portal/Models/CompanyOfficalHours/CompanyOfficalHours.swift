//
//  CompanyOfficalHours.swift
//  ETRS Portal
//
//  Created by BBaoBao on 10/18/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import UIKit

class CompanyOfficalHour: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "CompanyOfficalHour"
    }
    
    // MARK: - Parse Core Properties
    @NSManaged var Start: String?
    @NSManaged var End: String?
    @NSManaged var WelcomeSentence: String?
    @NSManaged var GoodbyeSentence: String?
    @NSManaged var Language: String?
}
