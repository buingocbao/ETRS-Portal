//
//  Beacon.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/19/15.
//  Copyright © 2015 buingocbao. All rights reserved.
//

import Foundation

class Beacon : PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Beacon"
    }
    
    @NSManaged var UUID: String
    @NSManaged var Major: String
    @NSManaged var Minor: String
    @NSManaged var Context: String
    @NSManaged var Status: Bool
    @NSManaged var Information: String
    @NSManaged var Color: String
    @NSManaged var Description: String
}