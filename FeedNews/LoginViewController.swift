//
//  LoginViewController.swift
//  FeedNews
//
//  Created by fatih on 05/05/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit
import Google
class LoginViewController: UIViewController ,GIDSignInUIDelegate ,FBSDKLoginButtonDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        self.view.addSubview(loginButton)
        //loginButton.center = view.center
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        btnGoogle.translatesAutoresizingMaskIntoConstraints = false
        //btnGoogle.addTarget(self, action: #selector(LoginViewController.testTap(_:)), forControlEvents: .TouchDown)
        self.view.addSubview(btnGoogle)
        setupViews()
        
       
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    let loginButton : FBSDKLoginButton = {
        
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        button.titleLabel?.text = "Facebook ile bağlan"
        return button
    }()
    let btnGoogle : GIDSignInButton = {
        
        let button = GIDSignInButton()
        
        return button
    }()
    func setupViews(){
        self.view.addConstraint(NSLayoutConstraint(item: btnGoogle, attribute: .Height , relatedBy: .Equal, toItem: loginButton, attribute: .Height, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: btnGoogle, attribute: .Width , relatedBy: .Equal, toItem: loginButton, attribute: .Width, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .CenterX , relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: loginButton, attribute: .CenterY , relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: btnGoogle, attribute: .CenterX , relatedBy: .Equal, toItem: loginButton, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: btnGoogle, attribute: .Top, relatedBy: .Equal, toItem: loginButton, attribute: .Bottom, multiplier: 1, constant: 20))
    }
    func testTap(sender:UIButton){
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
        }else{
            print("baglanti yok")
        }
        
    }
    func fetchProfile(){
        let prm = ["fields": "email,first_name,last_name"]
        FBSDKGraphRequest(graphPath: "me", parameters: prm).startWithCompletionHandler
        {
            
                (connection, result, error) -> Void in
            if(error != nil){
            print("facebook baglanti sorunu")
                return
            }
            
                print("\(result["email"]!) \(result["first_name"])")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed login")
        if let token = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
        }
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

