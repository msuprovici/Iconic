//
//  CreateUserNameViewController.swift
//  Iconic
//
//  Created by Mike Suprovici on 8/19/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

import UIKit

class CreateUserNameViewController: UIViewController, UITextFieldDelegate {
    
    //Properties
    
    @IBOutlet weak var CreateUserName: UITextField!

    @IBOutlet weak var submitUserName: UIButton!
    
    var user = PFUser.currentUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CreateUserName.delegate = self
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func submitUserNamePressed(sender: UIButton) {
    
        
        CreateUserName.resignFirstResponder();
//        enteredValue.text = CreateUserName.text;
        if(CreateUserName.text?.characters.count > 3)
        {
            var query : PFQuery = PFUser.query()!
            query.whereKey("username", equalTo: CreateUserName.text!)
            query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                
                if(objects!.count >= 1)
                {
                    
                    var alert = UIAlertController(title: "Username taken", message: "Please enter a new username.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                        switch action.style{
                        case .Default:
                            print("allow push")
                            
                            
                        case .Cancel:
                            print("cancel")
                            
                        case .Destructive:
                            print("destructive")
                        }
                    }))
                    
                
                    
                    self.presentViewController(alert, animated: true, completion: nil)

                
                
                
                }
                else
                {

                    
                    self.user?.setValue(self.CreateUserName.text, forKey: "username")
                    self.user?.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                            //                         print("  User saved in select")
                            self.performSegueWithIdentifier("userNameCreated", sender: nil)
                        } else {
                            // There was a problem, check error.description
                            print("  User failed to saved")
                        }
                    }
                }
                
                
                // Do something with the found objects
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        println(object.objectId)
//                    }
//                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
      }
        else
        {
            var alert = UIAlertController(title: "Username should be at least 4 characters", message: "Please enter a new username.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("user name too short")
                    
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            
            
            
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
    }
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        CreateUserName.resignFirstResponder();
        return true;
    }
}
