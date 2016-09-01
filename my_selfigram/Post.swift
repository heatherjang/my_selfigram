//
//  Post.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-10.
//  Copyright © 2016 Heather. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing {

    @NSManaged var image:PFFile
    @NSManaged var user:PFUser
    @NSManaged var comment:String
    
    var likes: PFRelation! {
        // PFRelation is a “computed property” (value is computed every time instead of stored)
        // Line below pecifies that our relation column should be called “likes”
        return relationForKey("likes")
    }

    static func parseClassName() -> String {
        // Name of Parse table to be called
        return "Post"
    }
    
    // Convenience builds ON TOP of super, rather than override
    convenience init(image:PFFile, user:PFUser, comment:String) {
        self.init()
        self.image = image
        self.user  = user
        self.comment = comment
    }
    
}