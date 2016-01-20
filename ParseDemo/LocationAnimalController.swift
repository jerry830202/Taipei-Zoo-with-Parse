//
//  LocationAnimal.swift
//  finalproject
//
//  Created by HuYu lun on 2016/1/2.
//  Copyright © 2016年 HuYu lun. All rights reserved.
//

import UIKit
class LocationAnimalController:UITableViewController,NSURLSessionDelegate,NSURLSessionDownloadDelegate{

   // var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var dataArray = [AnyObject]()
    var animaldata = [String]() //儲存動物資料
    var locationinformation:String?
    var animalcount=0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=locationinformation
        //取得圖片網址
        //台北市立動物園公開資料網址
        let url = NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613")
        print(locationinformation)
        //建立一般的session設定
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //設定委任對象為自己
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        //設定下載網址
        let dataTask = session.downloadTaskWithURL(url!)
        
        //啟動或重新啟動下載動作
        dataTask.resume()
       
        
    }
    
    @IBAction func backLocationAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
               
                //取得被選取到的這一隻動物的資料
                for(var i=0;i<dataArray.count;i++)
                {
                    
                    if((dataArray as NSArray)[i]["A_Name_Ch"]as? String == animaldata[indexPath.row])
                    {
                        let animobject = dataArray[i]
                       
                        //設定在第二個畫面控制器中的資料為這一隻動物的資料
                        let controller = segue.destinationViewController as! AnimalInformationController
                        controller.thisAnimalDic = animobject
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //依據動物數量呈現
        return animalcount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AnimationCell", forIndexPath: indexPath)
        
        //顯示動物的中文名稱於Table View中
                    cell.textLabel?.text = animaldata[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        do {
            
            //JSON資料處理
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:[String:AnyObject]]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            for(var i=0; i < dataArray.count;i++)
            {
                var newlocation=true
                
                //let locationtemp=(dataArray as NSArray)[i]["A_Location"]as?String
                //locationinformation.append()
                //locationinformation[i]=locationtemp
                if((dataArray as NSArray)[i]["A_Location"]as? String==locationinformation)
                {
                    for(var j=0 ; j<animalcount;j++)
                    {
                        
                        print((dataArray as NSArray)[i]["A_Name_Ch"]as! String)
                        print((dataArray as NSArray)[j]["A_Name_Ch"]as! String)
                        if((dataArray as NSArray)[i]["A_Name_Ch"]as! String==animaldata[j])
                        {
                            print("get same")
                            newlocation=false
                        }
                    }
                    if(newlocation)
                    {
                        animalcount++
                        let animaltemp=(dataArray as NSArray)[i]["A_Name_Ch"]as?String
                        animaldata.append(animaltemp!)
                        print(animaldata[animalcount-1])
                    }
                }
            }
            

            
            //重新整理Table View
            self.tableView.reloadData()
            
        } catch {
            print("Error!")
        }
        
    }

    
}