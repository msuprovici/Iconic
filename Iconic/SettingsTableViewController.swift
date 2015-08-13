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
   
    var headerText: [String] = ["Personal Notfications", "Team Notifications", ""]
   
    var settingsListItemObjects = [SettingsListItem]()
    
    var teamSettingsListItemObjects = [TeamSettingsListItem]()

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        loadSettingsListItemObjects()
        
        // Load any saved settings, otherwise load default data.
        if let savedSettigns = loadSettingsListItems() {
            settingsListItemObjects += savedSettigns
        }
        else {
            loadSettingsListItemObjects()
        }
        
        
        
        if let savedTeamSettings = loadTeamSettingsListItems(){
            teamSettingsListItemObjects += savedTeamSettings
        }
        else
        {
            loadTeamSettingsListItemObjects()
        }
        
        
        
    }
    
    
    func loadSettingsListItemObjects(){
        
        let setting1 = SettingsListItem(itemName: "Record Daily Steps", selected: false, parseKey: "highDailyStepsPermission")
        let setting2 = SettingsListItem(itemName: "Low Steps", selected: false, parseKey: "lowStepsPermission")
        let setting3 = SettingsListItem(itemName: "Streaks", selected: false, parseKey: "streakPermission")
        let setting4 = SettingsListItem(itemName: "5k Steps", selected: false, parseKey: "steps5kPermission")
        let setting5 = SettingsListItem(itemName: "10k Steps", selected: false, parseKey: "steps10kPermission")
        let setting6 = SettingsListItem(itemName: "15k Steps", selected: false, parseKey: "steps15kPermission")
        let setting7 = SettingsListItem(itemName: "20k Steps", selected: false, parseKey: "steps20kPermission")
        
        
        settingsListItemObjects += [setting1, setting2, setting3, setting4, setting5, setting6, setting7]
        
    }
    
    func loadTeamSettingsListItemObjects(){
        
        let teamSetting1 = TeamSettingsListItem(itemName: "Team updates", selected: false)
        let teamSetting2 = TeamSettingsListItem(itemName: "Final Scores", selected: false)
        
        teamSettingsListItemObjects += [teamSetting1, teamSetting2]
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if(section == 0)
        {
            return settingsListItemObjects.count
        }
        else if(section == 1)
        {
            return teamSettingsListItemObjects.count
            
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
//                else
//                {
//                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//                }
            
        }
            
        else if(indexPath.section == 1)
        {
            
            let teamSettingListObject = teamSettingsListItemObjects[indexPath.row]
            
            
            cell.settingsText.text = teamSettingListObject.itemName
            
            if(teamSettingListObject.selected == true)
            {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else if (teamSettingListObject.selected == false)
            {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        }
        else
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
//        selectedCell?.accessoryType = .None
        
        let settingListObject = settingsListItemObjects[indexPath.row]
        
            
        // save object if item is slelected
          
            if (settingListObject.selected == true)
            {
                
                selectedCell?.accessoryType = .Checkmark
                
//                print("    select row: not selected")
                
                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: false, parseKey: settingListObject.parseKey)

                saveSettingsListItem()
                
                
                user?.setObject(false, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
//                         print("  User saved in select")
                    } else {
                        // There was a problem, check error.description
                         print("  User failed to saved")
                    }
                }
            
            }
            else
            {
                selectedCell?.accessoryType = .None
                
//                print("    select row: selected")
                
                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: true, parseKey: settingListObject.parseKey)
                
                saveSettingsListItem()
                
                
                user?.setObject(false, forKey: settingListObject.parseKey)
                
                user?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
//                        print("  User saved in select")
                    } else {
                        // There was a problem, check error.description
                        print("  User failed to saved")
                    }
                }

            }
            
        }
        else if (indexPath.section == 1)
        {
            let selectedTeamSettingsCell = tableView.cellForRowAtIndexPath(indexPath)
            //        selectedCell?.accessoryType = .None
            
            let teamSettingListObject = teamSettingsListItemObjects[indexPath.row]
            
            
            // save object if item is slelected
            
            if (teamSettingListObject.selected == true)
            {
                
                selectedTeamSettingsCell?.accessoryType = .Checkmark
                
                //                print("    select row: not selected")
                
                teamSettingsListItemObjects[indexPath.row] = TeamSettingsListItem(itemName: teamSettingListObject.itemName, selected: false)
                
                saveTeamSettingsListItem()
                
                
                
            }
            else
            {
                selectedTeamSettingsCell?.accessoryType = .None
                
                //                print("    select row: selected")
                
                teamSettingsListItemObjects[indexPath.row] = TeamSettingsListItem(itemName: teamSettingListObject.itemName, selected: true)
                
                saveTeamSettingsListItem()
                
                
                
            }
        }
        
    }
    
//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if(indexPath.section == 0){
//        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        selectedCell?.accessoryType = .Checkmark
//            
//            let settingListObject = settingsListItemObjects[indexPath.row]
//            
//
//                print("    de-select row: not selected")
//                
//                settingsListItemObjects[indexPath.row] = SettingsListItem(itemName: settingListObject.itemName, selected: true, parseKey: settingListObject.parseKey)
//
//                saveSettingsListItem()
//                
//                user?.setObject(true, forKey: settingListObject.parseKey)
//                
//                user?.saveInBackgroundWithBlock {
//                    (success: Bool, error: NSError?) -> Void in
//                    if (success) {
//                        // The object has been saved.
//                        print("  User saved in de-select")
//                    } else {
//                        // There was a problem, check error.description
//                    }
////                }
//
//            }
//            
//
//        }
//        
//    }
    
    
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
//           print("    saveSettingsListItem Save succesful...")
            
        }
        
    }
    
    func loadSettingsListItems() -> [SettingsListItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(SettingsListItem.ArchiveURL.path!) as? [SettingsListItem]
    }
    
    
    
    func saveTeamSettingsListItem() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(teamSettingsListItemObjects, toFile: TeamSettingsListItem.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save setting...")
            
            
        }
        else
        {
//            print("    saveTeamSettingsListItem Save succesful...")
            
        }
        
    }
    
    func loadTeamSettingsListItems() -> [TeamSettingsListItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TeamSettingsListItem.ArchiveURL.path!) as? [TeamSettingsListItem]
    }



}
