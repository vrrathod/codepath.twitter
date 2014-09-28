//
//  TwitterTableViewCell.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweet: UILabel!
    
    var tweetInfo:Tweet = Tweet()

    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Set Data
    func setTweetData( tweetData:NSDictionary ) {
        tweetInfo.setTweetData(tweetData)
        
        userName.text = tweetInfo.userName()
        userHandle.text = "@\(tweetInfo.userHandle())"
        tweet.text = tweetInfo.tweetText()
    }
    
    

}
