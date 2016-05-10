//
//  DetailViewController.swift
//  FeedNews
//
//  Created by fatih on 30/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var post:Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.rgb(242, green: 242, blue: 242)
        if let title = post?.title{
          navigationItem.title = title
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let fixedWidth = self.textV.frame.size.width
        self.textV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = self.textV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = self.textV.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.textV.frame = newFrame;
        self.scrolView.contentSize = CGSizeMake(self.view.frame.width, self.textV.frame.height + 150 + 10 )
        self.scrolView.invalidateIntrinsicContentSize()
        
    }
    let imageView : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .ScaleToFill   //ScaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.grayColor().CGColor
        iv.layer.borderWidth = 0.7
        iv.backgroundColor = UIColor.clearColor()
        return iv
    }()
    let textV : UITextView = {
    
        let tv = UITextView()
        tv.font = UIFont(name: "Avenir", size: 14) //systemFontOfSize(14)
        tv.scrollEnabled = false
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.rgb(59, green: 60, blue: 63)
        //tv.textAlignment = .Justified
        return tv
    }()
    let scrolView : UIScrollView = {
        let sv = UIScrollView()
        //sv.contentSize.height = 1000
        sv.translatesAutoresizingMaskIntoConstraints = false
        //sv.scrollEnabled = true
        return sv
    }()
    let contentView : UIView = {
        let sv = UIView()
        
        return sv
    }()
    let btn : UIButton = {
        let sv = UIButton()
        sv.backgroundColor = UIColor.greenColor()
        sv.titleLabel?.text = "dfvdfvdfv"
        return sv
    }()
    let indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .Gray
        indicator.color = UIColor.blueColor()
        indicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        return indicator
    }()

    func setupViews(){
        scrolView.contentSize = CGSizeMake(400, 2300)
        indicator.startAnimating()
        self.view.addSubview(scrolView)
        self.scrolView.addSubview(contentView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(textV)
        //self.contentView.addSubview(btn)
        self.scrolView.addSubview(indicator)
        addConstraint()
        getData()
      
    }
    func addConstraint(){
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrolView]))
        self.view.addConstraintsWithFormat("H:|-0-[v0]-0-|", views: contentView)
        self.view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        self.view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textV)
        //self.view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: btn)
        //self.view.addConstraintsWithFormat("V:|[v0]|", views: scrolView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrolView]))
       
        self.view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Width , relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
         self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterX , relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
         self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterY , relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraintsWithFormat("V:|-0-[v0]-0-|", views: contentView)
        self.view.addConstraintsWithFormat("V:|-5-[v0(150)][v1]", views: imageView,textV)
        //self.view.addConstraintsWithFormat("V:[v0(80)][v1]", views: imageView,textV)
    }
 
    func getData(){
        print(post!.link!)
        let url = NSURL(string: "http://198.38.92.235:8081/getData?url=" + post!.link!)
        //let url = "http://198.38.92.235:8081/getData?url=http://www.hurriyet.com.tr/real-betis-0-2-barcelona-40097396"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)
            {
                (data, response, error) in
                if(error != nil){
                
                    print("lost connection")
                    dispatch_async(dispatch_get_main_queue(), {
                    
                        self.indicator.stopAnimating()
                    })
                    return
                }
                do {
                    //NSJSONReadingOptions.MutableContainers
                    //var buffer = [UInt8](count:data!.length, repeatedValue:0)
                    //data!.getBytes(&buffer, length:data!.length)
                    //var datastring = String(bytes:buffer, encoding:NSUTF8StringEncoding)
                    //print(datastring)
                    
                    let  sjson = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    let jdata = sjson.dataUsingEncoding(NSUTF8StringEncoding)
                    let json = try NSJSONSerialization.JSONObjectWithData( jdata!, options: NSJSONReadingOptions.AllowFragments) //NSJSONSerialization.JSONObjectWithData(jdata!, options: .AllowFragments)
                    
                    if let img = json["img"] as? String ,let pr = json["pr"] as? String{
                        print("img:\(img)")
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        
                            self.indicator.stopAnimating()
                            let url2 = NSURL(string: img)
                            NSURLSession.sharedSession().dataTaskWithURL(url2!)
                                {
                                    
                                    (data2,response,error2) in
                                    if(error2 != nil){
                                    
                                        print("picture upload error")
                                        return
                                    }
                                    dispatch_async(dispatch_get_main_queue(), {
                                        let img = UIImage(data:data2!)
                                        self.imageView.image = img;
                                    })
                                    
                                }.resume()
                            do
                            {
                                
                                let style = NSMutableParagraphStyle()
                                style.lineSpacing = 5
                                let attributes = [ NSParagraphStyleAttributeName : style ]
                                self.textV.attributedText = NSAttributedString(string: pr.replace("##", withString:"\""), attributes: attributes)
                                //self.textV.translatesAutoresizingMaskIntoConstraints = false
                                let fixedWidth = self.textV.frame.size.width
                                self.textV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                let newSize = self.textV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                var newFrame = self.textV.frame
                                newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                                self.textV.frame = newFrame;
                                self.scrolView.contentSize = CGSizeMake(self.view.frame.width, self.textV.frame.height + 150 + 10 )
                                //self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.textV.frame.height + 150 + 20)
                                //self.view.reloadInputViews()
                            
                            }catch let err {
                                // print("\(err)")
                            }
                            
                          
                        })
                        
                        
                    }
                } catch
                {
                    print("error serializing JSON: \(error)")
                    //self.spc.stopAnimating()
                }
        }
        task.resume()
        
        
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
