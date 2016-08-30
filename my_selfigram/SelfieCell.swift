//
//  SelfieCell.swift
//  my_selfigram
//
//  Created by Heather on 2016-08-17.
//  Copyright © 2016 Heather. All rights reserved.
//

import UIKit

class SelfieCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

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
    
    
    @IBAction func likeButtonClicked(sender: UIButton) {
        sender.selected = !sender.selected
    }

}