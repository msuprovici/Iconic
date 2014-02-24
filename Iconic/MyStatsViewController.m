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

#import "UIImage+RoundedCornerAdditions.h"
#import "UIImage+ResizeAdditions.h"

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
        PFQuery* query = [PFUser query];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        PFUser* currentUser = [PFUser currentUser];
        

        
        if (i == 0) {
            if (pointslabelNumber == 0) {
               
            // This is to generate thumbnail a player's thumbnail, name & title
            
            
            if (currentUser) {
                //Get all player stats from Parse
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                   // self.playerName.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kUsername]] ;
                    
                    //self.viewTitle.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerTitle]] ;
                    
                    self.pointsValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerPointsToday]];
                    
                    self.xpValue.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kPlayerXP]];
                    
//                    //Player photo
//                    //using PFImageView
//                    self.playerPhoto.file = [currentUser objectForKey:kProfilePicture];
//                    
//                    PFImageView *photo = [[PFImageView alloc] init];
//                    
//                    photo.image = [UIImage imageWithContentsOfFile:@"empty_avatar.png"]; // placeholder image
//                    photo.file = (PFFile *)self.playerPhoto.file;
//                    photo.image = [photo.image thumbnailImage:280 transparentBorder:0 cornerRadius:10 interpolationQuality:kCGInterpolationHigh];
//                    [photo loadInBackground];
//                    
//                    //turn photo to circle
//                    CALayer *imageLayer = self.playerPhoto.layer;
//                    [imageLayer setCornerRadius:self.playerPhoto.frame.size.width/2];
//                    [imageLayer setBorderWidth:0];
//                    [imageLayer setMasksToBounds:YES];
               
                }];
                
                
            }

        self.stepsImage.hidden = YES;
        self.viewTitle.hidden = YES;
        self.statsImage.hidden = YES;
        self.xpLabel.text = @"Level";
        self.pointsLabel.text = @"Points";
                
            //self.timeActiveLabel.hidden = YES;
                
            self.stepsProgressDial.hidden = true;

            
            self.xpProgressDial.trackTintColor = PNGrey;
            self.xpProgressDial.progressTintColor = PNBlue;
            
                
            [self startAnimation];
            }
        }
        if (i == 1)
        {

            if (pointslabelNumber == 1) {
                
                self.viewTitle.hidden = YES;

//            self.viewTitle.text = @"Today";
            self.xpLabel.text = @"Steps"; //[NSString stringWithFormat:@"XP", myArray[i]];
            self.pointsLabel.text = @"Active";
        
            //self.xpLabel.hidden = YES;
            //self.pointsLabel.hidden = YES;
                

            
            self.stepsProgressDial.trackTintColor = PNGrey;
            self.stepsProgressDial.progressTintColor = PNDarkBlue;
                
            self.xpProgressDial.hidden = YES;
            
//            self.xpProgressDial.trackTintColor = PNGrey;
//            self.xpProgressDial.progressTintColor = PNMauve;
//            
            self.stepsProgressDial.thicknessRatio = 1.0f;
            
                        
            self.timeActiveLabel.text = @"60%";
           // self.pointsValue.hidden = YES;
            
            
            self.xpValue.text = @"2349";
            self.pointsImage.hidden = YES;
               
            
            [self startAnimation];
            }

        }
        if (i == 2)
        {
            
            if (pointslabelNumber == 2) {
            
            self.pointsImage.hidden = YES;
            self.stepsImage.hidden = YES;
            self.timeActiveLabel.hidden = YES;
            self.pointsLabel.hidden = true;
            self.xpLabel.hidden = true;
            self.pointsValue.hidden = true;
            self.xpValue.hidden = true;
            self.playerName.hidden = true;
            self.playerPhoto.hidden = true;
            
            //self.viewTitle.hidden = true;
            
            self.pointsValue.hidden = true;
            
            self.xpValue.hidden = true;
                self.stepsProgressDial.hidden = true;
                self.xpProgressDial.hidden = true;
                
                
            }
            
            self.viewTitle.text = @"Points";
            
            
            //create bar chart to display days
            PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
            
            //list of days of the week
            NSArray * daysArray = @[@"S",@"M",@"T",@"W",@"T", @"F", @"S"];
            
            
                
            //getting points arary from server
            NSArray * playerPoints = [currentUser objectForKey:kPlayerPointsWeek];
                
            
            //create a subarray that has the range of days played based on the amout of objects in playerPoints
            NSArray *daysPlayed = [daysArray subarrayWithRange: NSMakeRange(0, [playerPoints count])];
            
            //set the labels
            [barChart setXLabels:daysPlayed];
            
            [barChart setYValues:playerPoints];
            
            //sets the maximum value of the label.  so if the player has a goal of say 10k points/day then we would use this.
            //[barChart setYLabels:@[@500]];
            
            
            [barChart setStrokeColor:PNLightBlue];
            [barChart strokeChart];
            
            [self.stepsBarChart addSubview:barChart]; 
            //}];
            
           

            
            
           

            
        }
        
        self.xpProgressDial.thicknessRatio = .25f;
        self.xpProgressDial.roundedCorners = YES;
//        self.stepsProgressDial.thicknessRatio = .25f;
//        self.stepsProgressDial.roundedCorners = YES;
        
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
