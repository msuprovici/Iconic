//
//  SettingsTableViewController.swift
//  Iconic
//
//  Created by Mike Suprovici on 8/11/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController {
    
    
    // MARK: Properties
    
    var user = PFUser.currentUser()
   
    var headerText: [String] = ["Notfications", ""]
   
    var settingsListItemObjects = [SettingsListItem]()
    
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Load any saved settings, otherwise load default data.
        if let savedSettigns = loadSettingsListItems() {
            settingsListItemObjects += savedSettigns
        }
        else {
            loadSettingsListItemObjects()
        }
        
    }
    
    
    func loadSettingsListItemObjects(){
        
        let setting1 = SettingsListItem(itemName: "notification1", selected: false, parseKey: "steps5kPermission")
        let setting2 = SettingsListItem(itemName: "notification2", selected: false, parseKey: "")
        let setting3 = SettingsListItem(itemName: "notification3", selected: false, parseKey: "")
        let setting4 = SettingsListItem(itemName: "notification4", selected: false, parseKey: "")
        let setting5 = SettingsListItem(itemName: "notification5", selected: false, parseKey: "")
        let setting6 = SettingsListItem(itemName: "notification6", selected: false, parseKey: "")
        
   
        settingsListItemObjects += [setting1, setting2, setting3, setting4, setting5, setting6]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(section == 0){
        return settingsListItemObjects.count
        }
        else{
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsTableViewCell

        // Configure the cell...
        
        if(indexPath.section == 0)
        {
            
            let settingListObject = settingsListItemObjects[indexPath.row]
                
                
            cell.settingsText.text = settingListObject.itemName
        
                if(settingListObject.selected == true)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                else if (settingListObject.selected == false)
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            
        }
            
        else if(indexPath.section == 1)
        {
            
            cell.settingsText.text = "Log Out"
            cell.settingsText.textAlignment = .Center;
            cell.settingsText.textColor = UIColor.redColor();
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0){
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedCell?.accessoryType = .None
        
        let settingListObject = settingsListItemObjects[indexPath.row]
        
            
        // save object if item is slelected
        if(settingListObject.selected == true)
            {
                
                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: false, parseKey: settingListObject.parseKey)

                saveSettingsListItem()
                
                
                user?.setObject(true, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                         print("User saved")
                    } else {
                        // There was a problem, check error.description
                         print("User failed to saved")
                    }
                }
                
               
            }
            else
            {
                
                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: true, parseKey: settingListObject.parseKey)

                saveSettingsListItem()
                
                user?.setObject(false, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        print("User saved")
                    } else {
                        // There was a problem, check error.description
                        print("User failed to saved")
                    }
                }

            }
            
            
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0){
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedCell?.accessoryType = .Checkmark
            
            let settingListObject = settingsListItemObjects[indexPath.row]
            
            
            // save object if item is de-slelected
            if(settingListObject.selected == true)
            {

                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: false, parseKey: settingListObject.parseKey)
                
                saveSettingsListItem()
                
                user?.setObject(true, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }

            }
            else
            {
                
                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: true, parseKey: settingListObject.parseKey)

                saveSettingsListItem()
                
                user?.setObject(false, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }

            }
            

        }
        
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerText[section]
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true,completion:{})
 
    }
    
    
    
    
    
    // MARK: NSCoding
    
    func saveSettingsListItem() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(settingsListItemObjects, toFile: SettingsListItem.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save setting...")
            
            
        }
        else
        {
//            print("Save succesful...")
        }
        
    }
    
    func loadSettingsListItems() -> [SettingsListItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsListItem.ArchiveURL.path!) as? [SettingsListItem]
    }


}
