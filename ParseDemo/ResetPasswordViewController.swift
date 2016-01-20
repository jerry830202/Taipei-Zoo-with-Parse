//
//  ResetPasswordViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var emailLabel: UITextField!

    @IBAction func CencelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ResetAction(sender: AnyObject) {
        
        let email=emailLabel.text
        let finalemail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(finalemail)
        let alert = UIAlertController(title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalemail + ".", preferredStyle: UIAlertControllerStyle.Alert)
       let cancel = UIAlertAction(title: "ok", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
