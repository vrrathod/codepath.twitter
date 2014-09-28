//
//  TwitterContants.swift
//  codepath.twitter
//
//  Created by vr on 9/28/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation

class TwitterConstant {
    
    class func twitterTableRowConst() -> String {
        return "TwitterCell";
    }
    
    class func home_timeLine() -> String {
        return "https://api.twitter.com/1.1/statuses/home_timeline.json";
    }
    
    class func user_timeLine() -> String {
        return "https://api.twitter.com/1.1/statuses/user_timeline.json";
    }
    
}