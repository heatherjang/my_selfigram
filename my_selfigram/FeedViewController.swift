//
//  FeedViewController.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-15.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    
    var words = ["Hello", "my", "name", "is", "Selfigram"]
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heather = User(username: "heather", profileImage: UIImage(named: "Grumpy-Cat")!)
        let post0 = Post(image: heather.profileImage, user: heather, comment: "You can read minds?")
        let post1 = Post(image: heather.profileImage, user: heather, comment: "What's up, Doc?")
        let post2 = Post(image: heather.profileImage, user: heather, comment: "What is this, a school for ants?")
        let post3 = Post(image: heather.profileImage, user: heather, comment: "Heather's school for kids who don't read good")
        let post4 = Post(image: heather.profileImage, user: heather, comment: "I want a hippopotamus for Christmas.")
        
        posts = [post0, post1, post2, post3, post4]
        
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath)
        let post = posts[indexPath.row]
        
        cell.imageView?.image = post.image
        cell.textLabel?.text = post.comment
        
//        cell.textLabel?.text = words[indexPath.row]
        

        return cell
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
