//
//  TeamatesCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/10/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamatesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamateName;

@property (weak, nonatomic) IBOutlet UIImageView *teamtePicture;

@property (weak, nonatomic) IBOutlet UILabel *teamtePoints;

@property (weak, nonatomic) IBOutlet UILabel *teamteXP;


@end
