//
//  Models.swift
//  FeedNews
//
//  Created by fatih on 28/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import Foundation
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
    static var userName:String?
    static var email:String?
    
    static func isLogin() -> Bool
    {
        if let token = FBSDKAccessToken.currentAccessToken() {
            return true
        }else{
            print("baglanti yok")
        }
      return false
    }
}