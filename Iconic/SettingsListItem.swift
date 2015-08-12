//
//  SettingsListItem.swift
//  Iconic
//
//  Created by Mike Suprovici on 8/11/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

import UIKit

class SettingsListItem: NSObject, NSCoding {
    
    // MARK: Properties
    
    var itemName: String
    var selected: Bool
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("SettingsListItems")
    
    
    // MARK: Types
    
    struct PropertyKey {
        
        static let itemNameKey = "settingName"
        static let settingSelectedKey = "settingSelected"
        
    }
    
    
    //Mark: Initialization
    
    init(itemName: String, selected: Bool)
    {
        self.itemName = itemName
        self.selected = selected
        
        super.init()
        
//        // Initialization should fail if there is no name or if the rating is negative.
//        if itemName.isEmpty {
//            return nil
//        }
        
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(itemName, forKey: PropertyKey.itemNameKey)
        aCoder.encodeObject(selected, forKey: PropertyKey.settingSelectedKey)
       
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let itemName = aDecoder.decodeObjectForKey(PropertyKey.itemNameKey) as! String
        
        let selected = aDecoder.decodeObjectForKey(PropertyKey.settingSelectedKey) as! Bool
        
        
        // Must call designated initilizer.
        
          self.init(itemName: itemName, selected: selected)
        
    }

   
}
