/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

     Provides the data model to access both step counting and activity data.
  
*/

@class AAPLMotionActivityQuery;
@class CMMotionActivity;

typedef NS_ENUM(NSInteger, AAPLActivityType) {
	ActivityTypeWalking,
	ActivityTypeRunning,
	ActivityTypeDriving,
	ActivityTypeMoving,
	ActivityTypeStationary,
	ActivityTypeNone
};

typedef void (^AAPLStepUpdateHandler)(NSNumber *stepCount);
typedef void (^AAPLMotionUpdateHandler)(AAPLActivityType type);
typedef void (^AAPLActivityCompletionHandler)();

@interface AAPLSignificantActivity : NSObject
@property (readonly, nonatomic) NSDate *startDate;
@property (readonly, nonatomic) NSDate *endDate;
@property (copy, nonatomic) NSNumber *stepCounts;
@property (readonly, nonatomic) AAPLActivityType activityType;

- (instancetype)initWithActivity:(AAPLActivityType)type startingFrom:(NSDate *)startDate to:(NSDate *)endDate;
@end

@interface AAPLActivityDataManager : NSObject
+ (BOOL)checkAvailability;
- (void)checkAuthorization:(void (^)(BOOL authorized))authorizationCheckCompletedHandler;

// Properties to access data retrieved from the activity data manager.
@property (readonly, nonatomic) NSTimeInterval walkingDuration;
@property (readonly, nonatomic) NSTimeInterval runningDuration;
@property (readonly, nonatomic) NSTimeInterval vehicularDuration;
@property (readonly, nonatomic) NSTimeInterval movingDuration;
@property (readonly, nonatomic) NSNumber *stepCounts;
@property (readonly, nonatomic) NSArray *significantActivitiesAndSteps;

// Init with query
- (instancetype)init;
- (void)queryAsync:(AAPLMotionActivityQuery *)query withCompletionHandler:(AAPLActivityCompletionHandler)handler;

// Live update functionality
- (void)startStepUpdates:(AAPLStepUpdateHandler)handler;
- (void)stopStepUpdates;

- (void)startMotionUpdates:(AAPLMotionUpdateHandler)handler;
- (void)stopMotionUpdates;

// Some convenience functions
+ (AAPLActivityType)activityToType:(CMMotionActivity *)activity;
+ (NSString *)activityTypeToString:(AAPLActivityType)type;
@end
