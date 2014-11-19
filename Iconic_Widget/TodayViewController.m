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
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

#import "Constants.h"
#import <CoreMotion/CoreMotion.h>
#import "TodayTeamsTableViewCell.h"


@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UILabel *mySteps;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstrain;
@property (strong, nonatomic) IBOutlet UILabel *streak;
@property (strong, nonatomic) IBOutlet UILabel *streakSubLabel;

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
    
    
    //dynamically change the height of the tableview
    CGFloat height = self.tableView.rowHeight;
    NSArray *arrayOfLeagueNames = [defaults objectForKey:@"widgetArrayOfLeagueNames"];
    height *= arrayOfLeagueNames.count;
    
//    CGRect tableFrame = self.tableView.frame;
//    tableFrame.size.height = height;
//    self.tableView.frame = tableFrame;

    self.tableViewHeightConstrain.constant = height + 68 ;//70 is the height of the steps label + today's steps
    
//    [self adjustHeightOfTableview];
    
//    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.contentSize.height);

}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSInteger mySteps = [defaults integerForKey:@"totalNumberStepsToday"];
    self.mySteps.text = [NSString stringWithFormat:@"%ld",(long)mySteps];
    
    //show # days in a row with steps above average
    NSInteger streak = [defaults integerForKey:@"streak"];
    
    if (streak > 1) {
        self.streak.text = [NSString stringWithFormat:@"%ld",streak];
    }
    else
    {
        self.streak.hidden = true;
        self.streakSubLabel.hidden = true;
    }

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
    
    
}


//-(void)loadTeamScoresFromParse
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"TeamName"];
//    
//    
//    PFObject * user = [PFUser currentUser];
//    
//    
//    
//    PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
//    [teamPlayersClass whereKey:kUserObjectIdString equalTo:user.objectId];
//    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
//    
//    
//    
//    
//    //Query Team Classes, find the team matchups and save the team scores to memory
//    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//    [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
//    
//    
//    
//    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//    [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
//    
//    
//    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
//    
//    //hardcoded for now but this will change depending on the tournament
//    [queryTeamMatchupsClass whereKey:kRound containsString:@"1"];
//    [queryTeamMatchupsClass includeKey:kHomeTeam];
//    [queryTeamMatchupsClass includeKey:kAwayTeam];
//    
//}


#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    
     NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSArray *arrayOfLeagueNames = [sharedDefaults objectForKey:@"widgetArrayOfLeagueNames"];
    
    return arrayOfLeagueNames.count;
    
    //return 3;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TeamCell";
    
    TodayTeamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TodayTeamsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
     NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
    NSArray *homeTeamScores = [sharedDefaults objectForKey:@"widgetArrayOfHomeTeamScores"];
    NSArray *awayTeamScores = [sharedDefaults objectForKey:@"widgetArrayOfAwayTeamScores"];
    
    NSArray *homeTeamNames = [sharedDefaults objectForKey:@"widgetArrayOfHomeTeamNames"];
    NSArray *awayTeamNames = [sharedDefaults objectForKey:@"widgetArrayOfAwayTeamNames"];
    
    NSArray *arrayOfLeagueNames = [sharedDefaults objectForKey:@"widgetArrayOfLeagueNames"];
    
    
  
        
        cell.myTeamName.text = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:indexPath.row]];
        cell.myTeamScore.text = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:indexPath.row]];
        
        cell.vsTeamName.text = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:indexPath.row]];
        cell.vsTeamScore.text = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:indexPath.row]];
        
        cell.leagueName.text = [NSString stringWithFormat:@"%@",[arrayOfLeagueNames objectAtIndex:indexPath.row]];
 
    
    
    return cell;
}

- (void)adjustHeightOfTableview
{
    
    
    
    
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = self.tableView.superview.frame.size.height - self.tableView.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the height constraint accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableViewHeightConstrain.constant = height;
        [self.view needsUpdateConstraints];
    }];
}



@end
