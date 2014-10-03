//
//  TodayViewController.m
//  Iconic_Widget
//
//  Created by Mike Suprovici on 10/3/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import <CoreMotion/CoreMotion.h>

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *mySteps;

//step counter
@property (nonatomic, strong) CMPedometer *stepCounter;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSInteger mySteps = [defaults integerForKey:@"totalNumberStepsToday"];
    self.mySteps.text = [NSString stringWithFormat:@"%ld",(long)mySteps];
    
    [self loadMySteps];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSInteger mySteps = [defaults integerForKey:@"totalNumberStepsToday"];
    self.mySteps.text = [NSString stringWithFormat:@"%ld",(long)mySteps];
    [self loadMySteps];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self reloadStepsLabel];
}

-(void)loadMySteps
{
    self.stepCounter = [[CMPedometer alloc] init];
    NSDate *now = [NSDate date];
    
    
    NSDate *from = [self beginningOfDay];
    
    
    [self.stepCounter queryPedometerDataFromDate:from toDate:now withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        
        //this methods shares today's step count with app
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
        
        [sharedDefaults setInteger:[pedometerData.numberOfSteps intValue] forKey:@"totalNumberStepsToday"];
        [sharedDefaults synchronize];

    }];
   
    
}

-(void)reloadStepsLabel
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSInteger mySteps = [defaults integerForKey:@"totalNumberStepsToday"];
    self.mySteps.text = [NSString stringWithFormat:@"%ld",(long)mySteps];
}



-(NSDate *)beginningOfDay
{
    
    //find the beginning of the day
    //nsdate always returns GMT
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
    
    //NSLog(@"Local Time Zone %@",[[NSTimeZone localTimeZone] name]);
    
    //     NSLog(@"Calendar date: %@",[cal dateFromComponents:components]);
    
    //convert GMT to my local time
    //    NSDate* sourceDate = [cal dateFromComponents:components];
    //
    //    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //    NSTimeZone* myTimeZone = [NSTimeZone localTimeZone];
    //
    //    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    //    NSInteger myGMTOffset = [myTimeZone secondsFromGMTForDate:sourceDate];
    //    NSTimeInterval interval = myGMTOffset - sourceGMTOffset;
    //
    //    NSDate* myDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate]init];
    //
    //
    //        NSLog(@"Converted date: %@",myDate);
    //        NSLog(@"Source date: %@",myDate);
    //
    //
    //    return myDate;
    
}


-(void)loadTeamScoresFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"TeamName"];
    
    
    PFObject * user = [PFUser currentUser];
    
    
    
    PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
    [teamPlayersClass whereKey:kUserObjectIdString equalTo:user.objectId];
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
    
    
    
    
    //Query Team Classes, find the team matchups and save the team scores to memory
    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
    
    
    
    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
    
    
    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
    
    //hardcoded for now but this will change depending on the tournament
    [queryTeamMatchupsClass whereKey:kRound containsString:@"1"];
    [queryTeamMatchupsClass includeKey:kHomeTeam];
    [queryTeamMatchupsClass includeKey:kAwayTeam];
    
}


@end
