//
//  ViewController.swift
//  finalProject
//
//  Created by saberoxas on 2016/1/3.
//  Copyright © 2016年 Chang yp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate{
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonRestart: UIButton!
    
    
    var dataArray = [AnyObject]() //儲存動物資料
    var dataArraySize:Int = 0
    var answerNumber:Int = 0
    var answerPicture:Int = 0
    let countGame:Int = 10
    var count:Int = 1
    var grade:Int = 0
    var checkPicture = Array(count: 10, repeatedValue: -1)

    override func viewDidLoad() {
        activity.startAnimating()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //台北市立動物園公開資料網址
        let url=NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
        
        //建立一般session設定
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //設定委任對象為自己
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        //設定下載網址
        let dataTask = session.downloadTaskWithURL(url!)
        
        //啟動或重新
        dataTask.resume()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do {
            //JSON資料處理
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:[String:AnyObject]]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            dataArraySize = dataArray.count
            print(dataArraySize)
            
            activity.stopAnimating()
            myButton.alpha = 1
            
        } catch {
            print("Error!")
        }
        
        guard let imageData = NSData(contentsOfURL: location) else{
            return
        }
        print(imageData.length)
        if imageData.length > 1500 {
            myImageView.image = UIImage(data : imageData)
        }else {
            myImageView.image = UIImage(named: "picture1.jpg")
        }
        
    }
    
    func loadPicture(){
        //取得圖片網址
        let url = dataArray[answerPicture]["A_Pic01_URL"]
        print(url)
        //print(dataArray[answerPicture]["A_Name_Ch"]as! String)
        //print(url!!.description as String)
        if let Url = url //如果有圖片網址，向伺服器請求圖片資料
        {
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let copyUrl:String = Url as! String
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
            myImageView.image = UIImage(named: "picture1.jpg")
        }

    }
    
    @IBAction func startClick(sender: AnyObject) {
        count = 0
        grade = 0
        myLabel.alpha = 0
        myButton.alpha=0
        buttonRestart.alpha=0
        myImageView.alpha=1
        segControl.alpha=1
        
        var randomNumber = [-1,-1,-1]
        var checkChoose = Array(count: dataArraySize, repeatedValue: -1)
        checkPicture = Array(count: dataArraySize, repeatedValue: -1)
        
        print(dataArraySize)
        answerPicture = Int(arc4random() % UInt32(dataArraySize))
        print(answerPicture)
        answerNumber = Int(arc4random()%3)
        
        loadPicture()
        
        checkPicture[answerPicture] = 0
        randomNumber[answerNumber]=answerPicture
        checkChoose[answerPicture] = 0
        
        for(var i=0;i<3;i++)
        {
            if(i != answerNumber)
            {
                randomNumber[i] = Int(arc4random() % UInt32(dataArraySize))
                checkChoose[randomNumber[i]]=0
                for (var j=0;j<3;j++)
                {
                    if (j != i)
                    {
                        repeat{
                            randomNumber[i] = Int(arc4random() % UInt32(dataArraySize))
                        }while(checkChoose[randomNumber[i]]==0)
                        checkChoose[randomNumber[i]]=0
                    }
                }
            }
        }
        
        segControl.setTitle(dataArray[randomNumber[0]]["A_Name_Ch"] as? String, forSegmentAtIndex: 0)
        segControl.setTitle(dataArray[randomNumber[1]]["A_Name_Ch"] as? String, forSegmentAtIndex: 1)
        segControl.setTitle(dataArray[randomNumber[2]]["A_Name_Ch"] as? String, forSegmentAtIndex: 2)
        segControl.selectedSegmentIndex = -1
    }

    @IBAction func chooseClick(sender: UISegmentedControl) {
        print(count)
        if(count == countGame){
            if(segControl.selectedSegmentIndex==answerNumber)
            {
                grade+=10
            }
            
            segControl.alpha=0
            myImageView.alpha=0
            buttonRestart.alpha=1
            myLabel.alpha=1
            myLabel.text = "你的分數為\(grade)!"
            if(grade >= 80 )
            {
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
                                print(object["point"])
                                var temppoint = object["point"] as! Int
                                temppoint++
                                object["point"]=temppoint
                                object.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                                    if(success)
                                    {
                                        print("success")
                                    }else{
                                        print("Fail")
                                    }
                                }
                            }
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            }
        }else{
            if(segControl.selectedSegmentIndex==answerNumber)
            {
                grade+=10
            }
            count++
            var randomNumber = [-1,-1,-1]
            var checkChoose = Array(count: dataArraySize, repeatedValue: -1)
            
            repeat{
                answerPicture = Int(arc4random() % UInt32(dataArraySize))
            }while(checkPicture[answerPicture] == 0)
            answerNumber = Int(arc4random()%3)
            
            loadPicture()
            
            checkPicture[answerPicture] = 0
            randomNumber[answerNumber]=answerPicture
            checkChoose[answerPicture] = 0
            
            for(var i=0;i<3;i++)
            {
                if(i != answerNumber)
                {
                    randomNumber[i] = Int(arc4random() % UInt32(dataArraySize))
                    checkChoose[randomNumber[i]]=0
                    for (var j=0;j<3;j++)
                    {
                        if (j != i)
                        {
                            repeat{
                                randomNumber[i] = Int(arc4random() % UInt32(dataArraySize))
                            }while(checkChoose[randomNumber[i]]==0)
                            checkChoose[randomNumber[i]]=0
                        }
                    }
                }
            }
            
            print(answerPicture)
            
            segControl.setTitle(dataArray[randomNumber[0]]["A_Name_Ch"] as? String, forSegmentAtIndex: 0)
            segControl.setTitle(dataArray[randomNumber[1]]["A_Name_Ch"] as? String, forSegmentAtIndex: 1)
            segControl.setTitle(dataArray[randomNumber[2]]["A_Name_Ch"] as? String, forSegmentAtIndex: 2)
            segControl.selectedSegmentIndex = -1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}

