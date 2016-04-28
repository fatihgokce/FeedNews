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

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initPost()
        
        
        collectionView?.backgroundColor = UIColor.rgb(242, green: 242, blue: 242)
        navigationItem.title = "New Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }

    func initPost(){
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
        return CGSizeMake(view.frame.width, 370)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        for cell in collectionView!.visibleCells() {
            
            if let fc = cell as? FeedCell {
                //print("hello")
                //fc.appsCollectionView.sizeToFit()
                fc.appsCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
        collectionView?.collectionViewLayout.invalidateLayout()
    }


}
class FeedCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //var comments = [Comment]()
    var post: Post?{
        didSet{
            if let name = post?.title, let newName = post?.newName
            {
                //appsCollectionView.registerClass(CommentCell.self, forCellWithReuseIdentifier: "hhh")

                let att = NSMutableAttributedString(string: name, attributes: [ NSFontAttributeName: UIFont.boldSystemFontOfSize(14)])
                
                att.appendAttributedString(NSAttributedString(string: "\n by \(newName)",
                    attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12),
                        NSForegroundColorAttributeName: UIColor(red: 155/255, green: 161/255, blue: 172/255, alpha: 1)]))
                
                let ps = NSMutableParagraphStyle()
                ps.lineSpacing = 4
                att.addAttribute(NSParagraphStyleAttributeName, value: ps, range: NSMakeRange(0, att.string.characters.count))
                
                let attament = NSTextAttachment()
                attament.image = UIImage(named: "gs")
                attament.bounds = CGRectMake(0,-2,12,12)
                att.appendAttributedString(NSAttributedString(attachment: attament))
                
                
                
                labelTitle.attributedText = att
                let cmt1 = Comment()
                cmt1.cmTitle = " My setup is that I have this collectionview inside a custom tableview cell and I do return the height of my tableview cell programatically (depending on the content). So it could be that my warnings had to do with my collectionview not fitting inside the tableview cell. So setting the initial collectionview to a smaller value fixed it."
                cmt1.userName = "M.y"
                post?.comments.append(cmt1)
                let cmt2 = Comment()
                cmt2.cmTitle = "actually did the trick. it also resolved my issue in swift, where the cells of a horizontal flow layout had a frame top of -32 (???) and did not fit into the collection view properly."
                cmt2.userName = "fatih"
                post?.comments.append(cmt2)
                
                let cmt3 = Comment()
                cmt3.cmTitle = "actually did the trick. it also resolved my issue in swift, where the cells of a horizontal flow layout had a frame top of -32 (???) and did not fit into the collection view properly."
                cmt3.userName = "fatih"
                post?.comments.append(cmt3)
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
        //label.text="Sample name"
        label.numberOfLines = 2
        return label
    }()
    let labelLink :UILabel = {
        
        let label = UILabel()
        label.text="Sample name"
        label.textColor = UIColor.rgb(102, green: 152, blue: 187)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 2
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
        tf.layer.borderColor =  UIColor.rgb(101, green: 99, blue: 99).CGColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 16.0
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
            comment.userName = "Name :\(cmt)"
            post?.comments.insert(comment, atIndex: 0)
            appsCollectionView.reloadData()
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            appsCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)
            //let newIndexPath = NSIndexPath(forRow: post!.comments.count, inSection: 0)

            //meals.append(meal)
            //appsCollectionView.insertItemsAtIndexPaths([newIndexPath]
            
            
            
        }else{
        
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
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: labelLink)
        addConstraintsWithFormat("H:|-8-[v0(v2)][v1(v2)][v2(>=95,<=140)]", views: btnHapy,btnNrm,btnUnHapy)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: appsCollectionView)
        addConstraintsWithFormat("H:|-8-[v0(>=100)]-8-[v1(<=60)]-8-|", views: txtComment,btnSend)
        addConstraintsWithFormat("H:|-8-[v0]-12-[v1]", views: btnTwitter,btnFacebook)
        
        addConstraintsWithFormat("V:|-8-[v0][v1]", views: labelTitle,labelLink)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnHapy)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnNrm)
        addConstraintsWithFormat("V:[v0]-10-[v1]", views: labelLink,btnUnHapy)
        addConstraintsWithFormat("V:[v0]-10-[v1(150)]", views: btnUnHapy,appsCollectionView)
        addConstraintsWithFormat("V:[v0]-6-[v1]", views: appsCollectionView,btnTwitter)
        addConstraintsWithFormat("V:[v0]-6-[v1]", views: appsCollectionView,btnFacebook)
        addConstraintsWithFormat("V:[v0]-8-[v1(32)]", views: btnTwitter,txtComment)
        addConstraintsWithFormat("V:[v0]-8-[v1(32)]", views: btnTwitter,btnSend)


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
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        appsCollectionView.collectionViewLayout.invalidateLayout()
        print("trans")
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("commentid", forIndexPath: indexPath) as! CommentCell
       
        cell.comment = post?.comments[indexPath.row]
        return cell
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
        print("size:\(UIScreen.mainScreen().bounds.width)")
        return CGSizeMake(UIScreen.mainScreen().bounds.width-16, 50)
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
    let byLabel : UILabel = {
    
        let lb = UILabel()
        lb.textColor = UIColor(red: 155/255, green: 161/255, blue: 172/255, alpha: 1)
        lb.font = UIFont.systemFontOfSize(12)
        lb.text = "Cüneyt"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    let labelComment :UILabel = {
        
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
        addConstraintsWithFormat("V:|[v0(40)]-5-[v1]", views: labelComment,byLabel)
    }
}
