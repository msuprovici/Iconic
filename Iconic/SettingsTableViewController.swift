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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let app = UIApplication.sharedApplication()

    
    
    

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
        
        
        
        
        if(app.isRegisteredForRemoteNotifications())
        {
        
            let setting1 = SettingsListItem(itemName: "Record Daily Steps", selected: false, parseKey: "highDailyStepsPermission")
            let setting2 = SettingsListItem(itemName: "Low Steps", selected: false, parseKey: "lowStepsPermission")
            let setting3 = SettingsListItem(itemName: "Streaks", selected: false, parseKey: "streakPermission")
            let setting4 = SettingsListItem(itemName: "XP Level Up", selected: false, parseKey: "xpPermission")
            let setting5 = SettingsListItem(itemName: "High Five", selected: false, parseKey: "cheerPermission")
            let setting6 = SettingsListItem(itemName: "5k Steps", selected: false, parseKey: "steps5kPermission")
            let setting7 = SettingsListItem(itemName: "10k Steps", selected: false, parseKey: "steps10kPermission")
            let setting8 = SettingsListItem(itemName: "15k Steps", selected: false, parseKey: "steps15kPermission")
            let setting9 = SettingsListItem(itemName: "20k Steps", selected: false, parseKey: "steps20kPermission")
            
            
            
            settingsListItemObjects += [setting1, setting2, setting3, setting4, setting5, setting6, setting7, setting8, setting9]
            
        }
        else
        {
            let setting1 = SettingsListItem(itemName: "Record Daily Steps", selected: true, parseKey: "highDailyStepsPermission")
            let setting2 = SettingsListItem(itemName: "Low Steps", selected: true, parseKey: "lowStepsPermission")
            let setting3 = SettingsListItem(itemName: "Streaks", selected: true, parseKey: "streakPermission")
            let setting4 = SettingsListItem(itemName: "XP Level Up", selected: true, parseKey: "xpPermission")
            let setting5 = SettingsListItem(itemName: "High Five", selected: true, parseKey: "cheerPermission")
            let setting6 = SettingsListItem(itemName: "5k Steps", selected: true, parseKey: "steps5kPermission")
            let setting7 = SettingsListItem(itemName: "10k Steps", selected: true, parseKey: "steps10kPermission")
            let setting8 = SettingsListItem(itemName: "15k Steps", selected: true, parseKey: "steps15kPermission")
            let setting9 = SettingsListItem(itemName: "20k Steps", selected: true, parseKey: "steps20kPermission")
            
            
            
            settingsListItemObjects += [setting1, setting2, setting3, setting4, setting5, setting6, setting7, setting8, setting9]
        }
        
    }
    
    func loadTeamSettingsListItemObjects(){
        
        if(app.isRegisteredForRemoteNotifications())
        {
        
            let teamSetting1 = TeamSettingsListItem(itemName: "Team Updates", selected: false)
            let teamSetting2 = TeamSettingsListItem(itemName: "Final Scores", selected: false)
            
            teamSettingsListItemObjects += [teamSetting1, teamSetting2]
            
        }
        else
        {
            let teamSetting1 = TeamSettingsListItem(itemName: "Team Updates", selected: true)
            let teamSetting2 = TeamSettingsListItem(itemName: "Final Scores", selected: true)
            
            teamSettingsListItemObjects += [teamSetting1, teamSetting2]
        }
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
            cell.settingsText.textAlignment = .Left;
            cell.settingsText.textColor = UIColor(red: 0/255, green: 42/255, blue: 50/255, alpha: 1)
            
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

            
        }
            
        else if(indexPath.section == 1)
        {
            cell.settingsText.textAlignment = .Left;
            cell.settingsText.textColor = UIColor(red: 0/255, green: 42/255, blue: 50/255, alpha: 1)
            
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
        else if(indexPath.section == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.settingsText.text = "Log Out"
            cell.settingsText.textAlignment = .Center;
            cell.settingsText.textColor = UIColor(red: 250/255, green: 0/255, blue: 33/255, alpha: 1);
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0){
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
//        selectedCell?.accessoryType = .None
        
        let settingListObject = settingsListItemObjects[indexPath.row]
        
        if(app.isRegisteredForRemoteNotifications())
        {
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
            else
            {
                var alert = UIAlertController(title: "Allow Push Notifications", message: "You will be prompted to enable push notifications.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
                    switch action.style{
                    case .Default:
                        println("allow push")
                        self.app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil))
                        self.app.registerForRemoteNotifications()
                        
                    case .Cancel:
                        println("cancel")
                        
                    case .Destructive:
                        println("destructive")
                    }
                }))
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        else if (indexPath.section == 1)
        {
            let selectedTeamSettingsCell = tableView.cellForRowAtIndexPath(indexPath)
            //        selectedCell?.accessoryType = .None
            
            let teamSettingListObject = teamSettingsListItemObjects[indexPath.row]
            
            if(app.isRegisteredForRemoteNotifications())
            {
                    // save object if item is slelected
                    
                        if (teamSettingListObject.selected == true)
                        {
                            
                            selectedTeamSettingsCell?.accessoryType = .Checkmark
                            
                            //                print("    select row: not selected")
                            
                            teamSettingsListItemObjects[indexPath.row] = TeamSettingsListItem(itemName: teamSettingListObject.itemName, selected: false)
                            
                            saveTeamSettingsListItem()
                            
                            
                            
                            
                            if(teamSettingListObject.itemName .isEqual("Team Updates"))
                            {
                                
                                
                                
                                var notificationChannels = defaults.arrayForKey("arrayOfMyTeamNames");
                                
                                
                                let installation = PFInstallation.currentInstallation()
                                installation.setObject(notificationChannels!, forKey: "channels")
                                installation.saveInBackgroundWithBlock{
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
            //                                                    print("  Installation channel saved in select")
                                    } else {
                                        // There was a problem, check error.description
                                        print("  Installation chanels failed to save")
                                    }
                                }
                            }
                            
                            if(teamSettingListObject.itemName .isEqual("Final Scores"))
                            {
                                defaults.setBool(true, forKey: "finalScoresNotificaitonPermision")
                                // print("  finalScoresNotificaitonPermision - true")

                            }
                        
                }
                 
                else
                {
                    selectedTeamSettingsCell?.accessoryType = .None
                    
                    //                print("    select row: selected")
                    
                    teamSettingsListItemObjects[indexPath.row] = TeamSettingsListItem(itemName: teamSettingListObject.itemName, selected: true)
                    
                    saveTeamSettingsListItem()
                    
                    
                    if(teamSettingListObject.itemName .isEqual("Team Updates"))
                    {
                    
                        
                        
                        var notificationChannels: [String] = [];
                        
                        let installation = PFInstallation.currentInstallation()
                        installation.setObject(notificationChannels, forKey: "channels")
                        installation.saveInBackgroundWithBlock{
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
    //                            print("  Installation channel saved in select")
                            } else {
                                // There was a problem, check error.description
                                print("  Installation chanels failed to save")
                            }
                        }
                    }
                    
                    if(teamSettingListObject.itemName .isEqual("Final Scores"))
                    {
                        defaults.setBool(false, forKey: "finalScoresNotificaitonPermision")
                        //print("  finalScoresNotificaitonPermision - false")
                        
                    }

                    
                    
                    
                }
            }
            else
            {
                var alert = UIAlertController(title: "Allow Push Notifications", message: "You will be prompted to enable push notifications.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Allow", style: .Default, handler: { action in
                    switch action.style{
                    case .Default:
                        println("allow push")
                        self.app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil))
                        self.app.registerForRemoteNotifications()
                        
                    case .Cancel:
                        println("cancel")
                        
                    case .Destructive:
                        println("destructive")
                    }
                }))
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                    // ...
                }
                alert.addAction(cancelAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
    
        
        }
        else if (indexPath.section == 2)
        {
            var alert = UIAlertController(title: "Log Out", message: "Are you sure that you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Log Out", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    println("log out")
                    
                    
                case .Cancel:
                    println("cancel")
                    
                case .Destructive:
                    println("destructive")
                }
            }))
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // ...
            }
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

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
