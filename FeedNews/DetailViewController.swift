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
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        setupViews()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let imageView : UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .ScaleToFill   //ScaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.grayColor().CGColor
        iv.layer.borderWidth = 0.7
        iv.backgroundColor = UIColor.greenColor()
        return iv
    }()
    let textV : UITextView = {
    
        let tv = UITextView()
        tv.font = UIFont(name: "HelveticaNeue", size: 14) //systemFontOfSize(14)
        tv.scrollEnabled = true
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = UIColor.rgb(59, green: 60, blue: 63)
        //tv.textAlignment = .Justified
        return tv
    }()
    let scrolView : UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize.height = 1000
        return sv
    }()
    func setupViews(){
      
        //self.view.addSubview(scrolView)
        self.view.addSubview(imageView)
        self.view.addSubview(textV)
        addConstraint()
        getData()
        var str  = " Cumhurbaşkanı Erdoğan, amfibi hücum gemisi 'Anadolu'nun inşa başlangıç töreninde konuştu. Erdoğan, 5.5 yıl olan teslim süresini 4 yıla çekilmesini istedi."
        str += "\n Cumhurbaşkanı Recep Tayyip Erdoğan, amfibi hücum gemisi 'Anadolu' inşa başlangıç töreninde konuştu. Erdoğan, projenin öneminden bahsederken 5.5 yıl olan teslim süresinin 4 yıla inmesi gerektiğini belirterek, şirket sahibi Nevzat Kalkavan'a, 'Nevzat bey, bu 5.5 yıl olmaz. 4 yıl olsun.\n Bakın Genelkurmay Başkanım 3 diyor, bunu 4'e çektiğimiz zamandan itibaren yeni siparişler geleceği gibi, bizim de yeni siparişlerimiz olacak. 4 bizde çok önemli. Biliyorsunuz?' dedi. Kalkavan, Erdoğan'ın sözleri üzerine  amfibi hücum gemisi 'Anadolu'yu 4 yılda bitirmeyi taahhüt etti."
        //self.textV.text = str
    }
    func addConstraint(){
        //self.view.addConstraintsWithFormat("H:|[v0]|", views: scrolView)
        self.view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: imageView)
        self.view.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: textV)
        //self.view.addConstraintsWithFormat("V:|[v0]|", views: scrolView)

        self.view.addConstraintsWithFormat("V:|-80-[v0(150)][v1(>=500)]", views: imageView,textV)
        //self.view.addConstraintsWithFormat("V:[v0(80)][v1]", views: imageView,textV)
    }
 
    func getData(){
    
        let url = NSURL(string: "http://198.38.92.235:8081/getData?url=" + post!.link!)
        //let url = "http://198.38.92.235:8081/getData?url=http://www.hurriyet.com.tr/real-betis-0-2-barcelona-40097396"
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!)
            {
                (data, response, error) in
                
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
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        
                         
                            let url2 = NSURL(string: img)
                            NSURLSession.sharedSession().dataTaskWithURL(url2!)
                                {
                                    
                                    (data2,response,error2) in
                                    
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
