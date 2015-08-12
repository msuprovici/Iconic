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
    var parseKey: String
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("SettingsListItems")
    
    
    // MARK: Types
    
    struct PropertyKey {
        
        static let itemNameKey = "settingName"
        static let settingSelectedKey = "settingSelected"
        static let parseNameKey = "parseSettingName"
        
        
    }
    
    
    //Mark: Initialization
    
    init(itemName: String, selected: Bool, parseKey: String)
    {
        self.itemName = itemName
        self.selected = selected
        self.parseKey = parseKey
        
        super.init()
        
//        // Initialization should fail if there is no name
//        if itemName.isEmpty {
//            return nil
//        }
        
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(itemName, forKey: PropertyKey.itemNameKey)
        aCoder.encodeObject(selected, forKey: PropertyKey.settingSelectedKey)
        aCoder.encodeObject(parseKey, forKey: PropertyKey.parseNameKey)
       
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let itemName = aDecoder.decodeObjectForKey(PropertyKey.itemNameKey) as! String
        
        let parseKey = aDecoder.decodeObjectForKey(PropertyKey.parseNameKey) as! String
        
        let selected = aDecoder.decodeObjectForKey(PropertyKey.settingSelectedKey) as! Bool
        
        
        // Must call designated initilizer.
        
        self.init(itemName: itemName, selected: selected, parseKey: parseKey)
        
    }

   
}
