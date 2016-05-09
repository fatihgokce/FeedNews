//
//  ViewController.swift
//  FeedNews
//
//  Created by fatih on 27/04/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import UIKit
import Social

let cellId="cellId"
let commentCellId="CommentcellId"
let MAX_COMMENTS_HEIGT :Int = 200

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout ,FeedCellDelegate{
    var posts = [Post]()
    let headerCell = "headerCellid"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil) 
        // Do any additional setup after loading the view, typically from a nib.
        if let ly = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout!
        {
            //ly.scrollDirection = .Vertical
        }
        //collectionView?.collectionViewLayout = layout
        initPost("gundem")
       
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
        User.isLogin()

        collectionView?.backgroundColor = UIColor.rgb(242, green: 242, blue: 242)
        navigationItem.title = "New Feed"
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.registerClass(HeaderCell.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCell)
        loadingView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.view.addSubview(loadingView)
        loadingView.addSubview(indicator)
        self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
           
    }
    let indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.activityIndicatorViewStyle = .Gray
        indicator.color = UIColor(red: 28/255, green: 164/255, blue: 179/255, alpha: 1)
        indicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        return indicator
    }()
    let loadingView:UIView = {
        let v1:UIView = UIView()
        
        
        v1.backgroundColor = UIColor.whiteColor()
        
        return v1;
    }()
    func isLogin(text :String,linkId:Int,succeedHandler:()->()){
        if(User.email == nil && !User.isLogin())
        {
            let logiC = LoginViewController()
            
            navigationController?.pushViewController(logiC, animated: true)
           
        }
        else{
            //loadingView.hidden = false
            //indicator.startAnimating()
            let linkS:String! = "http://198.38.92.235:8081/setComment?comment=\(text)&email=\(User.email!)&link_id=\(linkId)&name=\(User.name!)"
            
            print(linkS)
            //let url = NSURL(string: linkS)
            let url = NSURL(string: linkS.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
            let task = NSURLSession.sharedSession().dataTaskWithURL(url)
            {
                (data, response, error) in
                if(error != nil){
                    
                    print("lost connection")
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.indicator.stopAnimating()
                        self.loadingView.hidden = true
                        if(!Reachability.isConnectedToNetwork()){
                            let alert = UIAlertController(title: "", message: "internet bağlantısı yok", preferredStyle: UIAlertControllerStyle.Alert)
                            //indicator.center = alert.view.center
                            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                    return
                }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData( data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    //NSJSONSerialization.JSONObjectWithData(jdata!, options: .AllowFragments)
                    
                    
                    if let b = json["s"] as? Bool {
                     
                        if b == true {
                            dispatch_async(dispatch_get_main_queue(), {
                            
                                succeedHandler()

                            })
                            
                        }
                        else
                        {
                        // TODO: 
                            print("hata uyari")
                        }
                        
                        
                    }
                } catch
                {
                    print("error serializing JSON: \(error)")
                    //self.spc.stopAnimating()
                    
                    
                }
            }
            task.resume()
        }
    }
    func shareTwitter(text : String){
    
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Twitter'da paylaş")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ayarlar", message: "Paylaşmak için bir Twitter hesabına giriş yapınız..", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func shareFacebook(text : String){
        
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Facebook'ta Paylaş")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ayarlar", message: "Paylaşmak için bir Facebook hesabına giriş yapınız.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    func initPost(category: String){
        loadingView.hidden = false
        indicator.startAnimating()
        let url = NSURL(string: "http://198.38.92.235:8081/getByCategory?ct=" + category)
        //let url = "http://198.38.92.235:8081/getData?url=http://www.hurriyet.com.tr/real-betis-0-2-barcelona-40097396"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)
        {
            (data, response, error) in
            if(error != nil){
                
                print("lost connection")
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.indicator.stopAnimating()
                    self.loadingView.hidden = true
                    if(!Reachability.isConnectedToNetwork()){
                        let alert = UIAlertController(title: "", message: "internet bağlantısı yok", preferredStyle: UIAlertControllerStyle.Alert)
                        //indicator.center = alert.view.center
                        alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                return
            }
            do {
             
                
                let  sjson = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                //sjson.removeAtIndex(sjson.startIndex.predecessor())
                //sjson.removeAtIndex(sjson.endIndex.predecessor())
                let jdata = sjson.dataUsingEncoding(NSUTF8StringEncoding)
                
                
                let json = try NSJSONSerialization.JSONObjectWithData( jdata!, options: NSJSONReadingOptions.MutableContainers)
                //NSJSONSerialization.JSONObjectWithData(jdata!, options: .AllowFragments)
                

                 if let psts = json as? [[String: AnyObject]] {
                    for pst in psts {
                        let post1=Post()
                        post1.title=pst["title"] as? String
                        post1.link = pst["link"] as? String
                        post1.sourceName = post1.link?.componentsSeparatedByString(".")[1]
                        post1.linkId = pst["link_id"] as? Int
                        self.posts.append(post1)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        self.indicator.stopAnimating()
                        self.collectionView?.reloadData()
                        self.loadingView.hidden = true
                        
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
         fc.delegate = self
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
        /*
        var height:CGFloat = 300
        let kh:CGFloat = 10 + 40 + 6 + 8 + 32 + 10
        if let title = posts[indexPath.row].title {
            height = 0
            height = height + title.calculateHeight(UIFont.boldSystemFontOfSize(14)) + (posts[indexPath.row].sourceName?.calculateHeight(UIFont.systemFontOfSize(12)))!               + (posts[indexPath.row].link?.calculateHeight(UIFont.boldSystemFontOfSize(13)))!
            for cm1 in posts[indexPath.row].comments {
            
                height = height  + 5 + (cm1.cmTitle?.calculateHeight(UIFont.systemFontOfSize(13)))! + (cm1.userName?.calculateHeight(UIFont.systemFontOfSize(12)))!
                
            }
        }
        */
        return CGSizeMake(view.frame.width-15,320)
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

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        return sectionInsets //UIEdgeInsetsMake(5, 5, 5, 5)
    }
 
    func changeCategory(categoryName:String){
    
        posts = [Post]()
        collectionView?.reloadData()
        self.initPost(categoryName.replace("ö", withString: "o").replace("ü", withString: "u").lowercaseString)

        /*
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
        
        let seconds = 3.0
        
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.initPost(categoryName.replace("ö", withString: "o").replace("ü", withString: "u").lowercaseString)
            self.collectionView?.reloadData()
            // here code perfomed with delay
            self.dismissViewControllerAnimated(false, completion: nil)
            
        })
        */
    }

}
class HeaderCell : UICollectionViewCell {
    var viewController: FeedController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
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
        segmentedControl.addTarget(self, action: #selector(HeaderCell.indexChanged(_:)), forControlEvents: .ValueChanged)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: segmentedControl)
        addConstraintsWithFormat("V:|-8-[v0]-8-|", views: segmentedControl)
    }
    func indexChanged(sender: UISegmentedControl){
    
        viewController?.changeCategory( segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex)!)
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
        
        addConstraintsWithFormat("H:|-8-[v0]-0-|", views: labelComment)
        addConstraintsWithFormat("H:|-8-[v0]", views: byLabel)
        addConstraintsWithFormat("V:|[v0]-1-[v1]", views: labelComment,byLabel)
    }
}
