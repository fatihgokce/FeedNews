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
    var newName: String?
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