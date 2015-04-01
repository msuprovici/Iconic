/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

     Provides the data model to access both step counting and activity data.
  
*/

@import CoreMotion;

#import "AAPLActivityDataManager.h"
#import "AAPLMotionActivityQuery.h"

@implementation AAPLSignificantActivity

- (instancetype)initWithActivity:(AAPLActivityType)type startingFrom:(NSDate *)startDate to:(NSDate *)endDate
{
	self = [super init];
	if (self) {
		_activityType = type;
		_startDate = startDate;
		_endDate = endDate;
		_stepCounts = nil;
		return self;
	}
	return self;
}

@end

@implementation AAPLActivityDataManager
{
	AAPLActivityCompletionHandler _queryCompletionHandler;
	NSMutableArray *_significantActivitiesAndSteps;
	CMPedometer *_pedometer;
	CMMotionActivityManager *_motionActivityMgr;
}

#include "SampleCodeWorkspaceFinished.inc"

- (instancetype)init
{
	self = [super init];
	if (self) {
		_significantActivitiesAndSteps = [[NSMutableArray alloc] init];
		_stepCounts = nil;
		_walkingDuration = 0;
		_runningDuration = 0;
		_vehicularDuration = 0;
		[self _initMotionActivity];
	}
	return self;
}

- (void)reset
{
	_stepCounts = nil;
	_walkingDuration = 0;
	_runningDuration = 0;
	_vehicularDuration = 0;
	[_significantActivitiesAndSteps removeAllObjects];
}

- (NSArray *)significantActivitiesAndSteps
{
	return [_significantActivitiesAndSteps copy];
}

- (void)queryAsync:(AAPLMotionActivityQuery *)query withCompletionHandler:(AAPLActivityCompletionHandler)handler;
{
	[self reset];
	_queryCompletionHandler = handler;
	[self queryHistoricalDataFrom:query.startDate toDate:query.endDate];
}

- (void)_additionalProcessingOn:(NSArray *)activities
{
	[self computeTotalDurations:activities];
	_significantActivitiesAndSteps = [self aggregateSignificantActivities:activities];
}

- (void)computeTotalDurations:(NSArray *)activities
{
	_walkingDuration = 0.;
	_runningDuration = 0.;
	_vehicularDuration = 0.;
	_movingDuration = 0.;
	for (int i = 0; i < activities.count; ++i) {
		if (i == activities.count - 1) {
		  return;
		}
		CMMotionActivity *activity = activities[i];
		CMMotionActivity *nextActivity = activities[i+1];
		NSTimeInterval duration = [nextActivity.startDate timeIntervalSinceDate:activity.startDate];
			if (!activity.unknown && !activity.stationary) {
				_movingDuration += duration;
			}
			if (activity.walking) {
				_walkingDuration += duration;
			} else if (activity.running) {
				_runningDuration += duration;
			} else if (activity.automotive) {
				_vehicularDuration += duration;
			}
	}
}

- (NSMutableArray *)aggregateSignificantActivities:(NSArray *)activities
{
	NSMutableArray *filteredActivities = [[NSMutableArray alloc] init];

	// Skip all contiguous unclassified actiivty so that only one remains.
	for (int i = 0; i < activities.count; ++i) {
		CMMotionActivity *activity = activities[i];
		[filteredActivities addObject:activity];
		if (!activity.walking && !activity.running && !activity.automotive) {
			while (++i < activities.count) {
				CMMotionActivity *skipThisActivity = activities[i];
				if (skipThisActivity.walking || skipThisActivity.running ||
					skipThisActivity.automotive) {
					i = i - 1;
					break;
				}
			}
		}
	}

	// Ignore all low confidence activities.
	for (int i = 0; i < filteredActivities.count;) {
		CMMotionActivity *activity = filteredActivities[i];
		if (activity.confidence == CMMotionActivityConfidenceLow) {
			[filteredActivities removeObjectAtIndex:i];
		} else {
			++i;
		}
	}

	// Skip all unclassified activities if their duration is smaller than
	// some threshold.  This has the effect of coalescing the remaining med + high
	// confidence activies together.
	for (int i = 0; i < (int)filteredActivities.count - 1;){
		CMMotionActivity *activity = filteredActivities[i];
		CMMotionActivity *nextActivity = filteredActivities[i+1];
		NSTimeInterval duration = [nextActivity.startDate timeIntervalSinceDate:activity.startDate];
		if (duration < 60 * 3 && !activity.walking && !activity.running && !activity.automotive) {
			[filteredActivities removeObjectAtIndex:i];
		} else {
			++i;
		}
	}

	// Coalesce activities where they differ only in confidence.
	for (int i = 1; i < filteredActivities.count;) {
		CMMotionActivity *prevActivity = filteredActivities[i-1];
		CMMotionActivity *activity = filteredActivities[i];

		if ((prevActivity.walking && activity.walking) ||
			(prevActivity.running && activity.running) ||
			(prevActivity.automotive && activity.automotive)) {
			[filteredActivities removeObjectAtIndex:i];
		} else {
			++i;
		}
	}

	// Finally transform into SignificantActivity;
	NSMutableArray *sigActivityArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < (int)filteredActivities.count - 1; i++) {
		CMMotionActivity *activity = filteredActivities[i];
		CMMotionActivity *nextActivity = filteredActivities[i+1];
		if (!activity.walking && !activity.running && !activity.automotive){
			continue;
		}

		AAPLSignificantActivity *sigActivity = [[AAPLSignificantActivity alloc]
			initWithActivity:[AAPLActivityDataManager activityToType:activity]
			startingFrom:activity.startDate
			to:nextActivity.startDate];
		[_pedometer queryPedometerDataFromDate:sigActivity.startDate toDate:sigActivity.endDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
			if (error) {
				NSLog(@"Error, unable to retrieve step counts for range %f, %f",
					  [sigActivity.startDate timeIntervalSinceReferenceDate],
					  [sigActivity.endDate timeIntervalSinceReferenceDate]);
			} else {
				sigActivity.stepCounts = pedometerData.numberOfSteps;
			}
		}];
		[sigActivityArray addObject:sigActivity];
	}

	return sigActivityArray;
}

- (void)_handleError:(NSError *)error
{
	if (error.code == CMErrorMotionActivityNotAuthorized) {
		dispatch_async(dispatch_get_main_queue(), ^{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This app is not authorized for M7"
				message:@"No activity or step counting is available" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
			[alert show];
		});
	} else {
		NSLog(@"Error occurred %@", [error description]);
		return;
	}
}

#pragma mark Utility functions

+ (AAPLActivityType)activityToType:(CMMotionActivity *)activity
{
	if (activity.walking) {
		return ActivityTypeWalking;
	} else if (activity.running) {
		return ActivityTypeRunning;
	} else if (activity.automotive) {
		return ActivityTypeDriving;
	} else if (activity.stationary) {
		return ActivityTypeStationary;
	} else if (!activity.unknown) {
		return ActivityTypeMoving;
	} else {
		return ActivityTypeNone;
	}
}
+ (NSString *)activityTypeToString:(AAPLActivityType)type
{
	switch (type) {
		case ActivityTypeWalking:
			return @"Walking";
		case ActivityTypeRunning:
			return @"Running";
		case ActivityTypeDriving:
			return @"Automotive";
		case ActivityTypeStationary:
			return @"Not Moving";
		case ActivityTypeMoving:
			return @"Moving";
		default:
			return @"Unclassified";
	}
}

@end
