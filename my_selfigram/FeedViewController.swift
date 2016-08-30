//
//  FeedViewController.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-15.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query(){
            query.orderByDescending("createdAt")
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock { (data, error) in
                guard let posts = data as? [Post] else {
                    return
                }
                self.posts = posts
                self.tableView.reloadData()
            }
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Function returns a cell with identifier
        // I want to use a cell in the reuse pool with the given identifier
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SelfieCell
        let post = posts[indexPath.row]
        
        cell.commentLabel.text     = post.comment
        cell.usernameLabel.text    = post.user.username
        
        // Unpack image PFFile to be read as UIImage
        if let imageFile = post.image as? PFFile {
            // Set profileImageView to currentUser avatar
            imageFile.getDataInBackgroundWithBlock{ (data, error) in
                if let imageData = data {
                    cell.selfieImageView.image = UIImage(data: imageData)
                }
            }
        }

        return cell
    }

    @IBAction func cameraButtonPressed(sender: AnyObject) {
        
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .PhotoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        // Preset the pickerController on screen
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if  let imageData      = UIImageJPEGRepresentation(image, 0.9),
                let imageFile      = PFFile(data: imageData),
                let user           = PFUser.currentUser(),
                let comment:String = "This is a selfie"
            {
                // Initialize new post after image picking done
                let post = Post.init(image: imageFile, user: user, comment: comment)
                
                // Save new selfie
                post.saveInBackgroundWithBlock{ (success, error) in
                    if success {
                        print("Saved to Parse!")
                        
                        // Insert new selfie at index 0
                        self.posts.insert(post, atIndex: 0)
                        
                        // Show new selfie with animation
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                }
            
            }
            
//            //2. We create a Post object from the image
//            let user = User(username: "Eunice", profileImage: UIImage(named: "Grumpy-Cat")!)
//            
//            let post = Post(image: image, user: user, comment: "This is the same selfie as everyone else")
//
//            //3. Add post to our posts array
//            //    Adds it to the very top of our array
//            posts.insert(post, atIndex: 0)
            
        }
        
        //4. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
        //5. Now that we have added a post, reload our table
        tableView.reloadData()

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
