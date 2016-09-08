//
//  SelfieCell.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-17.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartAnimationView: UIImageView!
    
    var post:Post? {
        // didSet is run when post variable set in FeedViewController
        didSet {
            if let post = post {
                
                let imageFile = post.image
                imageFile.getDataInBackgroundWithBlock{ (data, error) in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                }
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                // Set up like button default
                likeButton.selected = false
                
                // Query post.likes to see if current user likes post
                let query = post.likes.query()
                query.findObjectsInBackgroundWithBlock{ (users, error) in
                    if let users = users as? [PFUser] {
                        for user in users {
                            // If user.objectId = currentUser.objectId, then button.selected = true
                            if user.objectId == PFUser.currentUser()?.objectId {
                                self.likeButton.selected = true
                            }
                        }
                    }
                }
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        selfieImageView.image = nil
        usernameLabel.text    = ""
        commentLabel.text     = ""
    }
    
    // Like button event listener
    @IBAction func likeButtonClicked(sender: UIButton) {
        // Set sender selected value to opposite of what it currently is
        sender.selected = !sender.selected
        
        // Handle optionals
        if  let post = post,
            let user = PFUser.currentUser() {
            
            // Write the like to the table, if sender.selected
            if sender.selected {
                
                // addObject will never add multiple copies of the same association
                post.likes.addObject(user)
                
                // Save to parse
                post.saveInBackgroundWithBlock{ (success, error) in
                    if success {
                        // Create a new Activity
                        let activity = Activity(type: "like", post: post, user: user)
                        activity.saveInBackgroundWithBlock { (success, error) in
                            if success {
                                print("Activity logged")
                            } else {
                                print("error: \(error)")
                            }
                        }
                        print("Great success!")
                    } else {
                        print("error: \(error)")
                    }
                }
                
            } else {
                // removeObject
                post.likes.removeObject(user)
                
                // Save to parse
                post.saveInBackgroundWithBlock{ (success, error) in
                    if success {
                        if let query = Activity.query() {
                            query.whereKey("post", equalTo: post)
                            query.whereKey("type", equalTo: "like")
                            query.whereKey("user", equalTo: user)
                            
                            query.findObjectsInBackgroundWithBlock{ (activities, error) in
                                if let activities = activities {
                                    for a in activities {
                                        a.deleteInBackgroundWithBlock{ (success, error) in
                                            if success {
                                                print("Successfully deleted")
                                            } else {
                                                print("error: \(error)")
                                            }
                                        }
                                    }
                                }
                            
                            }
                        }

                        
                        print("Got rid of that sucker")
                    } else {
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    
    let animationDuration = 1.0
    let animationDelay = 0.0
    
    func tapAnimation() {
        // set heartAnimationView to be very tiny and not hidden
        self.heartAnimationView.hidden = false
        self.heartAnimationView.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(animationDuration, delay: animationDelay, options: [], animations: { () -> Void in
            
            // transfor, heartAnimationView to be 3X larger
            self.heartAnimationView.transform = CGAffineTransformMakeScale(3, 3)
            
        }) { (success) -> Void in
            
            // when animation is complete set heartAnimationView to be hidden
            self.heartAnimationView.hidden = true
        }
        // Update parse to like post
        likeButtonClicked(likeButton)
    }

}