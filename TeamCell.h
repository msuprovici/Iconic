//
//  TeamCell.h
//  Iconic
//
//  Created by Mike Suprovici on 2/6/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *teamName;
@property (strong, nonatomic) IBOutlet UILabel *teamRecord;
@property (strong, nonatomic) IBOutlet UIImageView *teamLogo;

@end
