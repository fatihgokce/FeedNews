//
//  ViewController.swift
//  FeedNews
//
//  Created by fatih on 27/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit
let cellId="cellId"
let commentCellId="CommentcellId"
let MAX_COMMENTS_HEIGT :Int = 200

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    let headerCell = "headerCellid"
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        initPost()
       
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //view.addSubview(indicator)
        collectionView?.backgroundColor = UIColor.rgb(242, green: 242, blue: 242)
        navigationItem.title = "New Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.registerClass(HeaderCell.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCell)
    }

    func initPost(){
        /*
        let post1 = Post()
        post1.title = "Demokrasi Paketi Açıklandı"
        post1.newName = "habertürk"
        post1.link = "http://www.hurriyet.com.tr/bursadaki-patlama-sonrasinda-ilk-supheli-o-orgut-40095672"
        let post2  = Post()
        post2.title = "Antalya Export başladı"
        post2.newName = "hürriyet"
        post2.link = "http://www.hurriyet.com.tr/bursadaki-patlama-sonrasinda-ilk-supheli-o-orgut-40095672"
        posts.append(post1)
        posts.append(post2)
        */
        
        let filePath = NSBundle.mainBundle().pathForResource("news",ofType:"json")
        if let data = NSData(contentsOfFile: filePath!){
            //let stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
            do{
              
                let json = try NSJSONSerialization.JSONObjectWithData(data, options:[]) as! NSDictionary//try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let psts = json["posts"] as? [[String: AnyObject]] {
                    for pst in psts {
                        if let title = pst["title"] as? String {
                            let post1 = Post()
                            post1.title = title
                            post1.sourceName = pst["sourceName"] as? String
                            post1.link = pst["link"] as? String
                            post1.cntHapy = pst["hapy_count"] as? Int
                            post1.cntNrm = pst["nrm_count"] as? Int
                            post1.cntUnHapy = pst["unhapy_count"] as? Int
                            for cmt in (pst["comments"] as? [[String:AnyObject]])!{
                            
                                let comment1 = Comment()
                                comment1.cmTitle = cmt["userComment"] as? String
                                comment1.userName = cmt["userName"] as? String
                                post1.comments.append(comment1)
                            }
                            posts.append(post1)
                        }
                    }
                }
                
              
 
                
            }catch let err{
              print(err)
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let fc = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        fc.post = posts[indexPath.row]
        return fc
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*
        if let statusText = posts[indexPath.row].statusText
        {
            let rect = NSString(string: statusText).boundingRectWithSize(CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.UsesFontLeading.union(NSStringDrawingOptions.UsesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14)], context: nil)
            let knownHeiht:CGFloat = 8 + 44 + 4+4+200+8+24+8+44
            return CGSizeMake(view.frame.width, rect.height + knownHeiht + 16)
        }
*/
       /*
        title:UIFont.boldSystemFontOfSize(14)
        
        newName:UIFont.systemFontOfSize(12)
        link:UIFont.boldSystemFontOfSize(13)
        */
        var height:CGFloat = 300
        let kh:CGFloat = 10 + 40 + 6 + 8 + 32 + 10
        if let title = posts[indexPath.row].title {
            height = 0
            height = height + title.calculateHeight(UIFont.boldSystemFontOfSize(14)) + (posts[indexPath.row].sourceName?.calculateHeight(UIFont.systemFontOfSize(12)))!               + (posts[indexPath.row].link?.calculateHeight(UIFont.boldSystemFontOfSize(13)))!
            for cm1 in posts[indexPath.row].comments {
            
                height = height  + 5 + (cm1.cmTitle?.calculateHeight(UIFont.systemFontOfSize(13)))! + (cm1.userName?.calculateHeight(UIFont.systemFontOfSize(12)))!
                
            }
        }
        
        return CGSizeMake(view.frame.width,320)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        for cell in collectionView!.visibleCells() {
            
            if let fc = cell as? FeedCell {
                fc.appsCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerCell, forIndexPath: indexPath) as? HeaderCell
        header?.viewController = self
        return header!
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.width, 40)
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cv = DetailViewController()
        cv.post = posts[indexPath.row]
        navigationController?.pushViewController(cv, animated: true)
    }
    
    func changeCategory(categoryName:String){
        print(categoryName)
        posts.removeAll()
        collectionView?.reloadData()
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .Gray
        indicator.drawRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        indicator.startAnimating()
        
        let alert = UIAlertController(title: "", message: "Loading Please Wait", preferredStyle: UIAlertControllerStyle.Alert)
        //indicator.center = alert.view.center
        alert.view.addSubview(indicator)
        presentViewController(alert, animated: true, completion: nil)
        let seconds = 4.0

        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
           
            self.initPost()
            self.collectionView?.reloadData()
            // here code perfomed with delay
            self.dismissViewControllerAnimated(false, completion: nil)
            
        })
        
    }

}
class HeaderCell : UICollectionViewCell {
    var viewController: FeedController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("ddd")
    }
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Gündem", "Popüler", "Spor"])
        sc.tintColor = UIColor(red: 28/255, green: 164/255, blue: 179/255, alpha: 1)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    func setupViews(){
    
        addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: Selector("indexChanged:"), forControlEvents: .ValueChanged)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: segmentedControl)
        addConstraintsWithFormat("V:|-8-[v0]-8-|", views: segmentedControl)
    }
    func indexChanged(sender: UISegmentedControl){
    
        viewController?.changeCategory( segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)!)
    }
}
class FeedCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{

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
        label.font = UIFont.boldSystemFontOfSize(13)
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
        label.font = UIFont.boldSystemFontOfSize(13)
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
        tf.layer.cornerRadius = 16.0
        tf.layer.masksToBounds = true
        tf.textAlignment = .Justified
        return tf
    }()
    let btnSend : UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.textAlignment = .Right
        btn.backgroundColor = UIColor(red: 7/255, green: 117/255, blue: 160/255, alpha: 1)
        //btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.layer.cornerRadius = 16
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
        if let cmt = txtComment.text
        {
            let comment = Comment()
            comment.cmTitle = cmt
            comment.userName = "Fatih"
            post?.comments.insert(comment, atIndex: 0)
            appsCollectionView.reloadData()
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            appsCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)
            //let newIndexPath = NSIndexPath(forRow: post!.comments.count, inSection: 0)
            //appsCollectionView.insertItemsAtIndexPaths([newIndexPath]
            //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,UIScreen.mainScreen().bounds.width, 340)
            //mainColectionView!.frame = CGRectMake(mainColectionView!.frame.origin.x, mainColectionView!.frame.origin.y,UIScreen.mainScreen().bounds.width, 350)
    
        }
        else
        {
        
            print("mesaj gelecek ")
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
        
        btnHapy.addTarget(self, action: Selector("btnTouchHapy:"), forControlEvents: .TouchDown)
        btnSend.addTarget(self, action: Selector("btnSendCommentTouch:"), forControlEvents: .TouchDown)
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
        
        addConstraintsWithFormat("V:|-1-[v0][v1]", views: labelTitle,labelSourceName)
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
        print("number item")
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
class CommentCell: UICollectionViewCell {
    var comment : Comment? {
        didSet{
        
            if let t = comment?.cmTitle, let n = comment?.userName {
            
                byLabel.text = n
                labelComment.text = t
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("ddd")
    }
    var byLabel : UILabel = {
    
        let lb = UILabel()
        lb.textColor = UIColor(red: 155/255, green: 161/255, blue: 172/255, alpha: 1)
        lb.font = UIFont.systemFontOfSize(12)
        lb.text = "Cüneyt"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    var labelComment :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(83, green: 84, blue: 84)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()
    func setupViews(){
        addSubview(labelComment)
        addSubview(byLabel)
        
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: labelComment)
        addConstraintsWithFormat("H:|-5-[v0]", views: byLabel)
        addConstraintsWithFormat("V:|[v0(>=20,<=40)]-5-[v1]", views: labelComment,byLabel)
    }
}
