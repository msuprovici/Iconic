//
//  SettingsTableViewCell.swift
//  Iconic
//
//  Created by Mike Suprovici on 8/11/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var settingsText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
