//
//  TeamatesCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/10/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface TeamatesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamateName;

@property (weak, nonatomic) IBOutlet UIImageView *teamtePicture;

@property (weak, nonatomic) IBOutlet UILabel *teamtePoints;

@property (weak, nonatomic) IBOutlet UILabel *teamteXP;


//progress View Controller

@property (strong, nonatomic) DACircularProgressView *progressView;

@property (strong, nonatomic) IBOutlet DACircularProgressView *circleProgressView;

@end
