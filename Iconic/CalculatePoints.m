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



@implementation CalculatePoints


//we use this class to calculate fetched points


-(void)incrementPlayerPoints
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

        }
        
        
        
        //set the player's total points in memory
        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];

            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        else
        {
            
         
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyMostRecentFetchedPointsBeforeSaving];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            int myStoredPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsToday];
            int myMostRecentPointsValue = [self.myPoints intValue];
            int myPointsDeltaValue = myMostRecentPointsValue - myStoredPoints;
            
//                    NSLog(@"myFetchedStoredPoints: %d", myStoredPoints);
//                    NSLog(@"myFetchedMostRecentPointsValue: %d", myMostRecentPointsValue);
//                    NSLog(@"myFetchedPointsDeltaValue: %d", myPointsDeltaValue);
            
            
            [myRetrievedPoints setInteger:[self.myPoints intValue]  forKey:kMyFetchedPointsToday];
            
            
            //increment a player's total # of points
            
            int myTotalPoints = (int)[myRetrievedPoints integerForKey:kMyFetchedPointsTotal];
            
             [[NSUserDefaults standardUserDefaults] synchronize];
            
            int myNewTotalPoints = myTotalPoints + myPointsDeltaValue;

            
//                    NSLog(@"myFetchedTotalPoints: %d", myTotalPoints);
//                    NSLog(@"myFetchedNewTotalPoints: %d", myNewTotalPoints);
            
            [myRetrievedPoints setInteger:myNewTotalPoints  forKey:kMyFetchedPointsTotal];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //save the player's points for today to the server
            PFObject *playerPoints = [PFUser currentUser];
            [playerPoints setObject:self.myPoints forKey:kPlayerPointsToday];
//            [playerPoints saveEventually];
//            [playerPoints saveInBackground];
            
            [playerPoints save]; //<-must execute on main thread in background mode?  saveEventually & saveInBackground do not work
            
            
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
            [self incrementMyTeamsPoints:myNSPointsDeltaValue];
            
            
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
                    [object save];

                    
                                        
                }
                
                
            }];
            
        }
        
    }];
    
}



-(void)incrementMyTeamsPoints:(NSNumber*)delta
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
                
                
                if (!error) {
                    
                    //increment the team's TOTAL points
                    [object incrementKey:kScore byAmount:delta];
                    
                    //increment the team's points for today
                    [object incrementKey:kScoreToday byAmount:delta];
                    [object save];
//                    [object saveInBackground];
//                    [object saveEventually];
                }
                else
                {
//                                        NSLog(@"error in inner query");
                }
            }
            
        }
        else
        {
//                        NSLog(@"error");
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
