//
//  Tweet.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

class Tweet {
    //MARK: Properties
    private var tweetData:NSDictionary = NSDictionary();
    private var userData:NSDictionary = NSDictionary();
    
    //MARK: Methods
    func setTweetData( data:NSDictionary ) {
        tweetData = data;
        userData = tweetData["user"] as NSDictionary;
    }
    
    // Generic Getter for string
    func stringForAttribute( attr:String, inUserData:Bool ) -> String {
        let dict = (inUserData ? userData : tweetData );
        var out = dict[attr] as? String
        if( nil != out ) {
            return out!
        } else {
            return "" // TODO: check if to use "" or nil
        }
    }
    
    // Generic Getter for number // TODO: do we need it really ?
    
    // Actual attributes
    func userName() -> String {
        return stringForAttribute("name", inUserData: true)
    }
    
    func userHandle() -> String {
        return stringForAttribute("screen_name", inUserData: true)
    }
    
    func tweetText() -> String {
        return stringForAttribute("text", inUserData: false)
    }
    
    func userProfilePicUrlString() -> String {
        return stringForAttribute("profile_image_url", inUserData: true)
    }
    
}