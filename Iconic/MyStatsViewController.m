//
//  MyStatsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "MyStatsViewController.h"
#import  <Parse/Parse.h>
#import "Constants.h"

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
    
    //    [self retrievePlayerStats];
    

    
    
    [super viewDidLoad];
    

    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
        
        if (i == 0) {
            
            // This is to generate thumbnail a player's thumbnail, name & title
            PFQuery* query = [PFUser query];
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
            PFUser* currentUser = [PFUser currentUser];
            
            if (currentUser) {
                //Get all player stats from Parse
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    self.playerName.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kUsername]] ;
                    
                    self.viewTitle.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerTitle]] ;
                    
                    self.pointsValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerPoints]];
                    
                    self.xpValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerXP]];
                    
                    
                    //Download player image in background
                    PFFile *thumbnail = [currentUser objectForKey:kProfilePicture];
                    [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                     
                    NSData *imageData = data;
                    self.playerPhoto.image = [UIImage imageWithData:imageData];
                    }];
                    
                    
                }];
                
                
            }

        
        
        self.xpLabel.text = @"XP";
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
//            self.xpValue.text = @"3";
//            self.pointsValue.text = @"45";
            
            
           // self.playerPhoto.image = [UIImage imageNamed: @"first"];
            
            
           
            
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
//retrive table view data from parse

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

//-(void)retrievePlayerStats
//{
//    PFUser *user = [PFUser currentUser];
//    
//    
//    PFQuery *query = [PFUser query];
//    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    //query.cachePolicy = kPFCachePolicyNetworkOnly;
//
//     PFObject *playerStats = [PFUser currentUser];
//    [query includeKey:kUser];
//    [query includeKey:KUsername];
//    [query includeKey:kPlayerPoints];
//    [query includeKey:kPlayerXP];
//    [[PFUser currentUser] refresh];
//    [query whereKey:kUser equalTo:user];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//     {
//         if(!error)
//         {
//             for (PFObject *object in objects) {
//                 //retrieve player stats from server
//                 NSString *playerName = playerStats[KUsername];
//                 PFFile *profilePicture = playerStats[kProfilePicture];
//                 NSString *points = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:kPlayerPoints]];
//                 NSString *xp = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:kPlayerPoints]];
//                 
//                 
//                 
//                 int steps = [[playerStats objectForKey:kPlayerSteps]intValue];//TO DO: retrieve steps from M7
//                 NSString *playerTitle = playerStats[KPlayerTitle];
//                 
//                 //Download & display player photo from parse server
//                 PFImageView *playerProfilePicture = [[PFImageView alloc] init];
//                 playerProfilePicture.image = [UIImage imageNamed:@"empty_avatar.png"];//placeholder iamge
//                 playerProfilePicture.file = (PFFile *)profilePicture;
//                 [playerProfilePicture loadInBackground];
//                 
//                 
//                 //         controller.statsImage.image = [UIImage imageNamed:[numberItem valueForKey:kImageKey]];
//                 //         controller.viewTitle.text = [numberItem valueForKey:kNameKey];
//                 
//                 self.playerName.text = playerName;
//                 self.playerPhoto = playerProfilePicture;
//                 self.viewTitle.text = playerTitle;
//                 self.xpValue.text = xp;
//                 self.pointsValue.text = points;
//
//             }
//         }
//         else
//         {
//             NSLog(@"did not retrive user stats");
//             
//                  }
//     }];
//    
//}
//

@end
