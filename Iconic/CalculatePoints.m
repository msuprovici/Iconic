//
//  CalculatePoints.m
//  Iconic
//
//  Created by Mike Suprovici on 4/23/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "CalculatePoints.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import <CoreMotion/CoreMotion.h>
#include <math.h>
#import "SimpleHomeViewController.h"
#import "VSTableViewController.h"
#import "League.h"
#import "Team.h"
#import "AppDelegate.h"

@implementation CalculatePoints


//we use this class to calculate fetched points

//
//@synthesize teamMatchups;
//
//
//+ (id)sharedManager {
//    static CalculatePoints *sharedMyManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedMyManager = [[self alloc] init];
//
//        
//    });
//    return sharedMyManager;
//}
//
//- (id)init {
//    if (self = [super init]) {
//        
//        
//        
//        
//        //Query Team Class
//        PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];core
//        
//        //Query Team Class to see if the player's current team is the HOME team
//        PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//        [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
//        
//        
//        
//        PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//        [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
//        
//        
//        PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
//        
//        [queryTeamMatchupsClass includeKey:kHomeTeam];
//        [queryTeamMatchupsClass includeKey:kAwayTeam];
//        
//
//        queryAwayTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
//        queryHomeTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
//        
//        [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            
//            
//            
//            if(!error)
//            {
//                
//                
//                if(objects.count > 0)
//                {
//                    
//                    for (int i = 0; i < objects.count; i++) {
//                        
//                        PFObject *myMatchupObject = [objects objectAtIndex:i];
//                        
//                        
//                        NSString * round = [myMatchupObject objectForKey:kRound];
//                        
//                        
//                        //the round is hardcoded for now, need to make this dynamic based on the torunatment's status
//                        if ([round  isEqual: @"1"])
//                        {
//                            
//                            
////                            VSTableViewController * vsTableViewController = [[VSTableViewController alloc]init];
////                            vsTableViewController.teamMatchups = objects;
//                            teamMatchups = [[NSArray alloc] init];
//                            teamMatchups = objects;
//                            
//                        }
//                    }
//                    
//                }
//                
//            }
//        }];
//
//    }
//    return self;
//}
//
//- (void)dealloc {
//    // Should never be called, but just here for clarity really.
//}
//
//static CalculatePoints *sharedSingleton;
//
//+ (void)initialize
//{
//    static BOOL initialized = NO;
//    if(!initialized)
//    {
//        initialized = YES;
//        sharedSingleton = [[CalculatePoints alloc] init];
//        
//        
//    }
//}
//
////+(CalculatePoints *)singleton {
////    static dispatch_once_t pred;
////
////    static CalculatePoints *shared = nil;
////    dispatch_once(&pred, ^{
////        shared = [[CalculatePoints alloc] init];
////        shared.teamMatchups = [[NSArray alloc]init];
////    });
////    return shared;
////}






#pragma mark Parse methods

- (void) retrieveFromParse {
    
    //set the player's teams in memory
    NSUserDefaults *myRetrievedTeams = [NSUserDefaults standardUserDefaults];

    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if(!error)
        {
//            NSLog(@"the number of teams I am on: %lu", (unsigned long)objects.count);
            
            //count the number of teams teh player is on
            //we use this number in simple viewcontroller to determine state
            NSUserDefaults *Teams = [NSUserDefaults standardUserDefaults];
            [Teams setInteger:objects.count forKey:kNumberOfTeams];
            [Teams synchronize];
            
            
            
            self.arrayOfMyTeamNames = [[NSMutableArray alloc] init];

            
            //check to see if the player is on a team
            if(objects.count > 0)
            {
                
                //                NSLog(@"team class query worked");
                

                
                //convert NSArray to myTeamDataArray
                self.myTeamData = [self createMutableArray:objects];
                
                
                
                
//                 NSLog(@"my teams: %@",  self.myTeamData);
//                 NSArray *myTeamDataArray = [self.myTeamData copy];
                
                
                for (int i = 0; i < objects.count; i++) {
                    
                   
                    
                    
                    PFObject *myTeamObject = objects[i];
                    
                    NSString * myTeamName = [myTeamObject objectForKey:kTeams];
                    
                    //create an array of my team names
//                    [self.arrayOfMyTeamNames addObject:myTeamName];
                    [self.arrayOfMyTeamNames insertObject:myTeamName atIndex:i];
//                     NSLog(@"arrayOfMyTeamNames: %@",  self.arrayOfMyTeamNames);
                    

                    //save the array of my team names to nsuserdefaults
                    [myRetrievedTeams setObject:self.arrayOfMyTeamNames  forKey:kArrayOfMyTeamsNames];
                    [myRetrievedTeams synchronize];
                        
                   
                    
                };
                
             
                
                
                

            }
            else
            {
//                NSLog(@"the number of teams I am on is 0");
                
                //player is not on a team so set number of teams to 0
                //we use this number in simpleviewcontroller to determine state
                NSUserDefaults *Teams = [NSUserDefaults standardUserDefaults];
                [Teams setInteger:0 forKey:kNumberOfTeams];
                [Teams synchronize];
                
                

                
            }
            
            
            
            
        }
        else
        {
            
        }
        
        
    }];
    
    //Query Team Classes, find the team matchups and save the team scores to memory
    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
    
    
    
    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
    
    
    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
    
    [queryTeamMatchupsClass includeKey:kHomeTeam];
    [queryTeamMatchupsClass includeKey:kAwayTeam];
    
    
    queryAwayTeamMatchups.cachePolicy = kPFCachePolicyNetworkElseCache;
    queryHomeTeamMatchups.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        if(!error)
        {
            
            
            if(objects.count > 0)
            {
                
                for (int i = 0; i < objects.count; i++) {
                                        PFObject *myMatchupObject = [objects objectAtIndex:i];
                    
                    
                    NSString * round = [myMatchupObject objectForKey:kRound];
                    
                    
                    self.arrayOfhomeTeamScores = [[NSMutableArray alloc] init];
                    self.arrayOfawayTeamScores = [[NSMutableArray alloc] init];
                    
                    self.arrayOfhomeTeamNames = [[NSMutableArray alloc] init];
                    self.arrayOfawayTeamNames = [[NSMutableArray alloc] init];
                    
                    self.awayTeamPointers = [[NSMutableArray alloc] init];
                    self.homeTeamPointers = [[NSMutableArray alloc] init];
                    
                    
                    self.arrayOfWeekleyHomeTeamScores = [[NSMutableArray alloc] init];
                    self.arrayOfWeekleyAwayTeamScores = [[NSMutableArray alloc] init];
                    
                    
                    self.arrayOfTodayHomeTeamScores = [[NSMutableArray alloc] init];
                    self.arrayOfTodayAwayTeamScores = [[NSMutableArray alloc] init];
                    
                    //self.myMatchups = [[NSMutableArray alloc] init];
                   

                    //the round is hardcoded for now, need to make this dynamic based on the torunatment's status
                    if ([round  isEqual: @"1"])
                    {
                        
                        
                        for (int i = 0; i < objects.count; i++) {
                            
                            PFObject *myMatchupObject = [objects objectAtIndex:i];
//                            NSLog(@"objects count: %lu", (unsigned long)objects.count);
                            
                            if (objects.count >= 1) {
//                                NSLog(@"objects > 1: %lu", (unsigned long)objects.count);
                            }
                            else
                            {
//                                NSLog(@"objects == 0");
                            }
                            
                            //add all objects to a array so that we can send the correct one to the next view controller
                            self.myMatchups = objects;
                            
                            
                            //acces away & home team pointers in parse
                            PFObject* awayTeamPointer = [myMatchupObject objectForKey:kAwayTeam];
                            PFObject* homeTeamPointer = [myMatchupObject objectForKey:kHomeTeam];
                            
                            //add pointers to an array & save to NSUserDefaults
                            [self.awayTeamPointers addObject:awayTeamPointer];
                            [self.homeTeamPointers addObject:homeTeamPointer];
                            
                            
                            //Home Team Scores
                            
                            NSString * homeTeamName = [homeTeamPointer objectForKey:kTeams];
                            NSNumber * homeTeamTotalScore = [homeTeamPointer objectForKey:kScore];
                            
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfhomeTeamScores addObject:homeTeamTotalScore];
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfhomeTeamNames addObject:homeTeamName];
                            
                            //aray of arays of daily scores
                            NSMutableArray * arrayOfWeekleyHomeScores = [homeTeamPointer objectForKey: kScoreWeek];
//                            NSLog(@"initial arrayOfWeekleyScores in calculate points: %@", arrayOfWeekleyHomeScores);
                            
                            
                            
                            //add all the home team scores for TODAY to an array
                            NSNumber * todaysTotalScore = [homeTeamPointer objectForKey:kScoreToday];
//                            NSLog(@"todaysTotalScore in calculate points: %@", todaysTotalScore);
                            [self.arrayOfTodayHomeTeamScores addObject:todaysTotalScore];
                            
                            
                            
                            
                            //array of arrays: add the arrays of weekeley home scores to an array
                            [self.arrayOfWeekleyHomeTeamScores addObject:arrayOfWeekleyHomeScores];
//                                NSLog(@"arrayOfTodayHomeTeamScores CP %@", self.arrayOfTodayHomeTeamScores);
                           
                            
                            //save to NSUserdefaults
                            [myRetrievedTeams setObject:self.arrayOfTodayHomeTeamScores  forKey:kArrayOfTodayHomeTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfhomeTeamScores  forKey:kArrayOfHomeTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfhomeTeamNames  forKey:kArrayOfHomeTeamNames];
                            [myRetrievedTeams setObject:self.arrayOfWeekleyHomeTeamScores  forKey:kArrayOfWeekleyHomeTeamScores];
//                            NSLog(@"array of weekley arrays in calculate points: %@", self.arrayOfWeekleyHomeTeamScores);
                            [myRetrievedTeams synchronize];

                            
                            //Away Team Scores
                            //get awayTeamScores(array)
                            
                            NSString * awayTeamName = [awayTeamPointer objectForKey:kTeams];
                            NSNumber * awayTeamTotalScore = [awayTeamPointer objectForKey:kScore];
                            
                            
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfawayTeamScores addObject:awayTeamTotalScore];
                            
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfawayTeamNames addObject:awayTeamName];
                            
                           //array of everyday scores for the week
                            NSMutableArray * arrayOfAwayWeekleyScores = [awayTeamPointer objectForKey: kScoreWeek];
//                            NSLog(@"initial arrayOfAwayWeekleyScores in calculate points: %@", arrayOfAwayWeekleyScores);
                            
                            //add all the away team scores for TODAY to an array
                            NSNumber * todaysTotalAwayScore = [awayTeamPointer objectForKey:kScoreToday];
                            
                            [self.arrayOfTodayAwayTeamScores addObject:todaysTotalAwayScore];
//                             NSLog(@"arrayOfTodayAwayTeamScores CP %@", self.arrayOfTodayAwayTeamScores);
                            

                            //create an array of arrays of weekley teams scores
                            [self.arrayOfWeekleyAwayTeamScores addObject:arrayOfAwayWeekleyScores];
//                            NSLog(@"self.arrayOfWeekleyHomeTeamScores: %@", self.arrayOfWeekleyAwayTeamScores);

                           
                            
                            
                            //save to NSUserdefaults
                            [myRetrievedTeams setObject:self.arrayOfTodayAwayTeamScores  forKey:kArrayOfTodayAwayTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfawayTeamScores  forKey:kArrayOfAwayTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfawayTeamNames  forKey:kArrayOfAwayTeamNames];
                            [myRetrievedTeams setObject:self.arrayOfWeekleyAwayTeamScores  forKey:kArrayOfWeekleyAwayTeamScores];
                            
                            [myRetrievedTeams synchronize];

                            //logs
//                             NSLog(@"awayTeamPointer: %@", awayTeamPointer);
//                            NSLog(@"homeTeamPointer: %@", homeTeamPointer);
//                            
//                            NSLog(@"awayTeamName: %@", awayTeamName);
//                            NSLog(@"homeTeamName: %@", homeTeamName);
//                            
//                            NSLog(@"awayTeamTotalScore: %@", awayTeamTotalScore);
//                            NSLog(@"homeTeamTotalScore: %@", homeTeamTotalScore);
//                            
//                            NSLog(@"self.arrayOfhomeTeamScores: %@", self.arrayOfhomeTeamScores);
//                             NSLog(@"self.arrayOfawayTeamScores: %@", self.arrayOfawayTeamScores);
//                            
//                            NSLog(@"self.arrayOfhomeTeamNames: %@", self.arrayOfhomeTeamNames);
//                            NSLog(@"self.arrayOfawayTeamNames: %@", self.arrayOfawayTeamNames);
                            
                            //self.arrayOfhomeTeamScores
                            
//                            NSLog(@"awayTeamScoresArray: %@", awayTeamScoresArray);
//                             NSLog(@"homeTeamScoresArray: %@", homeTeamScoresArray);
//                            NSLog(@"awayTeamNamesArray: %@", awayTeamNamesArray);
//                            NSLog(@"homeTeamNamesArray: %@", homeTeamNamesArray);
                            
                            
                            
                            //                    //home team
                            //                    NSLog(@"homeTeamScores: %lu", (unsigned long)self.homeTeamScores.count);
                            //                    NSLog(@"arrayOfhomeTeamScores: %lu", (unsigned long)self.arrayOfhomeTeamScores.count);
                            //                    
                            //                    //away team
                            //                    NSLog(@"awayTeamScores: %lu", (unsigned long)self.awayTeamScores.count);
                            //                    NSLog(@"arrayOfawayTeamScores: %lu", (unsigned long)self.arrayOfawayTeamScores.count);
                            //                        
                            //                    //pointers
                            //                    NSLog(@"awayTeamPointers: %lu", (unsigned long)self.awayTeamPointers.count);
                            //                    NSLog(@"homeTeamPointers: %lu", (unsigned long)self.arrayOfawayTeamScores.count);
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
            
        }
        else
        {
          
        }
        
        
    }];
    
    
    //synchronize everything
//    [myRetrievedTeams synchronize];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}


#pragma mark points calcuations


-(void)incrementPlayerPointsInBackground
{
    
    //listen for nsnotification
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(joinedMyFirstTeam:)
//                                                 name:@"playerJoinedTheirFirstTeam"
//                                               object:nil];
    
    
    
    //    NSLog(@"incrementPlayerPoints in calcualte points just got called");
    
    
//    SimpleHomeViewController * simpleViewController = [[SimpleHomeViewController alloc]init];
//    
//    if (simpleViewController.joinedTeamButtonPressed  == YES) {
//        NSLog(@"Player joined 1st team");
//    }
    
    
    self.stepCounter = [[CMStepCounter alloc] init];
    NSDate *now = [NSDate date];
    
    
    NSDate *from = [self beginningOfDay];
    
    //find the number of steps I have taken today
    [self.stepCounter queryStepCountStartingFrom:from to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        
        
        
        //convert steps to points
        //check for NAN values
        
        
       
        
        if(numberOfSteps == 0)
        {
         
            
            self.myPoints = 0;
                
            
        }
        else
        {
         

            self.myPoints = [self calculatePoints:numberOfSteps];
          
            
            self.mySteps = &(numberOfSteps);
            
        }
        
        
        
         //set the player's total points in memory//set the player's total points in memory

        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        [myRetrievedPoints synchronize];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            
            
//            bool jointedFirstTeam = [myRetrievedPoints boolForKey:@"PlayerJointedFirstTeam"];
//            NSLog(@"jointedFirstTeam # of steps = 0 %d" , jointedFirstTeam);
//            if (jointedFirstTeam == YES) {
//                
////                NSLog(@"jointedFirstTeam # of steps = 0 %d" , jointedFirstTeam);
//                
//                [myRetrievedPoints setBool:NO forKey:@"PlayerJointedFirstTeam"];
//                [myRetrievedPoints synchronize];
//                
//                //hardcoded 100 bonus points to the player for joining their 1st team
//                [myRetrievedPoints setInteger:100 forKey:kMyMostRecentPointsBeforeSaving];
//                [myRetrievedPoints setInteger:100 forKey:kMyMostRecentStepsBeforeSaving];
//                
//                [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
//                
//                [myRetrievedPoints synchronize];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                
//                //save the player's points for today to the server
//                PFObject *playerPoints = [PFUser currentUser];
//                NSNumber *myPointsConverted = [NSNumber numberWithInt:100];
//                [playerPoints setObject:myPointsConverted forKey:kPlayerPointsToday];
//                //            [playerPoints save];
//                [playerPoints saveInBackground];
//                
//            }
//
//            else
//            {
            
            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentPointsBeforeSaving];
            [myRetrievedPoints setInteger:0 forKey:kMyMostRecentStepsBeforeSaving];
            
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
            
            [myRetrievedPoints synchronize];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //save the player's points for today to the server
            PFObject *playerPoints = [PFUser currentUser];
            NSNumber *myPointsConverted = [NSNumber numberWithInt:0];
            [playerPoints setObject:myPointsConverted forKey:kPlayerPointsToday];
            //            [playerPoints save];
            [playerPoints saveInBackground];
//            }
            
        }
        
        else
        {
            [self incrementMyPoints];
        }
//        {
//            
//
//            
//            
//            int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsToday];
//            int myMostRecentPointsValue = [self.myPoints intValue];
//            int self.myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
//            
////                                NSLog(@"myFetchedStoredPoints: %d", myStoredPoints);
////                                NSLog(@"myFetchedMostRecentPointsValue: %d", myMostRecentPointsValue);
////                                NSLog(@"myFetchedPointsDeltaValue: %d", self.myPointsDeltaValue);
//            
//            
//            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
//            
//            
//            //increment a player's total # of points
//            
//            int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsTotal];
//            [myRetrievedPoints synchronize];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            int myNewTotalPoints = myTotalPoints + self.myPointsDeltaValue;
//            
//            
//            //                    NSLog(@"myFetchedTotalPoints: %d", myTotalPoints);
//            //                    NSLog(@"myFetchedNewTotalPoints: %d", myNewTotalPoints);
//            
//            [myRetrievedPoints setInteger:myNewTotalPoints  forKey:kMyFetchedPointsTotal];
//            [myRetrievedPoints synchronize];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            //save the player's points for today to the server
//            PFObject *playerPoints = [PFUser currentUser];
//            [playerPoints setObject:self.myPoints forKey:kPlayerPointsToday];
//            //            [playerPoints saveEventually];
//            //            [playerPoints saveInBackground];
//            
//            //            [playerPoints save]; //<-must execute on main thread in background mode?  saveEventually & saveInBackground do not work
//            [playerPoints saveInBackground];
//            
//            NSNumber *myLevel = [self calculateLevel:myNewTotalPoints];
//            
//            //save to NSuserdefaults
//            [myRetrievedPoints setInteger:[myLevel intValue]  forKey:@"myLevel"];
//            
//            float myLevelValue = [myLevel floatValue];
//            [myRetrievedPoints synchronize];
//            
//            //get the total points necessary for next level
//            
//            NSNumber *totalPointsToNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
//            
//            int myTotalPointsToNextLevelValue = [totalPointsToNextLevel intValue];
//            
//            
//            int pointsToNextLevelDelta = myTotalPointsToNextLevelValue - myNewTotalPoints;
////                          NSLog(@"pointsToNextLevelDelta: %d", pointsToNextLevelDelta);
//            
//            //calculate the # of points necessary to reach the next level
//            NSNumber* myPointsToNextLevelDelta = [NSNumber numberWithInt:pointsToNextLevelDelta];
//            
//            //convert delta to NSNumber so we can increment later
//            NSNumber* myNSPointsDeltaValue = [NSNumber numberWithInt:self.myPointsDeltaValue];
//            
//            
//            //increment the points for all my teams
//            [self incrementMyTeamsPointsInBackground:myNSPointsDeltaValue];
//            
//            
//            
//            
//            
//            
//            
//            PFQuery *query = [PFUser query];
//            [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
//            
//            
//            
//            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                
//                if(!error)
//                {
//                    
//                    [object incrementKey:kPlayerPoints byAmount:myNSPointsDeltaValue];
//                    
//                    
//                    //set player's level
//                    [object setObject:myLevel forKey:kPlayerXP];
//                    //save #points needed to reach the next level
//                    
//                    [object setObject:myPointsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
//                    //save the player's points for today to the server
//                    
//                    //save points
//                    //                    [object save];
//                    
//                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        if (succeeded) {
////                            NSLog(@"Player stats save succeded");
//                        }
//                        else{
////                            NSLog(@"Player stats save failed");
//                        }
//                    }];
//                    
//                    
//                    
//                }
//                
//                
//            }];
//            
//        }
        
    }];
    
}




//-(void)joinedMyFirstTeam:(NSNotification *) notification
//{
////    self.playerJoinedTheirFirstTeam = YES;
//    
//    
//    if ([[notification name] isEqualToString:@"playerJoinedTheirFirstTeam"])
//    {
//    NSLog(@"I joined my first team");
//        
//    }
//    
//}


-(void)incrementMyPoints
{
    
    //set the player's total points in memory
    NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];

    
    
    int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsToday];
    int myMostRecentPointsValue = [self.myPoints intValue];
//    bool jointedFirstTeam = [myRetrievedPoints boolForKey:@"PlayerJointedFirstTeam"];
//    
//    NSLog(@"jointedFirstTeam = NO  %d" , jointedFirstTeam);
//    
//    if (jointedFirstTeam == YES) {
//        
//        NSLog(@"jointedFirstTeam = YES  %d" , jointedFirstTeam);
//        [myRetrievedPoints setBool:NO forKey:@"PlayerJointedFirstTeam"];
//        [myRetrievedPoints synchronize];
//        
//        //hardcoded 100 bonus points to the player for joining their 1st team
//        self.myPointsDeltaValue = 100;
//        [myRetrievedPoints setInteger:self.myPointsDeltaValue forKey:@"myPointsDelta"];
//        [myRetrievedPoints synchronize];
//    }
//    else
//    {
    self.myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
    
    
//                                    NSLog(@"myFetchedStoredPoints: %d", myStoredPoints);
//                                    NSLog(@"myFetchedMostRecentPointsValue: %d", myMostRecentPointsValue);
//                                    NSLog(@"myFetchedPointsDeltaValue: %d", self.myPointsDeltaValue);
    
    
    [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
    
    
    //increment a player's total # of points
    
    int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsTotal];
    [myRetrievedPoints synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int myNewTotalPoints = myTotalPoints + self.myPointsDeltaValue;
    
//    
//                       NSLog(@"myFetchedTotalPoints: %d", myTotalPoints);
//                        NSLog(@"myFetchedNewTotalPoints: %d", myNewTotalPoints);
    
    [myRetrievedPoints setInteger:myNewTotalPoints  forKey:kMyFetchedPointsTotal];
    [myRetrievedPoints synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //save the player's points for today to the server
    PFObject *playerPoints = [PFUser currentUser];
    [playerPoints setObject:self.myPoints forKey:kPlayerPointsToday];
    //            [playerPoints saveEventually];
    //            [playerPoints saveInBackground];
    
    //            [playerPoints save]; //<-must execute on main thread in background mode?  saveEventually & saveInBackground do not work
    [playerPoints saveInBackground];
    
    NSNumber *myLevel = [self calculateLevel:myNewTotalPoints];
    
    //save to NSuserdefaults
    [myRetrievedPoints setInteger:[myLevel intValue]  forKey:@"myLevel"];
    
    float myLevelValue = [myLevel floatValue];
    [myRetrievedPoints synchronize];
    
    //get the total points necessary for next level
    
    NSNumber *totalPointsToNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
    
    int myTotalPointsToNextLevelValue = [totalPointsToNextLevel intValue];
    
    
    int pointsToNextLevelDelta = myTotalPointsToNextLevelValue - myNewTotalPoints;
    //                          NSLog(@"pointsToNextLevelDelta: %d", pointsToNextLevelDelta);
    
    //calculate the # of points necessary to reach the next level
    NSNumber* myPointsToNextLevelDelta = [NSNumber numberWithInt:pointsToNextLevelDelta];
    
    //convert delta to NSNumber so we can increment later
    NSNumber* myNSPointsDeltaValue = [NSNumber numberWithInt:self.myPointsDeltaValue];
    
    
    //increment the points for all my teams
    [self incrementMyTeamsPointsInBackground:myNSPointsDeltaValue];
    
    
    
    
    
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    
    
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(!error)
        {
            
            [object incrementKey:kPlayerPoints byAmount:myNSPointsDeltaValue];
            
            
            //set player's level
            [object setObject:myLevel forKey:kPlayerXP];
            //save #points needed to reach the next level
            
            [object setObject:myPointsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
            //save the player's points for today to the server
            
            //save points
            //                    [object save];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //                            NSLog(@"Player stats save succeded");
                }
                else{
                    //                            NSLog(@"Player stats save failed");
                }
            }];
            
            
            
        }
        
        
    }];
    
}


-(void)incrementMyTeamsPointsInBackground:(NSNumber*)delta
{
    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    
    //force the queries to be network only
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    //had to set the cahce policy to kPFCachePolicyNetworkElseCache
    //kPFCachePolicyCacheThenNetwork ran the query bellow 2x and dobled kScore & kScoreToday
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    //Query where the current user is a teamate
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (!error) {
            // The find succeeded.
            //            NSLog(@"Successfully retrieved my %lu teams", (unsigned long)objects.count);
//            for (PFObject *object in objects)
//                
//            {
                //NSLog(@"%@", object.objectId);
                
//            NSLog(@"objects count %lu", (unsigned long)objects.count);

               for( int i = 0; i < objects.count; i++)
               {
                   PFObject *myTeams = [objects objectAtIndex:i];
                    //increment the team's TOTAL points
                    [myTeams incrementKey:kScore byAmount:delta];
                    
                    //increment the team's points for today
                    [myTeams incrementKey:kScoreToday byAmount:delta];
//                NSLog(@"delta in query %@", delta);
                    //                    [object save];
//                    [object saveInBackground];
                    //                    [object saveEventually];
                
                    [myTeams saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
//                            NSLog(@"Team stats succesfully saved");
                        }
                        else{
//                            NSLog(@"Team stats failed to save");
                        }
                    }];
                   
               }
//            }
            
        }
        else
        {
            //  NSLog(@"error");
        }
        
    }];
    
}

//7 days steps

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

-(void)findPastWeekleySteps {
    // Get now date
    NSDate *now = [NSDate date];
    
    // Array to hold step values
    _stepsArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    // Check if step counting is avaliable
    if ([CMStepCounter isStepCountingAvailable]) {
        // Init step counter
        self.cmStepCounter = [[CMStepCounter alloc] init];
        
        
        CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
        NSDate *beginningOfDay = [calculatePointsClass beginningOfDay];
        
        // Tweak this value as you need (you can also parametrize it)
        NSInteger daysBack = 6;
        for (NSInteger day = daysBack; day > 0; day--) {
            
            
            //            NSDate *fromDate = [now dateByAddingTimeInterval: -day * 24 * 60 * 60];
            
            //             NSDate *toDate = now;
            
            NSDate *fromDate = [beginningOfDay dateByAddingTimeInterval: -day * 24 * 60 * 60];
            
            NSDate *toDate = [fromDate dateByAddingTimeInterval:24 * 60 * 60];
            
            //find the last 6 days worth of steps
            [self.cmStepCounter queryStepCountStartingFrom:fromDate to:toDate     toQueue:self.operationQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
                if (!error) {
                    //                    NSLog(@"queryStepCount returned %ld steps", (long)numberOfSteps);
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [_stepsArray addObject:@(numberOfSteps)];
                        
                        
                        if ( day == 1) { // Just reached the last element, we can now do what we want with the data
                            //                            NSLog(@"_stepsArray filled with data: %@", _stepsArray);
                            
                            //convert the past 7 days worth of steps to points
                            NSMutableArray * myWeekleyPoints = [[NSMutableArray alloc]initWithCapacity:7];
                            
                            for (int i = 0; i < _stepsArray.count; i++)
                            {
                                float daysSteps = [[_stepsArray objectAtIndex:i]floatValue] ;
                                
                                CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
                                
                                [myWeekleyPoints insertObject:[calculatePointsClass calculatePoints:daysSteps] atIndex:i];
                                
//                                if (numberOfSteps == 0)
                                
                                //prevent null values
                                //if 0 steps, insert 0 for the object at index
                                
//                                  if([_stepsArray objectAtIndex:i] == 0)
//                                {
//                                    
//                                    [myWeekleyPoints insertObject:[NSNumber numberWithInt:0] atIndex:i];
//                                }
//                                else
//                                {
//                                    [myWeekleyPoints insertObject:[calculatePointsClass calculatePoints:daysSteps] atIndex:i];
//                                    
//                                    //[myWeekleyPoints addObject:[calculatePointsClass calculatePoints:daysSteps]];
//                                }
                            }

                            
                            //find the points and steps for today
                            [self.cmStepCounter queryStepCountStartingFrom:toDate to:now     toQueue:self.operationQueue withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                
                                if(!error)
                                {
                                    [_stepsArray addObject:@(numberOfSteps)];
                                    
                                    //add the past 7 days worth of steps to NSuserdefualuts
                                    
                                    NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
                                    [myStats setObject:_stepsArray forKey:kMyStepsWeekArray];
                                    
                                    
//                                    //convert the past 7 days worth of steps to points
//                                    NSMutableArray * myWeekleyPoints = [[NSMutableArray alloc]initWithCapacity:7];
//                                    
//                                    for (int i = 0; i < _stepsArray.count; i++)
//                                    {
//                                        float daysSteps = [[_stepsArray objectAtIndex:i]floatValue] ;
//                                        
//                                        CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
                                    
                                    if (numberOfSteps == 0) {
                                        [myWeekleyPoints addObject:[NSNumber numberWithInt:0]];
                                    }
                                    else
                                    {
                                        [myWeekleyPoints addObject:[calculatePointsClass calculatePoints:numberOfSteps]];
                                    }
//                                    }
                                    
//                                    NSLog(@"myWeekleyPoints: %@", myWeekleyPoints);
                                    
                                    //save to NSUserDefaults
                                    [myStats setObject:myWeekleyPoints forKey:kMyPointsWeekArray];
                                    
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    
                                    //save the past 7 days worth of steps & points to Parse
                                    PFObject *playerStats = [PFUser currentUser];
                                    [playerStats setObject:_stepsArray forKey:kPlayerStepsWeek];
                                    [playerStats setObject:myWeekleyPoints forKey:kPlayerPointsWeek];
                                    [playerStats saveEventually];
                                    
                                }
                                else {
                                    NSLog(@"Today's step count Error occured: %@", error.localizedDescription);
                                }
                                
                            }];
                            
                            
                            
                        }
                        
                    }];
                    
                    
                } else {
                    NSLog(@"Error occured: %@", error.localizedDescription);
                }
            }];
            
            
            
            
            
            
        }
    } else {
        NSLog(@"device not supported");
    }
    
    
    
}




-(NSNumber*)calculatePoints:(float)steps
{
    
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
    if([points isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        return [NSNumber numberWithInt:0];
    }
    else
    {
        return points;
    }
    
}


-(NSNumber*)calculateLevel:(float)points
{
    
    //scale = 11
    //hardcoded for now - will need to send this number down from the server
    //rounded up to the largest following integer using ceiling function
    //had to add 1.0 so that the level is never 0
    // NSNumber * level = [NSNumber numberWithFloat: ceil((pow((points/1000), (1/1)))+1.0)];
    
    
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * level = [NSNumber numberWithFloat: floor((pow((points/1000), (1/1)))+1.0)];
    
    //    if(level == 0 || level == nil)
    //        return [NSNumber numberWithInteger:1];
    //    else
    //    return level;
    
    if([level isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        return [NSNumber numberWithInt:0];
    }
    else
    {
        return level;
    }
    
    
}

-(NSNumber*)calculatePointsToReachNextLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(level, 1)*1000))+1]; //rounded up to the largest following integer using ceiling function
    
    
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level, 1)*1000))+1];
    
    //    return points;
    if([points isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        return [NSNumber numberWithInt:0];
    }
    else
    {
        return points;
    }
    
    
}

-(NSNumber*)calculatePointsToReachCurrentLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level-1, 1)*1000))+1];
    
    //    return points;
    
    if([points isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        return [NSNumber numberWithInt:0];
    }
    else
    {
        return points;
    }
    
}


#pragma mark NSDate & Time
//find the beginning of the day
-(NSDate *)beginningOfDay
{
    
    //find the beginning of the day
    //nsdate always returns GMT
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
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

-(void)calculateDaysLeftinTheWeek
{
    //get Sunday in the current week
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    //    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    //calculate beginning of next week
    /* !This approach might not work on daylight savigs! */
    [componentsToSubtract setDay: 8 - ([weekdayComponents weekday] - 1)];
    
    
    NSDate *beginningOfNextWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    /*
     Optional step:
     beginningOfNextWeek now has the same hour, minute, and second as the original date (today).
     To normalize to midnight, extract the year, month, and day components and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfNextWeek];
    beginningOfNextWeek = [gregorian dateFromComponents:components];
    
    
    //get the difference between the 2 dates
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *newComponents = [gregorian components:unitFlags fromDate:today toDate:beginningOfNextWeek options:0];
    //    NSInteger months = [newComponents month];
    self.daysLeft = (int)[newComponents day];
    
    NSLog(@"days left in the week: %d", (int)self.daysLeft);
}


#pragma mark Motion methods

//use this to calculate how long the person spent driving, walking, running, stationary
//    CMMotionActivityManager *motionActivityManagerQuery = [[CMMotionActivityManager alloc] init];
//
//
//    [motionActivityManagerQuery queryActivityStartingFromDate:from toDate:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray *activities, NSError *error) {
//
//
//        for(CMMotionActivity *motionActivity in activities){
//
//            if(motionActivity.walking)
//            {
//           // NSTimeInterval walking = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval walking = [motionActivity.startDate timeIntervalSinceDate:from];
//
//                NSLog(@"walking %f", walking/60);
//            }
//
//            if(motionActivity.stationary)
//            {
//                //NSTimeInterval stationary = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval stationary = [motionActivity.startDate timeIntervalSinceDate:from];
//
//                NSLog(@"stationary %f", stationary/60);
//            }
//
//            if(motionActivity.running)
//            {
////                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval running = [motionActivity.startDate timeIntervalSinceDate:from];
//
//                NSLog(@"running %f", running/60);
//            }
//
//
//            if(motionActivity.unknown)
//            {
//                //                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval unknown = [motionActivity.startDate timeIntervalSinceDate:from];
//
//                NSLog(@"unknown %f", unknown/60);
//            }
//
//            if(motionActivity.automotive)
//            {
//                //                NSTimeInterval running = [now timeIntervalSinceDate:motionActivity.startDate];
//                NSTimeInterval automotive = [motionActivity.startDate timeIntervalSinceDate:from];
//
//                NSLog(@"automotive %f", automotive/60);
//            }
//
//
//
//
////
////            NSLog(@"--------------------");
////
////            // startDate
////            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
////            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////            NSString *startDateString = [dateFormatter stringFromDate:motionActivity.startDate];
////            NSLog(@"startDate = %@", startDateString);
////
////            // stationary
////            NSLog(@"motionActivity.stationary = %@", motionActivity.stationary?@"YES":@"NO");
////
////            // walking
////            NSLog(@"motionActivity.walking = %@", motionActivity.walking?@"YES":@"NO");
////
////            // running ．
////            NSLog(@"motionActivity.running = %@", motionActivity.running?@"YES":@"NO");
////
////            // automotive ．
////            NSLog(@"motionActivity.automobile = %@", motionActivity.automotive?@"YES":@"NO");
////
////            // unknown
////            NSLog(@"motionActivity.unknown = %@", motionActivity.unknown?@"YES":@"NO");
////
////            // confidence
////            NSString *confidenceString = @"";
////            switch (motionActivity.confidence) {
////                case CMMotionActivityConfidenceLow:
////                    confidenceString = @"CMMotionActivityConfidenceLow";
////                    break;
////                case CMMotionActivityConfidenceMedium:
////                    confidenceString = @"CMMotionActivityConfidenceMedium";
////                    break;
////                case CMMotionActivityConfidenceHigh:
////                    confidenceString = @"CMMotionActivityConfidenceHigh";
////                    break;
////                default:
////                    confidenceString = @"???";
////                    break;
////            }
////            NSLog(@"confidence = %@", confidenceString);
//
//        }
//
//
//
//    }];

#pragma mark Local Notification
-(void)scheduleDailySummaryLocalNotification
{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
//    //sechedule for tomorrow
//    components.day = 1;
    
    //set time for 10am
    [components setHour:10];
    [components setMinute:0];
    [components setSecond:0];
    
    //Alert Body

    //create local notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    //set time
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    localNotification.fireDate = [cal dateByAddingComponents:components toDate:now options:0];
   localNotification.fireDate = [cal dateFromComponents:components];
    
    //repeate daily
    localNotification.repeatInterval = NSCalendarUnitDay;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //use yesterday's points and steps
//    localNotification.alertBody = [NSString stringWithFormat:@"You scored %@ points on %@ steps yesterday.",
//                                   yesterdayPoints, yesterdaySteps];
    
    localNotification.alertBody = [self getYesterdaysPointsAndSteps];
    
//    [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:self.matchupsIndex]];
    
    
    //used in UIAlert button or 'slide to unlock...' slider in place of unlock
    localNotification.alertAction = @"Summary";

    //increase badge number
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    //schedule the local notfication
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


-(NSString *)getYesterdaysPointsAndSteps
{
    
    NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
    
    //get 7 day steps and points array
    NSArray *myWeekeleyPoints = [myStats objectForKey:kMyPointsWeekArray];
    NSArray *myWeekeleySteps = [myStats objectForKey:kMyStepsWeekArray];
    
    //get yesterday's Points & Steps
    NSString *yesterdayPoints = [myWeekeleyPoints objectAtIndex:5];
    NSString *yesterdaySteps = [myWeekeleySteps objectAtIndex:5];
    
    NSString *yesterdaysPointsAndSteps = [NSString stringWithFormat:@"You scored %@ points on %@ steps yesterday.", yesterdayPoints, yesterdaySteps];
    
    
    return yesterdaysPointsAndSteps;
}


#pragma mark - Core Data

-(void)migrateLeaguesToCoreData
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    
    //query Teams class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        
    if(!error)
    {
       
        

        
       //delete all the objects in core data and replace w/ new & updated objects from Parse server
        [self deleteAllObjects:@"Team"];
        [self deleteAllObjects:@"League"];
        
        
        //looping once so that we don't create duplicate object
        for (int i = 0; i < 1; i++) {
            
            
            
            self.allLeaguesTeams = objects;
            
            self.uniqueLeagues = [objects valueForKeyPath:@"@distinctUnionOfObjects.league"];
            
//            NSLog(@"uniqueLeagues: %@", self.uniqueLeagues);
            
//           NSLog(@"allLeaguesTeams: %@", self.allLeaguesTeams);
            
            
            
            //add corresponding teams that match to core data
             for (int i = 0; i < self.uniqueLeagues.count; i++) {
                
                
                
                NSString *LeagueName = [NSString stringWithFormat:@"%@",self.uniqueLeagues[i]];
                 
                PFQuery *queryTeamsClassAgain = [PFQuery queryWithClassName:kTeamTeamsClass];
              
                [queryTeamsClassAgain whereKey:kLeagues equalTo:LeagueName];
                [queryTeamsClassAgain findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 
                    NSMutableArray *teamsInLeague = [[NSMutableArray alloc]init];
                    NSMutableArray *teamObjectsInLeague = [[NSMutableArray alloc]init];
                    NSString *TeamName;
                    NSObject *TeamObject;
                    NSSet* teamsInLeagueSet;
                    NSSet* teamObjectsInLeagueSet;
                    
                    
                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                    League *league = [NSEntityDescription insertNewObjectForEntityForName:@"League" inManagedObjectContext:context];
                    league.league = LeagueName;
                    
                    [context save:&error];
                    
                    if (![context save:&error]) {
                        return;
                    }
                    
                   for(PFObject *myTeam in objects)
                   {
                       TeamName = [NSString stringWithFormat:@"%@",[myTeam objectForKey:kTeams]];
                       TeamObject = [myTeam objectForKey:kTeams];
                       
//                       NSLog(@"League: %@",self.uniqueLeagues[i]);
//                       NSLog(@"TeamName: %@", TeamName);
                       
                       [teamsInLeague addObject:TeamName];
                       [teamObjectsInLeague addObject:TeamObject];
                       
//                       NSSet* mySetWithUniqueItems= [NSSet setWithArray: TeamName];
//                       [league setTeams:TeamName];
                       
                       
                       //set the team name & assign the league to the team
                       NSManagedObjectContext *context = [appDelegate managedObjectContext];
                       Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
                       team.name = TeamName;
                       team.league = LeagueName;
                       
                       //if there is no bool value for on team set it to NO
                       if (team.onteam == nil) {
//                           team.onteam = [NSNumber numberWithBool:YES];
                           [team setOnteam:[NSNumber numberWithBool:NO]];
//                           NSLog(team.onteam ? @"Yes" : @"No");
                       }
                       
                       [context save:&error];
                       
                       if (![context save:&error]) {
                           return;
                       }
                       
//                       NSLog(@"team.name: %@", team.name);
//                       NSLog(@"team.league: %@",team.league);
                   }
                    
                    teamsInLeagueSet= [NSSet setWithArray: teamsInLeague];
                    teamObjectsInLeagueSet= [NSSet setWithArray: teamObjectsInLeague];
//                    NSLog(@"LeageName: %@", LeagueName);
//                    NSLog(@"teamsInLeagueSet: %@",teamsInLeagueSet);
                    

          }];
                
                
                
            }
            
            //If a player is on a team, set the boolean values
            [self onTeam];
            
        }
    
    }
        
        
        
    }];
    
    
}



-(void)onTeam
{
    
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    
    //query Teams class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];

    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    //Query where the current user is a teamate
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (!error) {
            
            
            for (int i = 0; i < objects.count; i++) {
                
                
//                for(PFObject *myTeam in objects)
//            {
                
                
                PFObject *myTeam = objects[i];
                
                NSString * myTeamName = [NSString stringWithFormat:@"%@",[myTeam objectForKey:kTeams]];
                
//                NSLog(@"myTeamName %@", myTeamName);
                
                NSManagedObjectContext * context = [appDelegate managedObjectContext];
                NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entityDesc];
                
                //filter for my teams
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)" , myTeamName];
                [request setPredicate:pred];
                
                //if the player joined the team set the team's boolean to yes
                
                NSError *error;
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *fetchedTeamNames = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
                [request setSortDescriptors:fetchedTeamNames];
                
                Team *team = [[context executeFetchRequest:request error:&error] objectAtIndex:0];
                
                
                //                NSLog(@"teamNameJoinedAtIndex %@", team.name);
                
                //if I am on the team, filp boolean to yes
                team.onteam = [NSNumber numberWithBool:YES];
                [context save:&error];
                
                
                
                
                
                
            }
            
            
            
        }
        
    }];

}


- (void) deleteAllObjects: (NSString *) entityDescription  {
    
    NSError *error;
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    

    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[context deleteObject:managedObject];
//    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
//    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}


@end
