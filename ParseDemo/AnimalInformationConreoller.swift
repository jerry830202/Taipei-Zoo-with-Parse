//
//  AnimalInformationConreoller.swift
//  finalproject
//
//  Created by HuYu lun on 2016/1/7.
//  Copyright © 2016年 HuYu lun. All rights reserved.
//

import UIKit

class AnimalInformationController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    

    @IBAction func returnbutton(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    var thisAnimalDic:AnyObject?
    
    /*var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }*/
    
    /*func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }*/
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var narbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得圖片網址
        
        
                let url = (thisAnimalDic as! [String:AnyObject])["A_Pic01_URL"]
  
        
        
        if let url = url //如果有圖片網址，向伺服器請求圖片資料
        {
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            let copyUrl:String = url as! String
            var correctUrl:String = ""
            for var i = 0 ; i < copyUrl.characters.count ; i++ {
                let index = copyUrl.startIndex.advancedBy(i)
                if (copyUrl[index] != " ") {
                    correctUrl = correctUrl+String(copyUrl[index])
                }
            }
            print(correctUrl)
            
            let dataTask = session.downloadTaskWithURL(NSURL(string: correctUrl)!)
            
            dataTask.resume()
        }
        narbar.title=(thisAnimalDic as! [String:String])["A_Name_Ch"]
        detailDescriptionLabel.text=(thisAnimalDic as! [String:String])["A_Interpretation"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func voteAction(sender: AnyObject) {
        let currentuser = PFUser.currentUser()
        let query = PFQuery(className:"userpoint")
        query.whereKey("userpointname", equalTo:(currentuser?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                if let objects = objects {
                    for object in objects {
                        var temppoint = object["point"] as! Int
                
                        if(temppoint>0)
                        {
                            let alert=UIAlertController(title: "確定投票", message: "您現在擁有的投票卷有 \(temppoint) 您確定要投給 \((self.thisAnimalDic as![String:String])["A_Name_Ch"]!)", preferredStyle: UIAlertControllerStyle.Alert)
                            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                            let checkAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction)-> Void in
                                    let supquery = PFQuery(className: "Animal")
                                supquery.whereKey("Id", equalTo: (self.thisAnimalDic as! [String:String])["_id"]!)
                                supquery.findObjectsInBackgroundWithBlock{
                                    (supobjects: [PFObject]?, superror: NSError?) -> Void in
                                    if(superror==nil)
                                    {
                                        for supobject in supobjects!
                                        {
                                            var tempvotevale=supobject["getvote"] as! Int
                                            tempvotevale++
                                            temppoint--
                                            print(temppoint)
                                            print("insub")
                                            supobject["getvote"]=tempvotevale
                                 
                                            supobject.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                                                if(success)
                                                {
                                                    print("success")
                                                    object["point"]=temppoint
                                                    print(object["point"])
                                                    object.saveInBackgroundWithBlock{
                                                        (success: Bool, error: NSError?) -> Void in
                                                        if(success)
                                                        {
                                                            print("success")
                                                        }else{
                                                            print("Fail")
                                                        }
                                                
                                                    }

                                                }else{
                                                    print("Fail")
                                                }
                                            }
                                        }
                                    }else{
                                        print("Error: \(superror!) \(superror!.userInfo)")
                                    }
                            
                                }
                            })
                            alert.addAction(cancelAction)
                            alert.addAction(checkAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }else{
                            let alert=UIAlertController(title: "您尚未持有投票票卷", message: "你目前的投票跳卷共有\(temppoint)張 請到進行動物小遊戲取得票卷", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction=UIAlertAction(title: "確定", style: UIAlertActionStyle.Cancel, handler: nil)
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

      
        
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        guard let imageData = NSData(contentsOfURL: location) else {
            return
        }
        if(imageData.length>1500)
        {
            ImageView.image=UIImage(data: imageData)
        }else
        {
            ImageView.image=UIImage(named: "picture1.jpg")
        }
        //ImageView.image = UIImage(data: imageData)
    }
}

