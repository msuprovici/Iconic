//
//  VSViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "VSViewController.h"

@interface VSViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation VSViewController

@synthesize progressView = _progressview;
@synthesize circleProgressView = _circleProgressView;
@synthesize timer = _timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0, 30.0, 40.0, 40.0)];
//    //self.progressView.roundedCorners = YES;
//    self.progressView.trackTintColor = [UIColor clearColor];
//    [self.view addSubview:self.progressView];
    
    
    
    self.circleProgressView.trackTintColor = PNGrey;
    self.circleProgressView.progressTintColor = PNBlue;
    self.circleProgressView.roundedCorners = YES;
    self.circleProgressView.thicknessRatio = .11f;
    
    
    [self.view addSubview:self.circleProgressView];
    
    
    
    [self startAnimation];
    
    //[self progressChange];
    //self.circleProgressView.roundedCorners = YES;
}

- (void)progressChange
{
    
    NSArray *progressViews = @[self.circleProgressView ];
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
