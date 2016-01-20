//
//  MasterViewController.swift
//  HelloZoo
//
//  Created by Ryan Chung on 14/11/2015.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
class VoteViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate{
    @IBOutlet weak var famousimage: UIImageView!
    
    @IBOutlet weak var voteBar: UINavigationBar!
    @IBOutlet weak var votecount: UINavigationItem!
    
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var famousAnimalName: UILabel!
    @IBOutlet weak var displayButton: UIButton!
    @IBOutlet weak var MyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultButton: UIButton!
   
    var objects = [AnyObject]()
    var dataArray = [AnyObject]() //儲存動物資料
    var maxvote=0
    var famousAnimal:AnyObject?
    var time=0
    var id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyIndicator.startAnimating()
        MyIndicator.alpha=0
        //台北市立動物園公開資料網址
        let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")

        //建立一般的session設定
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //設定委任對象為自己
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        //設定下載網址
        let dataTask = session.downloadTaskWithURL(url!)
        
        //啟動或重新啟動下載動作
        dataTask.resume()
       
    }
    
    @IBAction func reload(sender: AnyObject) {
        self.famousAnimalName.alpha=0
        self.famousimage.alpha=0
        self.first.alpha=0
        self.voteBar.alpha=0
        self.resultButton.alpha=0
        self.displayButton.alpha=1
    }
    @IBAction func DisplayACtioin(sender: AnyObject) {
        displayButton.alpha=0
        MyIndicator.alpha=1
        MyIndicator.startAnimating()
        
        reloadfamousAnimal()
        
        

    }
    func reloadfamousAnimal()
    {
        print (self.dataArray.count)
        for(var i=0; i < self.dataArray.count;i++)
        {
            let animalquery = PFQuery(className: "Animal")
            let currentanimal = String(stringInterpolationSegment: (i+1))
            print(currentanimal)
            animalquery.whereKey("Id", equalTo:currentanimal)
            animalquery.findObjectsInBackgroundWithBlock{
                (objects: [PFObject]?, error: NSError?) -> Void in
                print("get in")
                if error == nil
                {
                    print("Successfully retrieved \(objects!.count) scores.")
                    if let objects = objects {
                        for object in objects
                        {
                            let tempanimalpoint = object["getvote"] as! Int
                            print(tempanimalpoint)
                            print(self.maxvote)
                            if(tempanimalpoint > self.maxvote)
                            {
                                print("get")
                                self.maxvote=tempanimalpoint
                                print(self.maxvote)
                                print(object["Id"])
                                self.id = object["Id"]as? String
                                
                            }
                            
                        }
                       
                    }
                    
                    self.MyIndicator.stopAnimating()
                    self.MyIndicator.alpha=0
                    self.resultButton.alpha=1

                }
                else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
           
        }
        
       
    }
    @IBAction func resultAction(sender: AnyObject) {
        
        self.resultButton.alpha=0
        self.votecount.title = String(stringInterpolationSegment: self.maxvote)
        for(var i = 0; i < self.dataArray.count ;i++)
        {
            if((self.dataArray as NSArray)[i]["_id"]as? String == self.id)
            {
                self.famousAnimalName.text=(self.dataArray as NSArray)[i]["A_Name_Ch"]as? String
                let url = (self.dataArray as NSArray)[i]["A_Pic01_URL"]as? String
                if let Url = url //如果有圖片網址，向伺服器請求圖片資料
                {
                    let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
                    
                    let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
                    
                    let copyUrl:String = Url
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
                } else {
                    self.famousimage.image = UIImage(named: "picture1.jpg")
                }
            }
        }
        
        self.first.alpha=1
        self.famousimage.alpha=1
        self.famousAnimalName.alpha=1
        self.voteBar.alpha=1
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    
    // MARK: - Table View
  
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do {
            //JSON資料處理
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:[String:AnyObject]]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            
            //print(dataArraySize)
            
            MyIndicator.stopAnimating()
            displayButton.alpha = 1
            
        } catch {
            print("Error!")
        }
        
        guard let imageData = NSData(contentsOfURL: location) else{
            return
        }
        print(imageData.length)
        if imageData.length > 1500 {
            famousimage.image = UIImage(data : imageData)
        }else {
            famousimage.image = UIImage(named: "picture1.jpg")
        }
       
    }
    
}