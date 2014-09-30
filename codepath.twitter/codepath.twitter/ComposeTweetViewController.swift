//
//  ComposeTweetViewController.swift
//  codepath.twitter
//
//  Created by vr on 9/29/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    var tweetButton:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // TODO: add tweet button
        tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "doTweet")
        self.navigationItem.rightBarButtonItem = tweetButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
