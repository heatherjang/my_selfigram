//
//  Post.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-10.
//  Copyright © 2016 Heather. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let image: UIImage
    let user: User
    let comment: String
    
    init(image: UIImage, user: User, comment: String){
        self.image = image
        self.user = user
        self.comment = comment
    }
}