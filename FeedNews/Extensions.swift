//
//  Extensions.swift
//  FeedNews
//
//  Created by fatih on 28/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) ->UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
   
    
}
extension String{
    func calculateHeight(fnt: UIFont) -> CGFloat {
        //print(self)
        let rect = NSString(string: self).boundingRectWithSize(CGSize(width:UIScreen.mainScreen().bounds.width, height: 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName:  fnt], context: nil)
        //print("\(rect.height)--\(self)")
        return rect.height
    }
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
}
