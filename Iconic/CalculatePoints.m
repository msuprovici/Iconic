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
#import "AAPLMotionActivityQuery.h"
#import "AAPLActivityDataManager.h"

@implementation CalculatePoints




#pragma mark Parse methods

- (void) retrieveFromParse {
    
    //set the player's teams in memory
    NSUserDefaults *myRetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    //initialize arrays to store contents from query bellow
    self.arrayOfhomeTeamScores = [[NSMutableArray alloc] init];
    self.arrayOfawayTeamScores = [[NSMutableArray alloc] init];
    
    self.arrayOfhomeTeamNames = [[NSMutableArray alloc] init];
    self.arrayOfMyTeamObjects = [[NSMutableArray alloc] init];
    self.arrayOfhomeTeamRecords = [[NSMutableArray alloc] init];
    
    self.arrayOfawayTeamNames = [[NSMutableArray alloc] init];
    self.arrayOfawayTeamRecords = [[NSMutableArray alloc] init];
    
    self.awayTeamPointers = [[NSMutableArray alloc] init];
    self.homeTeamPointers = [[NSMutableArray alloc] init];
    
    
    self.arrayOfWeekleyHomeTeamScores = [[NSMutableArray alloc] init];
    self.arrayOfWeekleyAwayTeamScores = [[NSMutableArray alloc] init];
    
    
    self.arrayOfTodayHomeTeamScores = [[NSMutableArray alloc] init];
    self.arrayOfTodayAwayTeamScores = [[NSMutableArray alloc] init];
    
    self.leagueArray = [[NSMutableArray alloc] init];

     self.arrayOfRounds = [[NSMutableArray alloc] init];
     self.arrayOfTeamMatchupsObjects = [[NSMutableArray alloc] init];
    self.arrayOfAllTeamMatchupObjects = [[NSMutableArray alloc] init];
    
    self.arrayOfFinalhomeTeamScores = [[NSMutableArray alloc] init];
    self.arrayOfFinalawayTeamScores = [[NSMutableArray alloc] init];

    
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
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
            self.arrayOfTeamRounds = [[NSMutableArray alloc] init];

            
            //check to see if the player is on a team
            if(objects.count > 0)
            {
                
                //                NSLog(@"team class query worked");
                

//                //add teams to defaults
//                [self addTeamsToDefaults];
                
                
                //convert NSArray to myTeamDataArray
                self.myTeamData = [self createMutableArray:objects];
            
                
//                 NSLog(@"my teams: %@",  self.myTeamData);
//                 NSArray *myTeamDataArray = [self.myTeamData copy];
                
                
                for (int i = 0; i < objects.count; i++) {
                    
      
                    
                    PFObject *myTeamObject = objects[i];
                    
//                    [self addTeamsToDefaults: myTeamObject];
                    
                    NSString * myTeamName = [myTeamObject objectForKey:kTeams];
                    
                    self.teamRound = [NSString stringWithFormat:@"%@",[myTeamObject objectForKey:@"round"]];
                    
                    
                    //create an array of my team names
//                    [self.arrayOfMyTeamNames addObject:myTeamName];
                    [self.arrayOfMyTeamNames insertObject:myTeamName atIndex:i];
                    
                    [self.arrayOfTeamRounds insertObject:myTeamName atIndex:i];
//                     NSLog(@"arrayOfMyTeamNames: %@",  self.arrayOfMyTeamNames);
                    

                    //save the array of my team names to nsuserdefaults
                    [myRetrievedTeams setObject:self.arrayOfMyTeamNames  forKey:kArrayOfMyTeamsNames];
                    
//                    NSLog(@"self.arrayOfMyTeamNames: %@", self.arrayOfMyTeamNames);
                    [myRetrievedTeams synchronize];
                    
                    if (i == objects.count -1) {
                        //add teams to defaults
                        [self addTeamsToDefaults];
                        
                        //send a nsnotification when deaults has synchronized
                        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                        [nc postNotificationName:@"DefaultsSync" object:self ];

                    }
                        
                   
                    
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

    
}

//approach that parse support said sql would not do

//-(void)addTeamsToDefaults
//{
//    
//    NSUserDefaults *myRetrievedTeams = [NSUserDefaults standardUserDefaults];
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"TeamName"];
//    
//    
//    
//    PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
//    [teamPlayersClass includeKey:@"playerpointer"];
//    [teamPlayersClass includeKey:@"team"];
//    
//    [teamPlayersClass whereKey:@"playerpointer" equalTo:[PFUser currentUser]];
//    
//    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
//    
//    
//    
//    //Query Team Classes, find the team matchups and save the team scores to memory
//    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//    [queryHomeTeamMatchups whereKey:@"hometeam" matchesQuery:query];
//   
//    
//    
//    
//    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
//    [queryAwayTeamMatchups whereKey:kAwayTeam matchesQuery:query];
//   
//    
//    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups, queryAwayTeamMatchups]];
//    
//    
//    [queryTeamMatchupsClass whereKey:@"currentRound" matchesKey:@"round" inQuery:query];
//    
//    
//    [queryTeamMatchupsClass includeKey:kHomeTeam];
//    [queryTeamMatchupsClass includeKey:kAwayTeam];
//
//    
//
//    [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//    
//        if(!error)
//        {
//            /*set parse data to NSUserdefaults*/
//        
//            
//        for (int i = 0; i < objects.count; i++) {
//            
//            
//        PFObject *myMatchupObject = [objects objectAtIndex:i];
//            
//        //add all objects to a array so that we can send the correct one to the next view controller
//        [self.myMatchups addObject:myMatchupObject];
//        
//        
//        //acces away & home team pointers in parse
//        PFObject* awayTeamPointer = [myMatchupObject objectForKey:kAwayTeam];
//        PFObject* homeTeamPointer = [myMatchupObject objectForKey:kHomeTeam];
//        
//        //add pointers to an array & save to NSUserDefaults
//        [self.awayTeamPointers addObject:awayTeamPointer];
//        [self.homeTeamPointers addObject:homeTeamPointer];
//        
//        
//        //Home Team Scores
//        
//        NSString * homeTeamName = [homeTeamPointer objectForKey:kTeams];
//        NSNumber * homeTeamTotalScore = [homeTeamPointer objectForKey:kScore];
//            
//        NSString * homeTeamRecord = [NSString stringWithFormat:@"%@ - %@",[homeTeamPointer objectForKey:@"wins"],[homeTeamPointer objectForKey:@"losses"]];
//        NSString * awayTeamRecord = [NSString stringWithFormat:@"%@ - %@",[awayTeamPointer objectForKey:@"wins"],[awayTeamPointer objectForKey:@"losses"]];
//            
//        int numberOfTeamsInLeague = [[homeTeamPointer objectForKey:@"numberOfTeamsInLeague"]intValue];
//            
//        //only show records for leagues with more then two teams
//        if(numberOfTeamsInLeague > 2)
//        {
//            self.homeTeamRecord = homeTeamRecord;
//            self.awayTeamRecord = awayTeamRecord;
//        }
//        else
//        {
//            self.homeTeamRecord = @"";
//            self.awayTeamRecord = @"";
//
//        }
//        
//        //add objects to array of teamScores(array) objects so that we don't have to download again
//        [self.arrayOfhomeTeamScores addObject:homeTeamTotalScore];
//        
//        //add objects to array of teamScores(array) objects so that we don't have to download again
//        [self.arrayOfhomeTeamNames addObject:homeTeamName];
//        
//        //add home team records to array
//        [self.arrayOfhomeTeamRecords addObject:self.homeTeamRecord];
//        
//        //aray of arays of daily scores
//        NSMutableArray * arrayOfWeekleyHomeScores = [homeTeamPointer objectForKey: kScoreWeek];
//        //                            NSLog(@"initial arrayOfWeekleyScores in calculate points: %@", arrayOfWeekleyHomeScores);
//        
//        
//        
//        //add all the home team scores for TODAY to an array
//        NSNumber * todaysTotalScore = [homeTeamPointer objectForKey:kScoreToday];
//        //                            NSLog(@"todaysTotalScore in calculate points: %@", todaysTotalScore);
//        [self.arrayOfTodayHomeTeamScores addObject:todaysTotalScore];
//        
//        
//        
//        
//        //array of arrays: add the arrays of weekeley home scores to an array
//        [self.arrayOfWeekleyHomeTeamScores addObject:arrayOfWeekleyHomeScores];
//        //                                NSLog(@"arrayOfTodayHomeTeamScores CP %@", self.arrayOfTodayHomeTeamScores);
//        
//        
//        //create and array of leagues
//        NSString * homeTeamLeague = [homeTeamPointer objectForKey:kLeagues];
//        
//        [self.leagueArray addObject:homeTeamLeague];
//        
//        //save to NSUserdefaults
//        [myRetrievedTeams setObject:self.arrayOfTodayHomeTeamScores  forKey:kArrayOfTodayHomeTeamScores];
//        [myRetrievedTeams setObject:self.arrayOfhomeTeamScores  forKey:kArrayOfHomeTeamScores];
//        [myRetrievedTeams setObject:self.arrayOfhomeTeamRecords  forKey:@"homeTeamRecords"];
//        [myRetrievedTeams setObject:self.arrayOfhomeTeamNames  forKey:kArrayOfHomeTeamNames];
//        [myRetrievedTeams setObject:self.arrayOfWeekleyHomeTeamScores  forKey:kArrayOfWeekleyHomeTeamScores];
//        
//        [myRetrievedTeams setObject:self.leagueArray  forKey:kArrayOfLeagueNames];
//        
//        //                            NSLog(@"array of weekley arrays in calculate points: %@", self.arrayOfWeekleyHomeTeamScores);
//        [myRetrievedTeams synchronize];
//        
//        
//        //Away Team Scores
//        //get awayTeamScores(array)
//        
//        NSString * awayTeamName = [awayTeamPointer objectForKey:kTeams];
//        NSNumber * awayTeamTotalScore = [awayTeamPointer objectForKey:kScore];
//        
//        
//        
//        //add objects to array of teamScores(array) objects so that we don't have to download again
//        [self.arrayOfawayTeamScores addObject:awayTeamTotalScore];
//        
//        
//        //add objects to array of teamScores(array) objects so that we don't have to download again
//        [self.arrayOfawayTeamNames addObject:awayTeamName];
//            
//        //add away team records to array
//        [self.arrayOfawayTeamRecords addObject:self.awayTeamRecord];
//    
//        
//        //array of everyday scores for the week
//        NSMutableArray * arrayOfAwayWeekleyScores = [awayTeamPointer objectForKey: kScoreWeek];
//        //                            NSLog(@"initial arrayOfAwayWeekleyScores in calculate points: %@", arrayOfAwayWeekleyScores);
//        
//        //add all the away team scores for TODAY to an array
//        NSNumber * todaysTotalAwayScore = [awayTeamPointer objectForKey:kScoreToday];
//        
//        [self.arrayOfTodayAwayTeamScores addObject:todaysTotalAwayScore];
//        //                             NSLog(@"arrayOfTodayAwayTeamScores CP %@", self.arrayOfTodayAwayTeamScores);
//        
//        
//        //create an array of arrays of weekley teams scores
//        [self.arrayOfWeekleyAwayTeamScores addObject:arrayOfAwayWeekleyScores];
//        //                            NSLog(@"self.arrayOfWeekleyHomeTeamScores: %@", self.arrayOfWeekleyAwayTeamScores);
//        
//        
//        
//        
//        //save to NSUserdefaults
//        [myRetrievedTeams setObject:self.arrayOfTodayAwayTeamScores  forKey:kArrayOfTodayAwayTeamScores];
//        [myRetrievedTeams setObject:self.arrayOfawayTeamScores  forKey:kArrayOfAwayTeamScores];
//        [myRetrievedTeams setObject:self.arrayOfawayTeamRecords  forKey:@"awayTeamRecords"];
//        [myRetrievedTeams setObject:self.arrayOfawayTeamNames  forKey:kArrayOfAwayTeamNames];
//        [myRetrievedTeams setObject:self.arrayOfWeekleyAwayTeamScores  forKey:kArrayOfWeekleyAwayTeamScores];
//        
//        [myRetrievedTeams synchronize];
//        
//        //this methods shares today's step count with app
//        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
//        
//        [sharedDefaults setObject:self.arrayOfhomeTeamScores forKey:@"widgetArrayOfHomeTeamScores"];
//        [sharedDefaults setObject:self.arrayOfawayTeamScores forKey:@"widgetArrayOfAwayTeamScores"];
//        [sharedDefaults setObject:self.arrayOfhomeTeamRecords  forKey:@"widgetArrayOfHomeTeamRecords"];
//        [sharedDefaults setObject:self.arrayOfawayTeamRecords  forKey:@"widgetArrayOfAwayTeamRecords"];
//        [sharedDefaults setObject:self.arrayOfhomeTeamNames forKey:@"widgetArrayOfHomeTeamNames"];
//        [sharedDefaults setObject:self.arrayOfawayTeamNames forKey:@"widgetArrayOfAwayTeamNames"];
//        [sharedDefaults setObject:self.leagueArray forKey:@"widgetArrayOfLeagueNames"];
//        
////        NSLog(@"awayTeamNamesArray: %@", self.arrayOfawayTeamNames);
////        NSLog(@"homeTeamNamessArray: %@", self.arrayOfhomeTeamNames);
//      
//        
//        [sharedDefaults synchronize];
//        }
//        }
//        else
//        {
//            NSLog(@"querry error: %@", error);
//        }
//        
//    }];
//    
//    
//}


//1. find the teams that I am on
-(void)addTeamsToDefaults
{
    

    //team query
    PFQuery *query = [PFQuery queryWithClassName:@"TeamName"];
    
    
    
    PFQuery *teamPlayersClass = [PFQuery queryWithClassName:kTeamPlayersClass];
    [teamPlayersClass includeKey:@"playerpointer"];
    [teamPlayersClass includeKey:@"team"];
    
    [teamPlayersClass whereKey:@"playerpointer" equalTo:[PFUser currentUser]];
    
    [query whereKey:@"objectId" matchesKey:kTeamObjectIdString inQuery:teamPlayersClass];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
//             NSLog(@"# of teams i'm on: %lu", (unsigned long)objects.count);
       
            for (int i = 0; i < objects.count; i++) {
                PFObject *myTeams = [objects objectAtIndex:i];
                NSNumber *roundNumber = [myTeams objectForKey:@"round"];
//               NSLog(@"roundNumber TeamName: %@", roundNumber);
                
                [self.arrayOfMyTeamObjects addObject:myTeams];
                [self.arrayOfRounds addObject:roundNumber];
//                NSLog(@"arrayOfRounds: %@", self.arrayOfRounds);
               
                if (i == objects.count-1) {

                    [self findTeamMatcups];
                }
                
            }
            
            
         }
        
    }];
    
    
    
}

//2. find all team matchups that include my team
-(void)findTeamMatcups
{
    
//    NSLog(@"self.arrayOfMyTeamObjects: %@", self.arrayOfMyTeamObjects);
    NSArray * myTeamObjects = self.arrayOfMyTeamObjects;
//    NSLog(@"myTeamObjects: %@", myTeamObjects);
    
    //Query Team Classes, find the team matchups and save the team scores to memory
    PFQuery *queryHomeTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    //    [queryHomeTeamMatchups whereKey:@"hometeam" matchesQuery:query];
    [queryHomeTeamMatchups whereKey:@"hometeam" containedIn:myTeamObjects];
    
    PFQuery *queryAwayTeamMatchups = [PFQuery queryWithClassName:kTeamMatchupClass];
    //    [queryAwayTeamMatchups whereKey:kAwayTeam matchesQuery:query];
    [queryAwayTeamMatchups whereKey:@"awayteam" containedIn:myTeamObjects];
    
    PFQuery *queryTeamMatchupsClass = [PFQuery orQueryWithSubqueries:@[queryHomeTeamMatchups, queryAwayTeamMatchups]];

    
    
    
    [queryTeamMatchupsClass includeKey:@"hometeam"];
    [queryTeamMatchupsClass includeKey:@"awayteam"];
    
//    [queryTeamMatchupsClass includeKey:kHomeTeam];
//    [queryTeamMatchupsClass includeKey:kAwayTeam];
    
    [queryTeamMatchupsClass findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            
//            NSLog(@"team matchups: %@", objects);
//            NSLog(@"#of team matchups: %lu", (unsigned long)objects.count);
            
            for (int i = 0; i < objects.count; i++) {
                PFObject *teamMatchups = [objects objectAtIndex:i];

                [self.arrayOfAllTeamMatchupObjects addObject:teamMatchups];
                
                if (i == objects.count-1)
                {
                    [self findMyTeamMatchups];
                }
                
                
            }
        }
    }];
    

}

//3. find the team matchups that my team is playing in which share the same round #
-(void)findMyTeamMatchups
{
    for (int i = 0; i < self.arrayOfRounds.count; i++) {
        
        NSNumber *roundNumberAtIndex = self.arrayOfRounds[i];
        PFObject *myTeam = self.arrayOfMyTeamObjects[i];
        NSString *myTeamName =  [myTeam objectForKey:@"teams"];
//        NSLog(@"teamName %@", myTeamName);
        
        
        for (int j = 0; j < self.arrayOfAllTeamMatchupObjects.count; j++) {
            
            PFObject *teamMatchup = [self.arrayOfAllTeamMatchupObjects objectAtIndex:j];
            PFObject *awayTeam = [teamMatchup objectForKey:@"awayteam"];
            NSString *awayTeamName =  [awayTeam objectForKey:@"teams"];
            PFObject *homeTeam = [teamMatchup objectForKey:@"hometeam"];
            NSString *homeTeamName =  [homeTeam objectForKey:@"teams"];
                                  
            NSNumber *roundNumber = [teamMatchup objectForKey:@"currentRound"];
//            NSLog(@"roundNumber %@", roundNumber);
//            NSLog(@"roundNumberAtIndex %@", roundNumberAtIndex);
//            NSLog(@"myTeamName %@", myTeamName);
            
            if (roundNumberAtIndex == roundNumber && ([myTeamName isEqualToString:awayTeamName] || [myTeamName isEqualToString:homeTeamName])) {
//                NSLog(@"roundNumberAtIndex: %@", roundNumberAtIndex);
//                 NSLog(@"roundNumber retrieved: %@", roundNumber);
                
                [self.arrayOfTeamMatchupsObjects addObject:teamMatchup];
                
                //when the for loop has ended populate nsuserdefualts
                if (i == self.arrayOfRounds.count-1)
                {
//                    NSLog(@"populate defaults");
                    [self populateDefualts];
                  
                }
            }
            
        }
        
    }
    

}

//4. pouplate NSUserDefaults
-(void)populateDefualts
{
    NSUserDefaults *myRetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < self.arrayOfTeamMatchupsObjects.count; i++) {
        
        
        PFObject *myMatchupObject = [self.arrayOfTeamMatchupsObjects objectAtIndex:i];
        
        //add all objects to a array so that we can send the correct one to the next view controller
        [self.myMatchups addObject:myMatchupObject];
        
        
        //acces away & home team pointers in parse
        PFObject* awayTeamPointer = [myMatchupObject objectForKey:kAwayTeam];
        PFObject* homeTeamPointer = [myMatchupObject objectForKey:kHomeTeam];
        
        //add pointers to an array & save to NSUserDefaults
        [self.awayTeamPointers addObject:awayTeamPointer];
        [self.homeTeamPointers addObject:homeTeamPointer];
        
        
        //Home Team Scores
        
        NSString * homeTeamName = [homeTeamPointer objectForKey:kTeams];
        NSNumber * homeTeamTotalScore = [homeTeamPointer objectForKey:kScore];
        NSNumber * homeTeamFinalScore = [homeTeamPointer objectForKey:@"finalScore"];
        
        NSString * homeTeamRecord = [NSString stringWithFormat:@"%@ - %@",[homeTeamPointer objectForKey:@"wins"],[homeTeamPointer objectForKey:@"losses"]];
        NSString * awayTeamRecord = [NSString stringWithFormat:@"%@ - %@",[awayTeamPointer objectForKey:@"wins"],[awayTeamPointer objectForKey:@"losses"]];
        
        int numberOfTeamsInLeague = [[homeTeamPointer objectForKey:@"numberOfTeamsInLeague"]intValue];
        
        //only show records for leagues with more then two teams
        if(numberOfTeamsInLeague > 2)
        {
            self.homeTeamRecord = homeTeamRecord;
            self.awayTeamRecord = awayTeamRecord;
        }
        else
        {
            self.homeTeamRecord = @"";
            self.awayTeamRecord = @"";
            
        }
        
        //add objects to array of teamScores(array) objects so that we don't have to download again
        [self.arrayOfhomeTeamScores addObject:homeTeamTotalScore];
        
        //add objects to array of teamScores(array) objects so that we don't have to download again
        [self.arrayOfhomeTeamNames addObject:homeTeamName];
//        NSLog(@"arrayOfhomeTeamNames in calculate points: %@", self.arrayOfhomeTeamNames);
        
        //add home team records to array
        [self.arrayOfhomeTeamRecords addObject:self.homeTeamRecord];
        
        //add final home team scores to array
        [self.arrayOfFinalhomeTeamScores addObject:homeTeamFinalScore];
        
        
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
        
        
        //create and array of leagues
        NSString * homeTeamLeague = [homeTeamPointer objectForKey:kLeagues];
        
        [self.leagueArray addObject:homeTeamLeague];
        
        //save to NSUserdefaults
        [myRetrievedTeams setObject:self.arrayOfTodayHomeTeamScores  forKey:kArrayOfTodayHomeTeamScores];
        [myRetrievedTeams setObject:self.arrayOfhomeTeamScores  forKey:kArrayOfHomeTeamScores];
        [myRetrievedTeams setObject:self.arrayOfhomeTeamRecords  forKey:@"homeTeamRecords"];
        [myRetrievedTeams setObject:self.arrayOfhomeTeamNames  forKey:kArrayOfHomeTeamNames];
        [myRetrievedTeams setObject:self.arrayOfWeekleyHomeTeamScores  forKey:kArrayOfWeekleyHomeTeamScores];
        [myRetrievedTeams setObject:self.arrayOfFinalhomeTeamScores forKey:@"FinalHomeTeamScores"];
        
        [myRetrievedTeams setObject:self.leagueArray  forKey:kArrayOfLeagueNames];
        
        //                            NSLog(@"array of weekley arrays in calculate points: %@", self.arrayOfWeekleyHomeTeamScores);
        [myRetrievedTeams synchronize];
        
        
        //Away Team Scores
        //get awayTeamScores(array)
        
        NSString * awayTeamName = [awayTeamPointer objectForKey:kTeams];
        NSNumber * awayTeamTotalScore = [awayTeamPointer objectForKey:kScore];
        NSNumber * awayTeamFinalScore = [awayTeamPointer objectForKey:@"finalScore"];
        
        
        
        //add objects to array of teamScores(array) objects so that we don't have to download again
        [self.arrayOfawayTeamScores addObject:awayTeamTotalScore];
        
        
        //add objects to array of teamScores(array) objects so that we don't have to download again
        [self.arrayOfawayTeamNames addObject:awayTeamName];
//        NSLog(@"arrayOfawayTeamNames in calculate points: %@", self.arrayOfawayTeamNames);
        
        //add away team records to array
        [self.arrayOfawayTeamRecords addObject:self.awayTeamRecord];
        
        //add final home team scores to array
        [self.arrayOfFinalawayTeamScores addObject:awayTeamFinalScore];
        
        
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
        [myRetrievedTeams setObject:self.arrayOfawayTeamRecords  forKey:@"awayTeamRecords"];
        [myRetrievedTeams setObject:self.arrayOfawayTeamNames  forKey:kArrayOfAwayTeamNames];
        [myRetrievedTeams setObject:self.arrayOfWeekleyAwayTeamScores  forKey:kArrayOfWeekleyAwayTeamScores];
        [myRetrievedTeams setObject:self.arrayOfFinalawayTeamScores forKey:@"FinalAwayTeamScores"];
        
        [myRetrievedTeams synchronize];
        
        //this methods shares today's step count with app
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
        
        [sharedDefaults setObject:self.arrayOfhomeTeamScores forKey:@"widgetArrayOfHomeTeamScores"];
        [sharedDefaults setObject:self.arrayOfawayTeamScores forKey:@"widgetArrayOfAwayTeamScores"];
        [sharedDefaults setObject:self.arrayOfhomeTeamRecords  forKey:@"widgetArrayOfHomeTeamRecords"];
        [sharedDefaults setObject:self.arrayOfawayTeamRecords  forKey:@"widgetArrayOfAwayTeamRecords"];
        [sharedDefaults setObject:self.arrayOfhomeTeamNames forKey:@"widgetArrayOfHomeTeamNames"];
        [sharedDefaults setObject:self.arrayOfawayTeamNames forKey:@"widgetArrayOfAwayTeamNames"];
        [sharedDefaults setObject:self.leagueArray forKey:@"widgetArrayOfLeagueNames"];
        
//        NSLog(@"awayTeamNamesArray: %@", self.arrayOfawayTeamNames);
//        NSLog(@"homeTeamNamessArray: %@", self.arrayOfhomeTeamNames);
        
        
        [sharedDefaults synchronize];
        
        
//        //send a nsnotification when deaults has synchronized
//        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
//        [nc postNotificationName:@"DefaultsSync" object:self ];
    }

}


-(void)saveFinalTeamScoresToDefaults
{
    NSUserDefaults *myRetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [myRetrievedTeams objectForKey:@"FinalHomeTeamScores"];
    NSArray *awayTeamScores = [myRetrievedTeams objectForKey:@"FinalAwayTeamScores"];
    
    NSArray *homeTeamNames = [myRetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [myRetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    NSArray *arrayOfLeagueNames = [myRetrievedTeams objectForKey:kArrayOfLeagueNames];
    
    
    [myRetrievedTeams setObject:homeTeamScores  forKey:@"arrayOfFinalHomeTeamScoresWeek"];
    [myRetrievedTeams setObject:awayTeamScores  forKey:@"arrayOfFinalAwayTeamScoresWeek"];
    
    [myRetrievedTeams setObject:homeTeamNames  forKey:@"arrayOfFinalHomeTeamNamesWeek"];
    [myRetrievedTeams setObject:awayTeamNames  forKey:@"arrayOfFinalAwayTeamNamesWeek"];
    
    [myRetrievedTeams setObject:arrayOfLeagueNames  forKey:@"arrayOfFinalLeagueNamesWeek"];
    
    [myRetrievedTeams synchronize];

    
}



- (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}


#pragma mark Steps calcuations


//7 days steps

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}

-(void)findPastWeekleySteps {
    
//    NSLog(@"find Past Weekely Stpes");
    
    _objects = [[NSMutableArray alloc] init];
    _stepsArray = [[NSMutableArray alloc] init];
    
    
    
    _activityDataManager = [[AAPLActivityDataManager alloc] init];
    
    
    if (!_dataManager) {
        _dataManager = [[AAPLActivityDataManager alloc] init];
    }
    if ([AAPLActivityDataManager checkAvailability]) {
        [_dataManager checkAuthorization:^(BOOL authorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (authorized) {
                    NSDate *date = [NSDate date];
                    [_objects removeAllObjects];
                    for (int i = 0; i < 7; ++i){
                        AAPLMotionActivityQuery *query = [AAPLMotionActivityQuery queryStartingFromDate:date offsetByDay:-i];
                        [_objects addObject:query];
                        if(i == 6)
                        {
                            for (int i = 0; i < _objects.count; i++) {
                                
                                NSDate * date = _objects[i];
                                
                                
                                _currentSteps = 0;
                                [_activityDataManager stopStepUpdates];
                                [_activityDataManager stopMotionUpdates];
                                
                                
                                [_activityDataManager queryAsync:(AAPLMotionActivityQuery *)date withCompletionHandler:^{
                                    
                                    if ([(AAPLMotionActivityQuery *)date isToday]) {
                                        [_activityDataManager startStepUpdates:^(NSNumber *stepCount) {
                                            _currentSteps = [stepCount integerValue];
                                            
                                            
                                        }];
                                        
                                    }
                                    
                                    
                                    NSInteger myDaysSteps = [_activityDataManager.stepCounts longValue] + _currentSteps;
                                    
                                    
                                    [_stepsArray addObject:@(myDaysSteps)];
                                    
                                    //find 7 day steps
                                    if(_stepsArray.count == 7)
                                    {
//                                        NSLog(@"myWeekleySteps: %@", _stepsArray);
                                        
                                        NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
                                        [myStats setObject:_stepsArray forKey:kMyStepsWeekArray];
                                        //                                    [myStats synchronize];
                                        
                                        //calcualte avg steps/day
                                        NSNumber * totalWeekleySteps = [_stepsArray valueForKeyPath:@"@sum.self"];
                                        //                                     NSLog(@"totalWeekleySteps: %@", totalWeekleySteps);
                                        int intTotalWeekleySteps = [totalWeekleySteps intValue];
                                        
                                        int intAverageDailySteps = intTotalWeekleySteps / 7;
                                        NSNumber * averageDailySteps = [NSNumber numberWithInt:intAverageDailySteps];
                                        //                                    NSLog(@"averageDailySteps: %@", averageDailySteps);
                                        
                                        //save the past 7 days worth of steps & points to Parse
                                        PFObject *playerStats = [PFUser currentUser];
                                        [playerStats setObject:[[_stepsArray reverseObjectEnumerator] allObjects] forKey:kPlayerStepsWeek];//need to reverse the array to save today's steps last
                                        //                                    [playerStats setObject:myWeekleyPoints forKey:kPlayerPointsWeek];
                                        [playerStats setObject:averageDailySteps forKey:kPlayerAvgDailySteps];
                                        [playerStats saveInBackground];
                                        
//                                        //the 1st value in array is today's step count
//                                        [self incrementPlayerPointsInBackground:(long)[[_stepsArray objectAtIndex:0] integerValue]];
////                                        NSLog(@"[_stepsArray objectAtIndex:0]: %ld", (long)[[_stepsArray objectAtIndex:0] integerValue]);
                                        
                                    }
                                    
                                    
                                    
                                }];
                                
                                
                                
                            }
                        }
                        
                    }
               
                    
                    //Get today's teps
                    
                    self.from = [self beginningOfDay];
                    self.now = [NSDate date];
                    _pedometer = [[CMPedometer alloc] init];
                    
                    [_pedometer queryPedometerDataFromDate:self.from toDate:self.now withHandler:^(CMPedometerData *pedometerData, NSError *error) {
                        if (error) {
                            
                             NSLog(@"step count error: %@", error);
                        } else {
                            
//                             NSLog(@"pedometer query");
                            
                            [self incrementPlayerPointsInBackground:[pedometerData.numberOfSteps integerValue]];
                           
                        }
                    }];
                    
                    

                    
                } else {
                    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"M7 not authorized"
                    //                                                                    message:@"Please enable Motion Activity for this application." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    //                    [alert show];
                }
            });
            // We only need the data manager to check for authorization.
            _dataManager = nil;
        }];
        
    } else {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"M7 not available"
        //                                                        message:@"No activity or step counting is available" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        //        [alert show];
    }
    
    
    
}



//we are replacing points with steps as per new design


-(void)incrementPlayerPointsInBackground: (NSInteger)numberOfSteps
{
    
//        NSLog(@"Increment my player points in Background");
    
        
        //convert steps to points
        //check for NAN values
        
        //this methods shares today's step count with widget
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
        
        [sharedDefaults setInteger:numberOfSteps forKey:@"totalNumberStepsToday"];
        [sharedDefaults synchronize];
    
    

//        if(numberOfSteps == 0)
//        {
////            NSLog(@"number of steps == 0");
//            
//            self.mySteps = [NSNumber numberWithInteger: 0];
////            NSLog(@"self.mySteps: %@", self.mySteps);
//            
//            
//        }
//        else
//        {
//         
//            self.mySteps = [NSNumber numberWithInteger:numberOfSteps];
////            NSLog(@"self.mySteps: %@", self.mySteps);
//            
//        }
    
        
        
         //set the player's total points in memory//set the player's total points in memory

        NSUserDefaults *myRetrievedPoints = [NSUserDefaults standardUserDefaults];
//        [myRetrievedPoints synchronize];
        
        
        
        //to prevent null values check if # of steps is 0
        if(numberOfSteps == 0)
        {

            [myRetrievedPoints setInteger:0   forKey:kMyFetchedStepsToday];
            
            [myRetrievedPoints synchronize];
            
            self.myStepsDeltaValue = 0;
            
            
            //save the player's points for today to the server
            PFObject *playerPoints = [PFUser currentUser];
            NSNumber *myPointsConverted = [NSNumber numberWithInt:0];
            [playerPoints setObject:myPointsConverted forKey:kPlayerPointsToday];
            
            [playerPoints setObject:myPointsConverted forKey:@"deltaSteps"];

            [playerPoints saveInBackground];
            
//            [self incrementMyTeamsPointsInBackground:0];
 
        }
        
        else
        {
//            NSLog(@"numberOfSteps::: %ld", (long)numberOfSteps);
            [self incrementMySteps: numberOfSteps];
        }
    
    
}




-(void)incrementMySteps: (NSInteger)numberOfSteps
{
//    NSLog(@"Increment my steps");
    //set the player's total steps in memory
    NSUserDefaults *myRetrievedSteps = [NSUserDefaults standardUserDefaults];
    
    
    
    int myStoredSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsToday];
//    NSLog(@"myStoredSteps: %d", myStoredSteps);
    int myMostRecentStepsValue = (int)numberOfSteps;
//    NSLog(@"myMostRecentStepsValue: %d", myMostRecentStepsValue);
    
//    int myMostRecentStepsValue = [self.mySteps intValue];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    BOOL  appWasTerminated = [defaults boolForKey:kAppWasTerminated];
    
    NSDate *dateAppWasLastRan = [defaults objectForKey:kDateAppLastRan];
    NSDate *todaysDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone * timezone = [NSTimeZone timeZoneWithName: @"PST"];
    [dateFormatter setTimeZone:timezone];
    
    
    
    NSString * todaysDay = [dateFormatter stringFromDate:todaysDate];
    NSString * dayAppWasLastActivated = [dateFormatter stringFromDate:dateAppWasLastRan];

//     NSLog(@"self.mySteps: %@", self.mySteps);
    
//    NSLog(@"todaysDay: %@", todaysDay);
//    NSLog(@"dayAppWasLastActivated: %@", dayAppWasLastActivated);
//    NSLog(@"todaysDate: %@", todaysDate);
//    NSLog(@"dateAppWasLastRan: %@", dateAppWasLastRan);
    
//   NSLog(@"myStoredSteps: %d", myStoredSteps);

    if([todaysDay isEqualToString:dayAppWasLastActivated])
    {
        self.myStepsDeltaValue = myMostRecentStepsValue - myStoredSteps;
//         NSLog(@"self.myStepsDeltaValue app opened today: %d", self.myStepsDeltaValue);
    }
    else
    {
        self.myStepsDeltaValue = myMostRecentStepsValue;
//        NSLog(@"self.myStepsDeltaValue app NOT opened today: %d", self.myStepsDeltaValue);
    }

    
    
//                                    NSLog(@"myFetchedStoredSteps: %d", myStoredSteps);
//                                    NSLog(@"myFetchedMostRecentStepsValue: %d", myMostRecentStepsValue);
//                                    NSLog(@"myFetchedStepsDeltaValue: %d", self.myStepsDeltaValue);
    
    
//    [myRetrievedSteps setInteger:[self.mySteps intValue] forKey:kMyFetchedStepsToday];
    
//    [myRetrievedSteps setInteger:numberOfSteps forKey:kMyFetchedStepsToday];
//    
//    [myRetrievedSteps synchronize];
    //increment a player's total # of points
    
    int myTotalSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsTotal];
    
    
//    int myFetchedSteps = (int)[myRetrievedSteps integerForKey:kMyFetchedStepsToday];
//    NSLog(@"myFetchedSteps: %d", myFetchedSteps);
    
    int myNewTotalSteps = myTotalSteps + self.myStepsDeltaValue;
    
//    
//                       NSLog(@"myFetchedTotalSteps: %d", myTotalSteps);
//                        NSLog(@"myFetchedNewTotalSteps: %d", myNewTotalSteps);
    
//    [myRetrievedSteps setInteger:myNewTotalSteps  forKey:kMyFetchedStepsTotal];
//    [myRetrievedSteps synchronize];
    
    
//    //save the player's steps for today to the server
//    PFObject *playerSteps = [PFUser currentUser];
//    NSNumber *mySteps = [NSNumber numberWithInteger:numberOfSteps];//converting nsinteger to nsnumber
//    [playerSteps setObject:mySteps forKey:kPlayerPointsToday];
//    //            [playerPoints saveEventually];
//  
//    [playerSteps saveInBackground];
    
    
    /*testing player activity class for feed*/
    
//    PFObject *playerActivity = [PFObject objectWithClassName:@"Activity"];
//    [playerActivity setObject:[PFUser currentUser] forKey:@"user"];
//    [playerActivity setObject: self.mySteps forKey:@"activity"];
//    [playerActivity saveInBackground];

    
    NSNumber *myLevel = [self calculateLevel:myNewTotalSteps];
//     NSLog(@"myNewTotalSteps %d",myNewTotalSteps);
//    NSLog(@"myLevel %@",myLevel);

    //save to NSuserdefaults
    [myRetrievedSteps setInteger:[myLevel intValue]  forKey:@"myLevel"];
    
    float myLevelValue = [myLevel floatValue];
    [myRetrievedSteps synchronize];
    
    //get the total points necessary for next level
    
    NSNumber *totalStepsToNextLevel = [self calculatePointsToReachNextLevel:myLevelValue];
    
    int myTotalStepsToNextLevelValue = [totalStepsToNextLevel intValue];
    
    
    int stepsToNextLevelDelta = myTotalStepsToNextLevelValue - myNewTotalSteps;
    //                          NSLog(@"pointsToNextLevelDelta: %d", pointsToNextLevelDelta);
    
    //calculate the # of points necessary to reach the next level
    NSNumber* myStepsToNextLevelDelta = [NSNumber numberWithInt:stepsToNextLevelDelta];
    
    //convert delta to NSNumber so we can increment later
    NSNumber* myNSStepsDeltaValue = [NSNumber numberWithInt:self.myStepsDeltaValue];
   
    
    //increment the points for all my teams
//    [self incrementMyTeamsPointsInBackground:myNSStepsDeltaValue];
    
//    NSLog(@"myNSStepsDeltaValue %@", myNSStepsDeltaValue);
    
    
//    [PFCloud callFunctionInBackground:@"updateMyTeamScores" withParameters:@{ @"delta": myNSStepsDeltaValue } block:^(id object, NSError *error) {
//        
//        if (!error) {
//            NSLog(@"updateMyTeamScores cloud function worked");
//            
//            [myRetrievedSteps setInteger:numberOfSteps forKey:kMyFetchedStepsToday];
//            [myRetrievedSteps setInteger:myNewTotalSteps  forKey:kMyFetchedStepsTotal];
//            
//            
//            [myRetrievedSteps synchronize];
//
//            
//        }
//        else
//        {
//            NSLog(@"updateMyTeamScores cloud function error %@", error);
//        }
//        
//    }];
    

    
    if(self.myStepsDeltaValue > 0)
        
    {
        
    
        //save the player's steps for today to the server
        PFObject *user = [PFUser currentUser];
        
        NSNumber *mySteps = [NSNumber numberWithInteger:numberOfSteps];//converting nsinteger to nsnumber
        [user setObject:mySteps forKey:kPlayerPointsToday];
        
        
       
        //retrieve current streak from parse
        int streak = [[user objectForKey:@"streak"] intValue];
        //shares today's step count with widget
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
        [sharedDefaults setInteger:streak  forKey:@"streak"];
        [sharedDefaults synchronize];
        
        
        [user incrementKey:kPlayerPoints byAmount:myNSStepsDeltaValue];
        [user setObject:myNSStepsDeltaValue forKey:@"deltaSteps"];
        
        //set player's level
        //            NSLog(@"myLevel sent to parse %@",myLevel);
        [user setObject:myLevel forKey:kPlayerXP];
        
        
        
        //save #points needed to reach the next level
        
        [user setObject:myStepsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
        
        
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                //                            NSLog(@"Player stats save succeded");
                
                //add my steps to each one of my teams
                [PFCloud callFunctionInBackground:@"updateMyTeamScores" withParameters:@{ @"delta": myNSStepsDeltaValue } block:^(id object, NSError *error) {
                    
                    if (!error) {
                        NSLog(@"updateMyTeamScores cloud function worked");
                        
                        
                        [myRetrievedSteps setInteger:numberOfSteps forKey:kMyFetchedStepsToday];
                        [myRetrievedSteps setInteger:myNewTotalSteps  forKey:kMyFetchedStepsTotal];
                        [myRetrievedSteps synchronize];
                        
                        //populate my teams in memory
                        [self retrieveFromParse];
                    }
                    else
                    {
                        NSLog(@"updateMyTeamScores cloud function error %@", error);
                    }
                    
                }];
            }
            else{
                 NSLog(@"Player stats save failed %@", error);
            }

            
            
            
        }];

    }
    
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
//    
//    
//    
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        
//        if(!error)
//        {
//            //retrieve current streak from parse
//            int streak = [[object objectForKey:@"streak"] intValue];
//            //shares today's step count with widget
//            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stickyplay.iconic"];
//            [sharedDefaults setInteger:streak  forKey:@"streak"];
//            [sharedDefaults synchronize];
//
//            
//            [object incrementKey:kPlayerPoints byAmount:myNSStepsDeltaValue];
//            [object setObject:myNSStepsDeltaValue forKey:@"deltaSteps"];
//            
//            //set player's level
////            NSLog(@"myLevel sent to parse %@",myLevel);
//            [object setObject:myLevel forKey:kPlayerXP];
//           
//            
//            
//            //save #points needed to reach the next level
//            
//            [object setObject:myStepsToNextLevelDelta forKey:kPlayerPointsToNextLevel];
//            //save the player's points for today to the server
//          
//            
//            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    //                            NSLog(@"Player stats save succeded");
//                    
//                    [PFCloud callFunctionInBackground:@"updateMyTeamScores" withParameters:@{ @"delta": myNSStepsDeltaValue } block:^(id object, NSError *error) {
//                        
//                        if (!error) {
//                            NSLog(@"updateMyTeamScores cloud function worked");
//                            
//                            [myRetrievedSteps setInteger:numberOfSteps forKey:kMyFetchedStepsToday];
//                            [myRetrievedSteps setInteger:myNewTotalSteps  forKey:kMyFetchedStepsTotal];
//                            
//                            
//                            [myRetrievedSteps synchronize];
//                            
//                            
//                        }
//                        else
//                        {
//                            NSLog(@"updateMyTeamScores cloud function error %@", error);
//                        }
//                        
//                    }];
//                }
//                else{
//                    //                            NSLog(@"Player stats save failed");
//                }
//            }];
//            
//            
//            
//        }
//        
//        
//    }];
    
}


-(void)incrementMyTeamsPointsInBackground:(NSNumber*)delta
{
//    NSLog(@"Increment my teams points in Background");
    //Query Team Class
    PFQuery *query = [PFQuery queryWithClassName:kTeamTeamsClass];
    
    //Query Teamates Class
    PFQuery *query2 = [PFQuery queryWithClassName:kTeamPlayersClass];
    
    //force the queries to be network only
//    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    //had to set the cahce policy to kPFCachePolicyNetworkElseCache
    //kPFCachePolicyCacheThenNetwork ran the query bellow 2x and dobled kScore & kScoreToday
    
//    query.cachePolicy = kPFCachePolicyNetworkElseCache;
//    query2.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    //using network only to
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    query2.cachePolicy = kPFCachePolicyNetworkOnly;
    
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
//                NSLog(@"delta to increment team score: %@", delta);
            
               for( int i = 0; i < objects.count; i++)
               {
                   
                    PFObject *myTeams = [objects objectAtIndex:i];
                   
                    //increment the team's TOTAL points
                    [myTeams incrementKey:kScore byAmount:delta];
//                    NSLog(@"delta %@", delta);
                   
                    //increment the team's points for today
                    [myTeams incrementKey:kScoreToday byAmount:delta];
//                NSLog(@"delta in query %@", delta);
                    //                    [object save];
//                    [object saveInBackground];
//                                        [myTeams saveEventually];
                
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
    float number = points/1000;
    float power = 1.0/3.0;
//    NSLog(@"number %f",number);
    
    NSNumber * level = [NSNumber numberWithFloat:floor(powf(number, power))];
//    NSLog(@"level %@",level);
    
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
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level+1, 3)*1000))];
//    NSLog(@"points to next level %@",points);
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
    NSNumber * points = [NSNumber numberWithFloat: floor((pow(level, 3)*1000))];
    
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
    //1st cancel previous notificaitons
    
    //see loggic in scheduleWeekleyFinalScoresLocalNotification:(NSString*)notificationBody
    //if [defaults boolForKey:@"hasRunAppThisWeekKey"] == NO we cancel all notifications in the method above. Otherwise cancel them here.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"hasRunAppThisWeekKey"] == YES)
    {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    
    
    //then re-create & schedule the notifcation
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
//    //sechedule for tomorrow
//    components.day = 1;
    
    //set time for 10am
    [components setHour:10];
    [components setMinute:0];
    [components setSecond:0];
    
    
    //1st cancel previous notificaitons
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
//    /*Must use different date tell local notifications appar*/
//    //find scheduled local notifications that were scheduled for the time above
//    UIApplication *app = [UIApplication sharedApplication];
//	NSArray *localNotificationsArray = [app scheduledLocalNotifications];
//    
//    
//    for (int i=0; i<[localNotificationsArray count]; i++) {
//        
//        UILocalNotification* scheduledLocalNotification = [localNotificationsArray objectAtIndex:i];
//		NSDictionary *userInfoCurrent = scheduledLocalNotification.userInfo;
//		NSDate *dateCurrent = [userInfoCurrent valueForKey:@"date"];
//        
//        if(dateCurrent == [cal dateFromComponents:components])
//        {
//            [app cancelLocalNotification:scheduledLocalNotification];
//        }
//    }
    
    //Alert Body

    //create local notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    
    if (localNotification)
    {
     
        
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
    
        
         NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
       
        
        int yesterdaysSteps = (int)[myStats integerForKey: @"myFinalStepsForTheDay"];
        
        //get 7 day steps
//        NSArray *myWeekeleySteps = [myStats objectForKey:kMyStepsWeekArray];
        
        //get yesterday's Steps
        
    //create an NSDictionarry with the date & time to indentify this notification later
         /*Must use different date tell local notifications appar*/
    localNotification.userInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[cal dateFromComponents:components],nil] forKeys:[NSArray arrayWithObjects: @"date",nil]];
        
    localNotification.alertBody = [NSString stringWithFormat:@"You scored %d steps for your team yesterday.",yesterdaysSteps];
    
//    [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:self.matchupsIndex]];
    
    
    //used in UIAlert button or 'slide to unlock...' slider in place of unlock
    localNotification.alertAction = @"Summary";

    //increase badge number
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    //schedule the local notfication
        
        
        
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
        
        
    }
}




 -(void)createFinalTeamScoresNotificationBody
{
    
//    NSLog(@"createFinalTeamScoresNotificationBody");
    self.finalScoresStringsArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:@"arrayOfFinalHomeTeamScoresWeek"];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:@"arrayOfFinalAwayTeamScoresWeek"];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:@"arrayOfFinalHomeTeamNamesWeek"];
//    NSLog(@"homeTeamNames: %@",  homeTeamNames);
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:@"arrayOfFinalAwayTeamNamesWeek"];
//    NSLog(@"awayTeamNames: %@",  awayTeamNames);
    
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:@"arrayOfFinalLeagueNamesWeek"];
    
    
   
    
    
    for (int i = 0; i < arrayOfLeagueNames.count; i++)
    {
        //                 NSLog(@"pfobjects: %@",  object);
        //                for (int i = 0; i < myTeamsNames.count; i++) {
        
        
        //set team names
        NSString * homeTeamName = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:i]];
        
        
        NSString * awayTeamName = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:i]];
        
        
        
        //set league names
      
        
        //set score
        NSString * homeTeamScore = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:i]];
        
        NSString * awayTeamScore = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:i]];
        
        
        NSString *finalScoreSummaryString= [NSString stringWithFormat:@"%@ %@ - %@ %@",homeTeamName,homeTeamScore,awayTeamName,awayTeamScore];
        
        
        
        //add the string finalScoresStringsArray
        [self.finalScoresStringsArray addObject:finalScoreSummaryString];
//                         NSLog(@"self.finalScoresStringsArray: %@",  self.finalScoresStringsArray);
        
        
        //create local notification text from finalScoresStringsArray
        NSString * finalScoresNotificationText = [[self.finalScoresStringsArray valueForKey:@"description"] componentsJoinedByString:@"; "];
        //                NSLog(@"finalScoresNotificationText: %@",  finalScoresNotificationText);
        NSString * notificationBeginningText = @"Final:";
        
        NSString *notificationBody = [NSString stringWithFormat:@"%@ %@", notificationBeginningText, finalScoresNotificationText];
//                        NSLog(@"notificationBody: %@",  notificationBody);
//                       [self scheduleWeekleyFinalScoresLocalNotification: notificationBody];
        
        [self scheduleWeekleyFinalScoresLocalNotification: notificationBody];
        
    }
}


-(NSString*)scheduleWeekleyFinalScoresLocalNotification:(NSString*)notificationBody
{
    //    //create notification body
    //    [self createFinalTeamScoresNotificationBody];
    
    
    //then re-create & schedule the notifcation
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    
    
    

    
    //send notificaiton at 11:59pm
    [components setHour:11];
    [components setMinute:59];
    [components setSecond:0];
    

  
    //1st cancel previous notificaitons
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
   
    //Alert Body
    
    //create local notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    
    if (localNotification)
    {
        
        //set time
//        localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        localNotification.fireDate = [cal dateFromComponents:components];
        
        //repeate daily
        localNotification.repeatInterval = 0;//0 means don't repepat
        
//        localNotification.soundName = UILocalNotificationDefaultSoundName;
       
        
        //create an NSDictionarry with the date & time to indentify this notification
         /*Must use different date tell local notifications appear*/
        localNotification.userInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[cal dateFromComponents:components],nil] forKeys:[NSArray arrayWithObjects: @"date",nil]];

        
//        NSLog(@"notificationBody: %@",   notificationBody);
        
        
        localNotification.alertBody = notificationBody;
        
        
        //used in UIAlert button or 'slide to unlock...' slider in place of unlock
        localNotification.alertAction = @"Final Scores";
        
        //increase badge number
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        
        
        //if the user has not opened the app this week...
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"hasRunAppThisWeekKey"] == NO)
        {
            //schedule the local notfication
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            //reschedule the DailySummary Notification
//            [self scheduleDailySummaryLocalNotification];
        }
        
    }
    
    return notificationBody;
}


//-(void)getYesterdaysPointsAndSteps
//{
//
//    NSUserDefaults *myStats = [NSUserDefaults standardUserDefaults];
//
//    //get 7 day steps
//    NSArray *myWeekeleySteps = [myStats objectForKey:kMyStepsWeekArray];
//
//    //get yesterday's Steps
//
//    NSString *yesterdaySteps = [NSString stringWithFormat:@"You scored %@ steps yesterday.",[myWeekeleySteps objectAtIndex:5]];
//
//   // NSString *yesterdaysPointsAndSteps = [NSString stringWithFormat:@"You scored %@ steps yesterday.", yesterdaySteps];
//    
//    [myStats setObject:yesterdaySteps forKey:@"yesterdayPointsAndStepsNotificationText"];
//    [myStats synchronize];
//    
//  }


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
//            self.uniqueLeaguesLevel = [objects valueForKeyPath:@"@distinctUnionOfObjects.leagueLevel"];
            
            
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
//                    league.level = self.uniqueLeaguesLevel[i];
                    
                    [context save:&error];
                    
                    if (![context save:&error]) {
                        return;
                    }
                    
                   for(PFObject *myTeam in objects)
                   {
                       TeamName = [NSString stringWithFormat:@"%@",[myTeam objectForKey:kTeams]];
                       TeamObject = [myTeam objectForKey:kTeams];
                       
//                       NSLog(@"League: %@",self.uniqueLeagues[i]);
//                       NSLog(@"League Level: %@",self.uniqueLeaguesLevel[i]);
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
            /* causing error when 1st time user  leaves all teams*/
//            [self onTeam];
            
            //bandaid fix: delay method by 2 seconds so that we load all the necessary data.
            //crash is taking place at NSArray *fetchedTeamNames on line 1765
//            [self performSelector:@selector(onTeam) withObject:self afterDelay:2.0 ];
            
            [self onTeam];
        }
    
    }
        
        
        
    }];
    
    
}



-(void)onTeam
{
    
    /* !causing error when player leaves all teams! */
    
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
                
                if (objects.count > 0) {
                    
                
                PFObject *myTeam = objects[i];
                
                NSString * myTeamName = [NSString stringWithFormat:@"%@",[myTeam objectForKey:kTeams]];
                
//                NSLog(@"myTeamName %@", myTeamName);
                
                NSManagedObjectContext * context = [appDelegate managedObjectContext];
                NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc]init];
                [request setEntity:entityDesc];
                [request setFetchLimit:1];
                
                //filter for my teams
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)" , myTeamName];
                [request setPredicate:pred];
                
                //if the player joined the team set the team's boolean to yes
                
                NSError *error;
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
                NSArray *fetchedTeamNames = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
                [request setSortDescriptors:fetchedTeamNames];
                
//                Team *team = [[context executeFetchRequest:request error:&error] objectAtIndex:0];
                    
                NSArray *results = [context executeFetchRequest:request error:&error];
                if([results count] > 0)
                {
                Team *team = [results objectAtIndex:0];
                
                    
                
//                NSLog(@"teamNameJoined %@", team.name);
                
                //if I am on the team, filp boolean to yes
                team.onteam = [NSNumber numberWithBool:YES];
                [context save:&error];
                }
                
                }
                
                
                
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



#pragma mark auto-follow users

-(void)autoFollowUsers
{
   
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject * object = [defaults objectForKey:@"autoFollowedUsers"];
    
    
    //1st check if the users were auto-followed
   if(object == nil)
   {
       
    PFQuery *autoFollowAccountsQuery = [PFUser query];
    
    [autoFollowAccountsQuery whereKey:@"username" equalTo:@"JoeDemo"];// auto-follow super so that there is something in the newsfeed for now
    
    [autoFollowAccountsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(PFObject *object in objects)
            {
                
                PFObject *joinActivity = [PFObject objectWithClassName:kPlayerActionClassKey];
                [joinActivity setObject:[PFUser currentUser] forKey:kPlayerActionFromUserKey];
                [joinActivity setObject:object forKey:kPlayerActionToUserKey];
                [joinActivity setObject:kPlayerActionTypeFollow forKey:kPlayerActionTypeKey];
                
                PFACL *joinACL = [PFACL ACL];
                [joinACL setPublicReadAccess:YES];
                joinActivity.ACL = joinACL;
                
                [joinActivity saveInBackground];
                
                [defaults setBool:YES forKey:@"autoFollowedUsers"];
                [defaults synchronize];
            }
            
        }
    }];
       
   }
    
}

#pragma mark Facebook methods

- (void)loadFacebookUserData {
    
//     NSLog(@"loadFacebookData called");
    // ...
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
//            NSLog(@"facebook request received");
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSString *name = userData[@"name"];
//            NSLog(@"name: %@",name);
            
//            NSString *userName = userData[@"username"];
//            NSLog(@"userName: %@",userName);
            
            NSString *email = userData[@"email"];
//            NSLog(@"email: %@",email);
//            NSString *location = userData[@"location"][@"name"];
//            NSString *gender = userData[@"gender"];
//            NSString *birthday = userData[@"birthday"];
//            NSString *relationship = userData[@"relationship_status"];
            
            
            [PFUser currentUser][@"username"] = name;
            [PFUser currentUser][@"email"] = email;
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
//                    NSLog(@"facebook user name: %@ saved to Parse",name);
                }
                else
                {
//                    NSLog(@"facebook user name: %@ NOT saved to Parse",name);
                }
                
            }];
            
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {
                     // Set the image in the header imageView
//                     self.headerImageView.image = [UIImage imageWithData:data];
                     
                     PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:data];
                     [PFUser currentUser][@"photo"] = imageFile;
                     [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                         
                         if (succeeded) {
//                             NSLog(@"facebook profile photo saved to Parse");
                         }
                         else{
//                             NSLog(@"facebook profile photo NOT saved to Parse");
                         }
                     }];
                 }
             }];

        }
        else{
//               NSLog(@"facebook request failed");
        }
    }];
}




@end
