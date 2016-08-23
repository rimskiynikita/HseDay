//
//  LoginViewController.swift
//  HseDay
//
//  Created by Никита Римский on 23.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFacebook()
    }
    
    func configureFacebook() {
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbLoginButton.delegate = self
    }
    
    @IBAction func vkLogin(sender: AnyObject) {
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        performSegueWithIdentifier("unwindBackToTent", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
}
