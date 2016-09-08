//
//  ProfileViewController.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-08.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
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
            // setting the compression quality to 90%
            if  let imageData = UIImageJPEGRepresentation(image, 0.9),
                let imageFile = PFFile(data: imageData),
                let user      = PFUser.currentUser(){
                    // avatarImage is a new column in our User table
                    user["avatarImage"] = imageFile
                    user.saveInBackgroundWithBlock({ (success, error) in
                        if success {
                            // Show uploaded image as profile picture
                            let image = UIImage(data: imageData)
                            self.profileImageView.image = image
                        }
                    })
                }
        }
        
        
        
        
        
//        
//        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            //2. To our imageView, we set the image property to be the image the user has chosen
//            profileImageView.image = image
//            
//        }
        
        //3. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        usernameLabel.text = "Heather"
        
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure user == currentUser
        guard let user = PFUser.currentUser() else {
            return
        }
        // Set usernameLabel to currentUser username
        usernameLabel.text = user.username
        
        // Ensure imageFile == currentUser.avatarImage
        guard let imageFile = user["avatarImage"] as? PFFile else {
            return
        }
        // Set profileImageView to currentUser avatar
        imageFile.getDataInBackgroundWithBlock{ (data, error) in
            if let imageData = data {
                self.profileImageView.image = UIImage(data: imageData)
            }
        }
        
        
//        if let user = PFUser.currentUser(){
//            usernameLabel.text = user.username
//            if let imageFile = user["avatarImage"] as? PFFile {
//                imageFile.getDataInBackgroundWithBlock{ (data, error) in
//                    if let imageData = data {
//                        self.profileImageView.image = UIImage(data: imageData)
//                    }
//                }
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
