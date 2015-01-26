//
//  CalculatePoints.h
//  Iconic
//
//  Created by Mike Suprovici on 4/23/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <CoreMotion/CoreMotion.h>

@interface CalculatePoints : NSObject

//step counting
@property (nonatomic, strong) CMStepCounter *cmStepCounter;
@property (nonatomic, strong) CMMotionActivityManager *motionActivity;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableArray *stepsArray;
@property (nonatomic, strong) NSMutableArray *myWeeleyPointsArray;
@property (nonatomic, strong) CMStepCounter *stepCounter;

//arrays
@property (strong, nonatomic) NSMutableArray *myTeamData;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfWeekleyHomeTeamScores;//array of arrays
@property (strong, nonatomic) NSMutableArray * arrayOfWeekleyAwayTeamScores;//array of arrays
@property (strong, nonatomic) NSMutableArray * arrayOfawayTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamNames;
@property (strong, nonatomic) NSMutableArray * arrayOfhomeTeamRecords;
@property (strong, nonatomic) NSMutableArray * arrayOfawayTeamNames;
@property (strong, nonatomic) NSMutableArray * arrayOfawayTeamRecords;
@property (strong, nonatomic) NSMutableArray * arrayOfTeamRounds;
@property (strong, nonatomic) NSMutableArray * leagueArray;

@property (strong, nonatomic) NSMutableArray * homeTeamPointers;
@property (strong, nonatomic) NSMutableArray * awayTeamPointers;
@property (strong, nonatomic) NSMutableArray * myMatchups;
@property (strong, nonatomic) NSMutableArray * homeTeamScores;
@property (strong, nonatomic) NSMutableArray * awayTeamScores;
@property (strong, nonatomic) NSString * homeTeamNames;
@property (strong, nonatomic) NSString * awayTeamNames;
@property (strong, nonatomic) NSNumber * homeTeamTotalScore;
@property (strong, nonatomic) NSNumber * awayTeamTotalScore;

@property (strong, nonatomic) NSString * teamRound;
@property (strong, nonatomic) NSString * homeTeamRecord;
@property (strong, nonatomic) NSString * awayTeamRecord;

@property (strong, nonatomic) NSMutableArray * arrayOfTodayHomeTeamScores;
@property (strong, nonatomic) NSMutableArray * arrayOfTodayAwayTeamScores;


@property (strong, nonatomic) NSMutableArray * arrayOfMyTeamNames;

@property (nonatomic, retain) NSArray *teamMatchups;


@property (strong, nonatomic) NSMutableArray * finalScoresStringsArray;

@property (strong, nonatomic) NSString *myTeamNameString;
@property (strong, nonatomic) NSString *myTeamScoreString;
@property (strong, nonatomic) NSString *vsTeamNameString;
@property (strong, nonatomic) NSString *vsTeamScoreString;

@property (strong, nonatomic) NSString *myTeamNameAndScoreString;
@property (strong, nonatomic) NSString *vsTeamNameAndScoreString;

@property (strong, nonatomic) NSString *notificationBody;

@property int myTeamScoreInt;
@property int vsTeamScoreInt;


+ (id)sharedManager;

//convert steps to points and store here
@property NSNumber* myPoints;
@property NSNumber* mySteps;

//days left in the week
@property int daysLeft;

//player joined their first team
@property int myPointsDeltaValue;
@property int myStepsDeltaValue;

//unique leagues
@property NSArray *uniqueLeagues;
//@property NSArray *uniqueLeaguesLevel;

@property NSArray *allLeaguesTeams;

//methods

-(void)incrementPlayerPointsInBackground;

- (void) retrieveFromParse;

-(NSNumber*)calculatePoints:(float)steps;

-(NSNumber*)calculateLevel:(float)points;

-(NSNumber*)calculatePointsToReachNextLevel:(float)level;

-(NSDate *)beginningOfDay;

-(void)calculateDaysLeftinTheWeek;

-(NSNumber*)calculatePointsToReachCurrentLevel:(float)level;

-(void)scheduleDailySummaryLocalNotification;

-(void)createFinalTeamScoresNotificationBody;
-(void)scheduleWeekleyFinalScoresLocalNotification;

-(void)findPastWeekleySteps;

-(void)migrateLeaguesToCoreData;

-(void)getYesterdaysPointsAndSteps;

-(void)autoFollowUsers;

-(void)loadFacebookUserData;


@end
