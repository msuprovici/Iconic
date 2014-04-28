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


@implementation CalculatePoints


//we use this class to calculate fetched points


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
            
            //check to see if the player is on a team
            if(objects.count > 0)
            {
                
                //                NSLog(@"team class query worked");
                
//                SimpleHomeViewController *simpleViewController = [[SimpleHomeViewController alloc]init];
//                [simpleViewController updateTeamChart:0];

                
                //convert NSArray to myTeamDataArray
                self.myTeamData = [self createMutableArray:objects];
                
                
//                 NSArray *myTeamDataArray = [self.myTeamData copy];
                
                //save to NSUserdefaults
                //[myRetrievedTeams setObject:myTeamDataArray  forKey:kMyTeamDataArray];
                
                
                

            }
            else
            {
//                NSLog(@"the number of teams I am on is 0");
                
                //player is not on a team so set number of teams to 0
                //we use this number in simple viewcontroller to determine state
                NSUserDefaults *Teams = [NSUserDefaults standardUserDefaults];
                [Teams setInteger:0 forKey:kNumberOfTeams];
                [Teams synchronize];

                
            }
            
            
            
            
        }
        else
        {
            
        }
        
        
    }];
    
    //Query Team Class to see if the player's current team is the HOME team
    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryHomeTeamMatchups whereKey:kHomeTeamName matchesKey:kTeams inQuery:query];
    
    
    
    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    [queryAwayTeamMatchups whereKey:kAwayTeamName matchesKey:kTeams inQuery:query];
    
    
    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups,queryAwayTeamMatchups]];
    
    [queryTeamMatchupsClass includeKey:kHomeTeam];
    [queryTeamMatchupsClass includeKey:kAwayTeam];
    
    
    queryAwayTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
    queryHomeTeamMatchups.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
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
                            
//                            SimpleHomeViewController *simpleViewController = [[SimpleHomeViewController alloc]init];
//                            simpleViewController.myMatchups = objects;
                            
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
                            
                            
                            
                            //save to NSUserdefaults
                            [myRetrievedTeams setObject:self.arrayOfhomeTeamScores  forKey:kArrayOfHomeTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfhomeTeamNames  forKey:kArrayOfHomeTeamNames];
                            
                            
                            
                            //Away Team Scores
                            //get awayTeamScores(array) objects
                            
                            NSString * awayTeamName = [awayTeamPointer objectForKey:kTeams];
                            NSNumber * awayTeamTotalScore = [awayTeamPointer objectForKey:kScore];
                            
                            
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfawayTeamScores addObject:awayTeamTotalScore];
                            
                            
                            
                            //add objects to array of teamScores(array) objects so that we don't have to download again
                            [self.arrayOfawayTeamNames addObject:awayTeamName];
                            
                            
                            
                            //save to NSUserdefaults
                            [myRetrievedTeams setObject:self.arrayOfawayTeamScores  forKey:kArrayOfAwayTeamScores];
                            [myRetrievedTeams setObject:self.arrayOfawayTeamNames  forKey:kArrayOfAwayTeamNames];
                            
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
    [myRetrievedTeams synchronize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}


#pragma mark points calcuations


-(void)incrementPlayerPointsInBackground
{
    
    //    NSLog(@"incrementPlayerPoints in calcualte points just got called");
    
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
        
        
        
        //set the player's total points in memory
        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        
        [myRetrievedPoints synchronize];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
            
            [myRetrievedPoints synchronize];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            //save the player's points for today to the server
            PFObject *playerPoints = [PFUser currentUser];
            NSNumber *myPointsConverted = [NSNumber numberWithInt:0];
            [playerPoints setObject:myPointsConverted forKey:kPlayerPointsToday];
            //            [playerPoints save];
            [playerPoints saveInBackground];
            
        }
        
        else
        {
            

            
            
            int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsToday];
            int myMostRecentPointsValue = [self.myPoints intValue];
            int myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
            
//                                NSLog(@"myFetchedStoredPoints: %d", myStoredPoints);
//                                NSLog(@"myFetchedMostRecentPointsValue: %d", myMostRecentPointsValue);
//                                NSLog(@"myFetchedPointsDeltaValue: %d", myPointsDeltaValue);
            
            
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
            
            
            //increment a player's total # of points
            
            int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsTotal];
            [myRetrievedPoints synchronize];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            int myNewTotalPoints = myTotalPoints + myPointsDeltaValue;
            
            
            //                    NSLog(@"myFetchedTotalPoints: %d", myTotalPoints);
            //                    NSLog(@"myFetchedNewTotalPoints: %d", myNewTotalPoints);
            
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
            float myLevelValue = [myLevel floatValue];
            
            //get the total points necessary for next level
            
            NSNumber *totalPointsToNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
            
            int myTotalPointsToNextLevelValue = [totalPointsToNextLevel intValue];
            
            
            int pointsToNextLevelDelta = myTotalPointsToNextLevelValue - myNewTotalPoints;
            //              NSLog(@"pointsToNextLevelDelta: %d", pointsToNextLevelDelta);
            
            //calculate the # of points necessary to reach the next level
            NSNumber* myPointsToNextLevelDelta = [NSNumber numberWithInt:pointsToNextLevelDelta];
            
            //convert delta to NSNumber so we can increment later
            NSNumber* myNSPointsDeltaValue = [NSNumber numberWithInt:myPointsDeltaValue];
            
            
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
        
    }];
    
}



-(void)incrementMyTeamsPointsInBackground:(NSNumber*)delta
{
    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    
    //force the queries to be network only
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query2.cachePolicy = kPFCachePolicyNetworkOnly;
    
    
    [query2 whereKey:kTeamate equalTo:[PFUser currentUser]];
    
    //Query where the current user is a teamate
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:query2];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        if (!error) {
            // The find succeeded.
            //            NSLog(@"Successfully retrieved my %lu teams", (unsigned long)objects.count);
            for (PFObject *object in objects)
                
            {
                //NSLog(@"%@", object.objectId);
                
                
                
                    //increment the team's TOTAL points
                    [object incrementKey:kScore byAmount:delta];
                    
                    //increment the team's points for today
                    [object incrementKey:kScoreToday byAmount:delta];
                    //                    [object save];
                    [object saveInBackground];
                    //                    [object saveEventually];
                
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
//                            NSLog(@"Team stats succesfully saved");
                        }
                        else{
//                            NSLog(@"Team stats failed to save");
                        }
                    }];
            }
            
        }
        else
        {
            //  NSLog(@"error");
        }
        
    }];
    
}




-(NSNumber*)calculatePoints:(float)steps
{
    
    //alogrithm for generating points from steps: yourPoints = ((0.85^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    //Converting float to NSNumber
    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50)];//rounded up to the largest following integer using ceiling function
    
    return points;
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
    return level;
}

-(NSNumber*)calculatePointsToReachNextLevel:(float)level
{
    
    //scale = 1
    //hardcoded for now - will need to send this number down from the server
    //    NSNumber * points = [NSNumber numberWithFloat: ceil((pow(level, 1)*1000))+1]; //rounded up to the largest following integer using ceiling function
    
    
    //had to use the floor to find the round down (map a real number to the largest previous) to the lowest level - calcualtions with ceil were very inacurate.
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level, 1)*1000))+1];
    
    return points;
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


@end
