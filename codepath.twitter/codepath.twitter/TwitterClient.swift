//
//  Twitter.swift
//  codepath.twitter
//
//  Created by vr on 9/27/14.
//  Copyright (c) 2014 vr. All rights reserved.
//

import Foundation
import Social
import Accounts

class TwitterClient {
    
    let DefaultsAccountID = "TwitterAccountID"
    let DefaultsHomeTimeLine = "TwitterHomeTimeLine"
    
    let accountStore:ACAccountStore?
    let accountType:ACAccountType?
    var account:ACAccount?
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
    
    // --- --- --- --- --- --- ---
    // MARK: - SETUP
    // --- --- --- --- --- --- ---
    
    class var sharedClient: TwitterClient {
    struct Static {
        static let instance = TwitterClient();
        }
        return Static.instance;
    }
    
    init(){
        // Read account settings from the iOS system
        accountStore = ACAccountStore()
        accountType = accountStore?.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // load the id if serialized, if not make an async request
        if !deserializeAndLoadAccountID() {
            requestAccountID( true )
        } else {
            printAccount()
        }
    }
    
    /*
    * This function shall request account from the ACAccountStore.
    * @param withSerializtion, Bool value, if true will store accountID with DefaultsAccountID const as key
    * @return nothing
    */
    func requestAccountID( withSerialization:Bool ) {
        
        // if we have deserialized account already, we dont need to request it
        if( nil != account ) {
            NSLog("We already have account. Bailing out!")
            return
        }
        
        // well, we dont have any account, lets ask for one.
        accountStore?.requestAccessToAccountsWithType(accountType, options: nil, completion: { (found, error) -> Void in
            if found {
                let accounts = self.accountStore?.accountsWithAccountType(self.accountType?) as NSArray?
                if let lastAccount: ACAccount = accounts?.lastObject as? ACAccount {
                    self.account = lastAccount
                    NSLog("Block:Account: \(self.account)")
                    if withSerialization {
                        self.serializeAccountID()
                    }
                }
            }
        })
    }
    
    //-------------------------------------------------------------------------------------
    // MARK: - Serialization
    //-------------------------------------------------------------------------------------
    /*
    * This function shall read the serialized account identifier. If the account identifieer is available,
    * it shall try loading the accout value.
    * @param None
    * @return Bool, true if accountID as well as a valid account associated with that ID is found.
    */
    func deserializeAndLoadAccountID() -> Bool {
        var accountID = NSUserDefaults.standardUserDefaults().valueForKey(DefaultsAccountID) as? NSString
        // if the id is available, search the store for the id
        if nil != accountID {
            account = accountStore?.accountWithIdentifier(accountID) as ACAccount?
        }
        
        // return true if account is loaded, false otherwise
        return ( nil != account)
    }
    
    /*
    * This function shall serialize account identifier for currently available account
    */
    func serializeAccountID() {
        if let accountIdentifier = account?.identifier {
            var standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setObject(accountIdentifier, forKey: self.DefaultsAccountID)
            standardDefaults.synchronize()
        }
    }
    
    func serializeHomeTimeLine( value:NSArray? ) {
        if (nil != value) {
            var standardDefaults = NSUserDefaults.standardUserDefaults()
            standardDefaults.setObject( value, forKey: DefaultsHomeTimeLine )
            standardDefaults.synchronize()
        }
    }
    
    func deSerializeHomeTimeLine() -> NSArray? {
        return NSUserDefaults.standardUserDefaults().valueForKey(DefaultsHomeTimeLine) as NSArray?;
    }
    
    // --- --- --- --- --- --- ---
    // MARK: - Util
    // --- --- --- --- --- --- ---
    func printAccount() {
        NSLog("Account = \(account)")
    }
    
    
    // --- --- --- --- --- --- ---
    // MARK: - Twitter Interaction -
    // --- --- --- --- --- --- ---
    func getHomeTimeLine( completionHandler:((Bool, NSArray!, NSError!) -> Void)? ) -> NSArray {
        var outputArray = NSArray();
        
        let url = NSURL( string: TwitterConstant.home_timeLine )
        
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog(" error fetching data : \(error.localizedDescription) ")
                if (nil != completionHandler) {
                    completionHandler!(false, outputArray, error)
                }
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        outputArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
                        if (nil != completionHandler) {
                            completionHandler!(true, outputArray, nil)
                        }
                    } else if (nil != completionHandler) {
                        var localizedDescription:NSString = "Twitter returned \(httpResponse.statusCode)"
                        var err = NSError(domain: "Twitter", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
                        completionHandler!(false, outputArray, err);
                    }
                }
            }
        })
        
        task.resume()
        
        return outputArray;
    }
    
    func retweet( tweetId:String ) {
        var stringURL = "\(TwitterConstant.retweetURL)\(tweetId).json"
        let url = NSURL( string: stringURL )
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog("Error re-tweeting. \(error.localizedDescription)")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        NSLog("retweet succeeded")
                    } else {
                        NSLog( "Twitter returned \(httpResponse.statusCode)" )
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func favorite( tweetId:String ) {
        var stringURL = "\(TwitterConstant.favoriteURL)\(tweetId)"
        let url = NSURL( string: stringURL )
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: nil)
        authRequest.account = account
        
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                NSLog("Error favoriting!. \(error.localizedDescription)")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        NSLog("favorite succeeded")
                    } else {
                        NSLog( "Fav: Twitter returned \(httpResponse.statusCode)" )
                    }
                }
            }
        })
        
        task.resume()
    }
    
}