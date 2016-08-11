//
//  User.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-10.
//  Copyright © 2016 Heather. All rights reserved.
//

import Foundation
import UIKit

class User {
    let username: String
    let profileImage: UIImage
    
    init(username: String, profileImage: UIImage){
        self.username     = username
        self.profileImage = profileImage
    }

}