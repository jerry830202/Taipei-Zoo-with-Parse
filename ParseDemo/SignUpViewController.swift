//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordfeild: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpAction(sender: AnyObject) {
        
        
        let username = usernamefield.text
        let password = passwordfeild.text
        let email = emailField.text
        
        if let username = username where username.characters.count < 5
        {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else if let password = password where password.characters.count < 8
        {
            let alert = UIAlertView(title: "Invalid", message: "Passsword must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else if let email = email where email.characters.count < 8
        {
            let alert = UIAlertView(title: "Invalid", message: "email must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }else
        {
            let spinner : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            newUser.signUpInBackgroundWithBlock({ (succeed, error) ->Void in
                spinner.stopAnimating()
                if((error) != nil)
                {
                    let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }else
                {
                    let gamepoint = PFObject(className: "userpoint")
                  // print(gamepoint.description)
                    
                    gamepoint["userpointname"]=username
                    gamepoint["point"]=0
                    gamepoint.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
                        if(success){
                            print("Success")
                            print(gamepoint.objectId)
                        }
                        else{
                            print("Fail")
                        }}

                    let alert = UIAlertView(title: "Success", message: "Sign Up", delegate: self, cancelButtonTitle: "ok")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let Viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                        self.presentViewController(Viewcontroller, animated: true, completion: nil)
                    })
                }
                
            })
        }
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
