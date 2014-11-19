//
//  TeamatesCell.h
//  Iconic
//
//  Created by Mike Suprovici on 12/10/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "PNChart.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>


@interface TeamatesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamateName;

@property (weak, nonatomic) IBOutlet PFImageView *teamtePicture;

@property (weak, nonatomic) IBOutlet UILabel *teamtePoints;

@property (weak, nonatomic) IBOutlet UILabel *teamteXP;


//progress View Controller

@property (strong, nonatomic) DACircularProgressView *progressView;

@property (strong, nonatomic) IBOutlet DACircularProgressView *circleProgressView;

//@property (strong, nonatomic) IBOutlet PNCircleChart *circleProgressView;

@end
