//
//  LoginViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func Loginaction(sender: AnyObject) {
        let username = Username.text
        let password = Password.text
        
        if let username = username where username.characters.count < 5
        {
            let alert = UIAlertView(title: "Invalid", message:"Username must be greater than 5 characters" , delegate: self, cancelButtonTitle: "ok")
            alert.show()
        }else if let password = password where password.characters.count < 8
        {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else
        {
            let spin: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150))as UIActivityIndicatorView
            spin.startAnimating()
            PFUser.logInWithUsernameInBackground(username!, password:password!, block: {(user,error) -> Void in
                spin.stopAnimating()
                
                if((user) != nil)
                {
                    let alert=UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "ok")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
                    let viewController=UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(viewController, animated: true, completion:nil)
                        })
                
                }else
                {
                    let alert = UIAlertView(title: "Error", message: "Login False", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                }
                
            })
        }
        
    }

    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
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
