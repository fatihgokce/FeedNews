//
//  Models.swift
//  FeedNews
//
//  Created by fatih on 28/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import Foundation
import Google
class Post {
    var title : String?
    var sourceName: String?
    var link: String?
    var cntHapy: Int?
    var cntNrm: Int?
    var cntUnHapy: Int?
    var comments = [Comment]()
}
class Comment{
    var cmTitle:String?
    var userName:String?
}
class User{
    static var name:String?
    static var email:String?
  
    static func isLogin() -> Bool
    {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            if User.email == nil {
               fetchProfile()
            }
            return true
        }else{
            if let cu = GIDSignIn.sharedInstance().currentUser {
                User.name = cu.profile.name
                User.email = cu.profile.email
                return true
                
            }
        }
      return false
    }
    static func fetchProfile(){
        let prm = ["fields": "email,first_name,last_name"]
        FBSDKGraphRequest(graphPath: "me", parameters: prm).startWithCompletionHandler
            {
                
                (connection, result, error) -> Void in
                if(error != nil){
                    print("facebook baglanti sorunu")
                    return
                }
                User.email = result["email"] as? String
                User.name = result["first_name"] as? String
                
        }
    }
}