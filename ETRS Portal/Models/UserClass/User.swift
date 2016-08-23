//
//  User.swift
//  ETRS Portal
//
//  Created by BBaoBao on 9/13/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class User: PFUser {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    // MARK: - Parse Core Properties
    @NSManaged var FirstName: String
    @NSManaged var LastName: String
    @NSManaged var Group: String
    @NSManaged var MusicFile: PFFile
    @NSManaged var Device: String
    @NSManaged var Supervisor: User
    @NSManaged var Beacon: String
    @NSManaged var emailVerified: Bool
    @NSManaged var Avatar: PFFile?
    
    func getImage() -> UIImage {
        let view = PFImageView(image: UIImage(named: "Avatar"))
        view.file = Avatar
        view.loadInBackground()
        return view.image!
    }
}
