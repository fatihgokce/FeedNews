//
//  FeedCell.swift
//  FeedNews
//
//  Created by fatih on 02/05/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit

protocol  FeedCellDelegate {
    func isLogin()
    func shareTwitter(text : String)
    func shareFacebook(text : String)
}


class FeedCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    var delegate:FeedCellDelegate?
    var post: Post?{
        didSet{
            if let name = post?.title, let newName = post?.sourceName
            {
                labelTitle.text = name
                labelSourceName.text = newName
            }
            if let link = post?.link {
                
                labelLink.text = link
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("ddd")
    }
    var appsCollectionView: UICollectionView!
    let appsCollectionView2: UIView = {
        
        let v = UIView(frame: CGRect())
        v.backgroundColor = UIColor.greenColor()
        return v
    }()
    let labelTitle :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(34, green: 34, blue: 34)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    let labelSourceName :UILabel = {
        let label = UILabel()
        //label.text="Sample name"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor(red: 155/255, green: 161/255, blue: 172/255, alpha: 1)
        return label
    }()
    let labelLink :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(102, green: 152, blue: 187)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    let btnHapy = FeedCell.buttonForTitle("654", imageName: "emo1")
    
    let btnNrm = FeedCell.buttonForTitle("21", imageName: "emo2")
    let btnUnHapy = FeedCell.buttonForTitle("32", imageName: "emo3")
    let labelHapyCount :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(54, green: 55, blue: 56)
        label.font = UIFont.systemFontOfSize(12)
        
        return label
    }()
    let labelUnHapyCount :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(54, green: 55, blue: 56)
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    let labelNrmCount :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(54, green: 55, blue: 56)
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    let txtComment: UITextField = {
        
        let tf = UITextField()
        tf.font = UIFont.systemFontOfSize(13)
        tf.placeholder = "Add your comment"
        tf.textColor = UIColor.rgb(185, green: 181, blue: 181)
        //tf.backgroundColor = UIColor.greenColor()
        tf.layer.borderColor =  UIColor.grayColor().CGColor
        tf.layer.borderWidth = 0.7
        tf.layer.cornerRadius = 5.0
        tf.layer.masksToBounds = true
        tf.textAlignment = .Center
        return tf
    }()
    let btnSend : UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.textAlignment = .Right
        btn.backgroundColor = UIColor(red: 7/255, green: 117/255, blue: 160/255, alpha: 1)
        //btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: -10)
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        return  btn
    }()
    let btnTwitter : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "twitter"), forState: .Normal)
        return  btn
    }()
    let btnFacebook : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "fb"), forState: .Normal)
        return  btn
    }()
    func btnTouchHapy(sender: UIButton){
        print ("dscds")
        
    }
    func btnSendCommentTouch(sender: UIButton)
    {
        if delegate != nil
        {
        if let cmt = txtComment.text
        {
            //let comment = Comment()
            //comment.cmTitle = cmt
            //comment.userName = "Fatih"
            //post?.comments.insert(comment, atIndex: 0)
            //appsCollectionView.reloadData()
            //let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            //appsCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)
            self.delegate?.isLogin()
            
            //let newIndexPath = NSIndexPath(forRow: post!.comments.count, inSection: 0)
            //appsCollectionView.insertItemsAtIndexPaths([newIndexPath]
            //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,UIScreen.mainScreen().bounds.width, 340)
            //mainColectionView!.frame = CGRectMake(mainColectionView!.frame.origin.x, mainColectionView!.frame.origin.y,UIScreen.mainScreen().bounds.width, 350)
            
        }
        }
     
    }
    func tappedFacebook(sender: UIButton){
        if self.delegate != nil && self.labelTitle.text != nil {
            
            self.delegate?.shareFacebook((self.post?.title!)!)
        }
        
    }
    func tappedTwitter(sender : UIButton){
    
        if self.delegate != nil && self.post?.title != nil {
            
            self.delegate?.shareTwitter((self.post?.title!)!)
        }
    }
    func setupViews(){
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .Vertical 
        
        appsCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)  //(frame, collectionViewLayout: layout)
        
        appsCollectionView.backgroundColor = UIColor.clearColor()
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        appsCollectionView.alwaysBounceVertical = true
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        appsCollectionView.registerClass(CommentCell.self, forCellWithReuseIdentifier: "commentid")
        
        btnHapy.addTarget(self, action: #selector(FeedCell.btnTouchHapy(_:)), forControlEvents: .TouchDown)
        btnSend.addTarget(self, action: Selector("btnSendCommentTouch:"), forControlEvents: .TouchDown)
        btnFacebook.addTarget(self, action: #selector(FeedCell.tappedFacebook(_:)), forControlEvents: .TouchDown)
        
        btnTwitter.addTarget(self, action: #selector(FeedCell.tappedTwitter(_:)), forControlEvents: .TouchDown)
        
       
        addSubview(labelTitle)
        addSubview(labelSourceName)
        addSubview(labelLink)
        addSubview(btnHapy)
        addSubview(btnNrm)
        addSubview(btnUnHapy)
        addSubview(appsCollectionView)
        addSubview(txtComment)
        addSubview(btnSend)
        addSubview(btnTwitter)
        addSubview(btnFacebook)
        
        
        
        
        //button.addTarget(self, action:Selector("ratingButtonTapped:"), forControlEvents: .TouchDown)
        //let horizontalConstraintsRedBlue = NSLayoutConstraint.constraintsWithVisualFormat("H:|-spacing-[red(>=lowWidth,<=highWidth@priority)]-redBlueSpacing-[blue(==red)]-spacing-|", options: NSLayoutFormatOptions(), metrics: metrics, views: views)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: labelTitle)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: labelSourceName)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: labelLink)
        addConstraintsWithFormat("H:|-8-[v0(v2)][v1(v2)][v2(>=95,<=140)]", views: btnHapy,btnNrm,btnUnHapy)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
        addConstraintsWithFormat("H:|-8-[v0(>=100)]-8-[v1(<=60)]-8-|", views: txtComment,btnSend)
        addConstraintsWithFormat("H:|-8-[v0]-12-[v1]", views: btnTwitter,btnFacebook)
        
        
        //addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .Top,
        //   relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 1.0))
        
        addConstraintsWithFormat("V:|-5-[v0][v1]", views: labelTitle,labelSourceName)
        //addConstraintsWithFormat("V:[v0(30)]-[v1]", views: labelTitle,labelSourceName)
        addConstraintsWithFormat("V:[v0][v1]", views: labelSourceName,labelLink)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnHapy)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnNrm)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnUnHapy)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: btnUnHapy,appsCollectionView)
        addConstraintsWithFormat("V:[v0]-6-[v1]", views: appsCollectionView,btnTwitter)
        
        addConstraintsWithFormat("V:[v0(32)]-3-|", views: txtComment)
        addConstraintsWithFormat("V:[v0(32)]-3-|", views:btnSend)
        addConstraintsWithFormat("V:[v0]-8-[v1]", views: btnTwitter,txtComment)
        addConstraintsWithFormat("V:[v0]-8-[v1]", views: btnFacebook,txtComment)
        
    }
    
    
    static func buttonForTitle(title: String,imageName : String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, forState: .Normal)
        btn.setTitleColor(UIColor.rgb(54, green: 55, blue: 56), forState: .Normal)
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: -10)
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        
        return  btn
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = post?.comments.count {
            return count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("commentid", forIndexPath: indexPath) as! CommentCell
        cell.comment = post?.comments[indexPath.row]
        
        if totalHeigt < 200 {
            //appsCollectionView.frame = CGRectMake(appsCollectionView.frame.origin.x, appsCollectionView.frame.origin.y,UIScreen.mainScreen().bounds.width, totalHeigt)
            
        }
        return cell
    }
    var totalHeigt:CGFloat = 0
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*
        if let statusText = posts[indexPath.row].statusText
        {
        let rect = NSString(string: statusText).boundingRectWithSize(CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
        let knownHeiht:CGFloat = 8 + 44 + 4+4+200+8+24+8+44
        return CGSizeMake(view.frame.width, rect.height + knownHeiht + 16)
        }
        */
        var height:CGFloat = 5
        let kh:CGFloat =  5
        if let title = post?.comments[indexPath.row].cmTitle {
            
            height =  (post?.comments[indexPath.row].userName?.calculateHeight(UIFont.systemFontOfSize(12)))! + (post?.comments[indexPath.row].cmTitle?.calculateHeight(UIFont.systemFontOfSize(13)))!
            if height > 50
            {
                height = 40
            }
        }
        print("cah:\(height + kh)")
        height = height + kh
        totalHeigt += height
        
        //addConstraintsWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
        //addConstraintsWithFormat("V:[v0]-10-[v1(>=" + String(height)  + ")]", views: btnUnHapy,appsCollectionView)
        return CGSizeMake(UIScreen.mainScreen().bounds.width - 16, height)
    }
    
    
}