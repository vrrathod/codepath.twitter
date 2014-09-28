//
//  ViewController.swift
//  codepath.twitter
//
//  Created by vr on 9/27/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tweetStreamTableView: UITableView!
    
    // Table data
    var tableData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetStreamTableView.rowHeight = UITableViewAutomaticDimension;
        
        // Do any additional setup after loading the view, typically from a nib.
        var t = TwitterClient();
        t.getHomeTimeLine { (success, dataArray, error) -> Void in
            if success {
                NSLog("\(dataArray)")
                self.tableData = dataArray
                self.tweetStreamTableView.reloadData()
                
            } else {
                NSLog("Error! \(error?.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TwitterTableViewCell = tableView.dequeueReusableCellWithIdentifier(TwitterConstant.twitterTableRowConst()) as TwitterTableViewCell
        
        cell.setTweetData(tableData.objectAtIndex(indexPath.row) as NSDictionary)
        
        return cell
    }


}

