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
#import <CoreMotion/CoreMotion.h>
@interface MyStatsViewController : UIViewController

{
     NSArray *ProfileInfo;
}
@property (weak, nonatomic) IBOutlet UILabel *xpValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsValue;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeActiveLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stepsImage;
@property (strong, nonatomic) IBOutlet UIImageView *pointsImage;
@property (weak, nonatomic) IBOutlet UILabel *stepsCountingLabel;  
@property (weak, nonatomic) IBOutlet PFImageView *playerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *playerName;

@property (nonatomic, strong) IBOutlet UILabel *xpLabel;

@property (nonatomic, strong) IBOutlet UILabel *viewTitle;
@property (nonatomic, strong) IBOutlet UIImageView *statsImage;

@property (strong, nonatomic) IBOutlet UILabel *highValue;

@property (strong, nonatomic) IBOutlet UILabel *mediumValue;

@property (strong, nonatomic) IBOutlet UILabel *sevenDaysAgoDay;
@property (strong, nonatomic) IBOutlet UILabel *todayDay;

//Segmented control

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentValueChanged:(id)sender;

//page control



//step counter
@property (nonatomic, strong) CMStepCounter *stepCounter;

//step counter
@property (nonatomic, strong) CMMotionActivityManager *myActivityData;

//progres dial
@property (strong, nonatomic) DACircularProgressView *xpProgressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *xpProgressDial;

@property (strong, nonatomic) DACircularProgressView *stepsProgressView;
@property (strong, nonatomic) IBOutlet DACircularProgressView *stepsProgressDial;
- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel;

//bar chart

@property (strong, nonatomic) IBOutlet PNBarChart *stepsBarChart;


@end
