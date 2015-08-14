//
//  LogOutSegue.swift
//  Iconic
//
//  Created by Mike Suprovici on 8/13/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

import UIKit

class LogOutSegue: UIStoryboardSegue {
    
    //replaces current view controller
    override func perform() {
        
        var sourceViewController: UIViewController = self.sourceViewController as! UIViewController
        var destinationViewController: UIViewController = self.destinationViewController as! UIViewController
        
        sourceViewController.view.addSubview(destinationViewController.view)
        
        destinationViewController.view.removeFromSuperview()
        sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
        

    }

   
}
