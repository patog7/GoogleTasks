//
//  GAuthViewController.swift
//  GoogleTasks
//
//  Created by Patricio González on 4/9/15.
//  Copyright (c) 2015 Patricio Gonz&#225;lez. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public var signIn : GPPSignIn?
public var token: NSString?



class GAuthViewController: UIViewController, GPPSignInDelegate {

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
//        signIn?.shouldFetchGoogleUserEmail = true
//        signIn?.shouldFetchGoogleUserID = true
        signIn?.clientID = "513906017570-d3m71qqqen703vtg4nhu6jn1ntjhlg1c.apps.googleusercontent.com"
        signIn?.scopes = ["https://www.googleapis.com/auth/tasks"]
        signIn?.delegate = self
//        signIn?.authenticate()
        signIn?.trySilentAuthentication()
        
    }
    
    
    @IBOutlet weak var signInButton: UIButton!

    
    @IBAction func customSignIn(sender: AnyObject) {
        
        signIn?.authenticate()
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error != nil{
            println ("error! -> \(error)")
        }
        else{
//            gplusButton.hidden = true
            println ("auth! -> \(auth)")

            let url = NSURL(string: "https://www.googleapis.com/tasks/v1/users/@me/lists" )
             token = auth.accessToken
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            self.performSegueWithIdentifier("signinSeg", sender: self)

        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send
        var newSignIn = signIn
        var newToken = token
        
        var svc = segue.destinationViewController as! ViewController;
        
        svc.signIn = newSignIn
    }
    
    
    
}
    