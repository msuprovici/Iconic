//
//  MyStatsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import <Parse/Parse.h>
#import "PNChart.h"
@interface MyStatsViewController : UIViewController

{
     NSArray *ProfileInfo;
}
@property (weak, nonatomic) IBOutlet UILabel *xpValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (weak, nonatomic) IBOutlet PFImageView *playerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (nonatomic, strong) IBOutlet UILabel *xpLabel;

@property (nonatomic, strong) IBOutlet UILabel *viewTitle;
@property (nonatomic, strong) IBOutlet UIImageView *statsImage;


//progres dial
@property (strong, nonatomic) DACircularProgressView *xpProgressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *xpProgressDial;

@property (strong, nonatomic) DACircularProgressView *stepsProgressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *stepsProgressDial;
- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel;

//bar chart

@property (strong, nonatomic) IBOutlet PNBarChart *stepsBarChart;

@end
