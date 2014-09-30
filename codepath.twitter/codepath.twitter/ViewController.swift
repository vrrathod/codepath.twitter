//
//  ViewController.swift
//  codepath.twitter
//
//  Created by vr on 9/27/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Table data
    var tableData = NSArray()
    
    // Pull handler
    var pullHandler:UIRefreshControl = UIRefreshControl();
    var isPulled = false;
    
    // MARK: - Overrides and Blocks
    
    // Block to handle completion of the tweets query
    func tweetStreamCompletionBlock( success:Bool, dataArray:NSArray!, error:NSError!) -> Void {
        if success {
            NSLog("\(dataArray)")
            self.tableData = dataArray // TODO: append data?
            self.tableView.reloadData()
        } else {
            NSLog("Error! \(error?.localizedDescription)")
        }
        
        if self.isPulled{
            self.pullHandler.endRefreshing()
            self.isPulled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TwitterClient.sharedClient.getHomeTimeLine(tweetStreamCompletionBlock);
        
        // setup pull handler
        pullHandler.attributedTitle = NSAttributedString(string: "Pull Me!")
        pullHandler.tintColor = UIColor.redColor()
        pullHandler.addTarget(self, action: "updateTweetStream:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(pullHandler)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TwitterTableViewCell = tableView.dequeueReusableCellWithIdentifier(TwitterConstant.twitterTableRowConst) as TwitterTableViewCell
        
        cell.setTweetData(tableData.objectAtIndex(indexPath.row) as NSDictionary)
        cell.sizeToFit()
        
        return cell
    }

    func updateTweetStream( sender: AnyObject? ) {
        self.isPulled = true;
        TwitterClient.sharedClient.getHomeTimeLine(tweetStreamCompletionBlock)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == TwitterConstant.tweetDetailsSegueName {
            let dest = segue.destinationViewController as TweetDetailsViewController
            if let cell = sender as? TwitterTableViewCell {
                dest.setTweetInfo(cell.tweetInfo)
                if let img = cell.userProfileImage.image as UIImage? {
                    dest.setUserProfilePic( img )
                }
            }
        } else if segue.identifier == TwitterConstant.twitterNewTweetSegueName {
            NSLog("Creating new tweet ...");
        }
    }

}

