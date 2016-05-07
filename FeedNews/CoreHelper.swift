//
//  CoreHelper.swift
//  FeedNews
//
//  Created by fatih on 06/05/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import Foundation
public class Reachability {
    
    class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
        _ = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        }
        catch {
            Status = false

        }
        return Status
    }
}