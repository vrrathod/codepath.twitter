//
//  ComposeTweetViewController.swift
//  codepath.twitter
//
//  Created by vr on 9/29/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    //MARK: - outlets
    var currentMessage:String = ""
    var tweetButton:UIBarButtonItem?
    var userImage:UIImage?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var userStatusUpdate: UITextView!
    @IBOutlet weak var countDown: UILabel!
    
    // MARK: - Setup
    func setUserImage( image:UIImage? ) {
        userImage = image;
    }
    
    // MARK: - UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // TODO: add tweet button
        tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Bordered, target: self, action: "doTweet")
        self.navigationItem.rightBarButtonItem = tweetButton
        
        // User details
        userName.text = TwitterClient.sharedClient.userName()
        userHandle.text = TwitterClient.sharedClient.userHandle()
        if nil != userImage {
            profileImage.image = userImage!;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Action
    func doTweet() {
        let status = userStatusUpdate.text as String
        TwitterClient.sharedClient.doTweet( status )
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //MARK: - TextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if( textView == userStatusUpdate ) {
            let len = countElements( textView.text )
            if( len >= 140 ){
                flashCountDown()
                textView.text = currentMessage
            } else {
                currentMessage = textView.text
                countDown.text = "\(len)/140"
            }
        }
    }
    
    func flashCountDown() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.countDown.alpha = 0;
        }) { (status) -> Void in
            self.countDown.alpha = 1;
        }
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
