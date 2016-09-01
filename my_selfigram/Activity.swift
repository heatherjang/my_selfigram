//
//  activity.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-29.
//  Copyright © 2016 Heather. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Activity: PFObject, PFSubclassing {
    
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    static func parseClassName() -> String {
        // Name of Parse table to be called
        return "Activity"
    }
    
    // Convenience builds ON TOP of super, rather than override
    convenience init(type:String, post:Post, user:PFUser) {
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
    
}