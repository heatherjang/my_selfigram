//
//  FeedViewController.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-15.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var posts: [Post] = []
    
    let searchTag = "puppies"
    let flickrApiKey = "d3b64787397f7fabc91f2b9b8992f719"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flickrApiUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=\(flickrApiKey)&tags=\(searchTag)"
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: flickrApiUrl)!) { (data, response, error) in
            
            // convert NSData to JSON
            if let jsonUnformatted = try? NSJSONSerialization.JSONObjectWithData(data!, options: []),
                let json = jsonUnformatted as? [String: AnyObject],
                let photosDictionary = json["photos"] as? [String: AnyObject],
                let photosArray = photosDictionary["photo"] as? [[String: AnyObject]]
            {
                for photo in photosArray {
                    if  let farmID   = photo["farm"] as? Int,
                        let serverId = photo["server"] as? String,
                        let photoId  = photo["id"] as? String,
                        let secret   = photo["secret"] as? String {
                        
                        let photoUrlString = "https://farm\(farmID).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
                        if let photoUrl = NSURL(string: photoUrlString) {
                            let user = User(username: "Heather", profileImage: UIImage(named: "Grumpy-Cat")!)
                            let post = Post(image: photoUrl, user: user, comment: "Some Dog from Flickr")
                            self.posts.append(post)
                        }
                    }
                    
                    // We use dispatch_async because we need update all UI elements on the main thread.
                    // This is a rule and you will see this again whenever you are updating UI.
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                    
                
                }
            } else {
                print("error with response data")
            }
            
        }
        
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")
        
        
//        let heather = User(username: "heather", profileImage: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: heather, comment: "You can read minds?")
//        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: heather, comment: "What's up, Doc?")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: heather, comment: "What is this, a school for ants?")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: heather, comment: "Heather's school for kids who don't read good")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: heather, comment: "I want a hippopotamus for Christmas.")
//        
//        posts = [post0, post1, post2, post3, post4]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        
        let task = NSURLSession.sharedSession().downloadTaskWithURL(post.image) { (url, response, error) -> Void in
            if  let image = url,
                let imageData = NSData(contentsOfURL: image)
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    cell.selfieImageView.image = UIImage(data: imageData)
                    
                })
                
            }
        }
        
        task.resume()

        cell.commentLabel.text = post.comment
        cell.usernameLabel.text = post.user.username
        

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
        
//        // 1. When the delegate method is returned, it passes along a dictionary called info.
//        //    This dictionary contains multiple things that maybe useful to us.
//        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
//        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            //2. We create a Post object from the image
//            let user = User(username: "Eunice", profileImage: UIImage(named: "Grumpy-Cat")!)
//            
//            let post = Post(image: image, user: user, comment: "This is the same selfie as everyone else")
//
//            //3. Add post to our posts array
//            //    Adds it to the very top of our array
//            posts.insert(post, atIndex: 0)
//            
//        }
//        
//        //4. We remember to dismiss the Image Picker from our screen.
//        dismissViewControllerAnimated(true, completion: nil)
//        
//        //5. Now that we have added a post, reload our table
//        tableView.reloadData()

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
