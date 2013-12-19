//
//  MyStatsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "MyStatsViewController.h"
#import  <Parse/Parse.h>

@interface MyStatsViewController ()
{
    int pointslabelNumber;
    
}

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MyStatsViewController


@synthesize xpProgressView = _xpProgressView;
@synthesize xpProgressDial = _xpProgressDial;
@synthesize timer = _timer;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //pageNumber = page;
    }
    return self;
}
 */

- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel
{
    if (self = [super initWithNibName:@"MyStatsViewController" bundle:nil])
    {
        pointslabelNumber = pointslabel;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    PFFile *imageFile = [pfObject objectForKey:@"image"];
    PFImageView *imageView = [[PFImageView alloc] init];
    imageView.file = imageFile;
    [imageView loadInBackground];
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
        
        if (i == 0) {
            
            
            
            
            
        
        //self.pointsLabel.text = [NSString stringWithFormat:@"Points %d", pointslabelNumber + 1];
        self.xpLabel.text = @"XP"; //[NSString stringWithFormat:@"XP", myArray[i]];
        self.pointsLabel.text = @"Points";
        
        self.xpProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
       
        self.xpProgressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:self.xpProgressView];
        
                [self.view addSubview:self.xpProgressDial];
            
             self.stepsProgressDial.trackTintColor = [UIColor clearColor];
            self.stepsProgressDial.progressTintColor = [UIColor clearColor];
            
            self.xpProgressDial.trackTintColor = [UIColor lightGrayColor];
            self.xpProgressDial.progressTintColor = [UIColor greenColor];
            
            //set the xp value here?
            self.xpValue.text = @"3";
            self.pointsValue.text = @"45";

            
            [self startAnimation];

        }
        if (i == 1)
        {
            self.xpLabel.text = @"Steps"; //[NSString stringWithFormat:@"XP", myArray[i]];
            self.pointsLabel.text = @"Time Active";
            
            self.xpProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
            
            self.xpProgressView.trackTintColor = [UIColor clearColor];
            [self.view addSubview:self.xpProgressView];
            
            self.stepsProgressDial.trackTintColor = [UIColor lightGrayColor];
            self.stepsProgressDial.progressTintColor = [UIColor redColor];
            
            self.xpProgressDial.trackTintColor = [UIColor lightGrayColor];
            self.xpProgressDial.progressTintColor = [UIColor greenColor];
            
            self.stepsProgressDial.thicknessRatio = 1.0f;
            
            
            self.pointsValue.text = @"15";
            self.xpValue.text = @"1";
            
            [self startAnimation];

        }
        if (i == 2)
        {
            //self.xpLabel.text = @"Distance"; //[NSString stringWithFormat:@"XP", myArray[i]];
            self.pointsLabel.text = @"Activity";
            self.xpLabel.text = @"";
           /*
            self.xpProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
            
            self.xpProgressView.trackTintColor = [UIColor clearColor];
            [self.view addSubview:self.xpProgressView];
            */
            
            self.stepsProgressDial.trackTintColor = [UIColor lightGrayColor];
            self.stepsProgressDial.progressTintColor = [UIColor redColor];
            
            self.xpProgressDial.trackTintColor = [UIColor lightGrayColor];
            self.xpProgressDial.progressTintColor = [UIColor greenColor];
            
            [self startAnimation];

        }
        
        
        //self.circleProgressView.roundedCorners = YES;
        self.xpProgressDial.thicknessRatio = .25f;

        
        

    
    }
    }


- (void)progressChange
{
    
    NSArray *progressViews = @[self.xpProgressDial, self.stepsProgressDial ];
    for (DACircularProgressView *progressView in progressViews) {
        
        //this is where we will compute the score ratio and display it to the user
        //simple equation:  myteam score / opponent score
        CGFloat progress = .60;
        [progressView setProgress:progress animated:YES];
        
        if (progressView.progress >= 1.0f && [self.timer isValid]) {
            [progressView setProgress:0.f animated:YES];
        }
    }
}


- (void)startAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(progressChange) userInfo:nil repeats:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
