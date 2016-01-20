//
//  MasterViewController.swift
//  HelloZoo
//
//  Created by Ryan Chung on 14/11/2015.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
class LocationController: UITableViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    var locationController : LocationAnimalController? = nil
    var objects = [AnyObject]()
    var dataArray = [AnyObject]() //儲存動物資料
    var locationinformation = [String]()
    var locationcount=0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Taipei Zoo"
        self.navigationController?.title="Taipei Zoo"
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
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.locationController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? LocationAnimalController
        }
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
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Showlocation", sender: nil)
    }
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="Showlocation")
        {
            if let indexPath=self.tableView.indexPathForSelectedRow{
                let tempobject=locationinformation[indexPath.row]
                
                let controller=(segue.destinationViewController as! UINavigationController).topViewController as!LocationAnimalController 
                controller.locationinformation=tempobject
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //依據動物數量呈現
        return locationcount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        //顯示動物的中文名稱於Table View中
        let location = locationinformation[indexPath.row]
        cell.textLabel?.text = location
        
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
            //重新整理Table View
            
            for(var i=0; i < dataArray.count;i++)
            {
                var newlocation=true
                
                    //let locationtemp=(dataArray as NSArray)[i]["A_Location"]as?String
                    //locationinformation.append(<#T##newElement: String##String#>)
                    //locationinformation[i]=locationtemp
                for(var j=0 ; j<locationcount;j++)
                {
                    print((dataArray as NSArray)[i]["A_Location"]as! String)
                    print((dataArray as NSArray)[j]["A_Location"]as! String)
                    if((dataArray as NSArray)[i]["A_Location"]as! String==locationinformation[j])
                    {
                        print("get same")
                        newlocation=false
                    }
                }
                if(newlocation)
                {
                    locationcount++
                    let locationtemp=(dataArray as NSArray)[i]["A_Location"]as?String
                    locationinformation.append(locationtemp!)
                    print(locationinformation[locationcount-1])
                }
            }
            
            
            self.tableView.reloadData()
            
        } catch {
            print("Error!")
        }
       /* for(var i=0; i < dataArray.count;i++)
        {
            var newlocation=true
            locationinformation=(dataArray as![String:String])["A_Location"]
            for(var j=0 ; j<locationcount;j++)
            {
                if(locationinformation[locationcount][]as! String==locationinformation[j]["A_Location"]as! String)
                {
                    newlocation=false
                }
            }
            if(newlocation)
            {
                locationcount++
            }
        }*/
    }
    
}