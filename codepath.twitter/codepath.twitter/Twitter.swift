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
    
    let accountStore:ACAccountStore?
    let accountType:ACAccountType?
    var account:ACAccount?
    
    // --- --- --- --- --- --- ---
    // MARK: SETUP
    // --- --- --- --- --- --- ---
    init(){
        // Read account settings from the iOS system
        accountStore = ACAccountStore()
        accountType = accountStore?.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)

        // load the id if serialized, if not make an async request
        if !deserializeAndLoadAccountID() {
            requestAccountID( true );
        } else {
            printAccount();
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
            NSLog("We already have account. Bailing out!");
            return;
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
    
    // --- --- --- --- --- --- ---
    // MARK: Describe
    // --- --- --- --- --- --- ---
    func printAccount() {
        NSLog("Account = \(account)")
    }
    
    
}