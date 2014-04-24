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


//convert steps to points and store here
@property NSNumber* myPoints;
@property NSInteger* mySteps;

//days left in the week
@property int daysLeft;

//methods
-(void)incrementPlayerPoints;


@end
