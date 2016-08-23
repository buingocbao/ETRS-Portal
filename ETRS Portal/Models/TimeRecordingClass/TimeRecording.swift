//
//  TimeRecording.swift
//  ETRS
//
//  Created by BBaoBao on 9/12/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class TimeRecording: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "TimeRecording"
    }
    
    // MARK: - Parse Core Properties
    @NSManaged var Employee: String?
    @NSManaged var StartTimeRecord: String?
    @NSManaged var EndTimeRecord: String?
    @NSManaged var Group: String?
    @NSManaged var Reason: String?
    @NSManaged var Integrity: String?
    @NSManaged var Day: Int
    @NSManaged var Month: Int
    @NSManaged var Year: Int
}
