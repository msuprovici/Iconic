/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

     MotionActivityQuery to encapsulate the data needed for a single query against
     the motion activity db.
  
*/

#import "AAPLMotionActivityQuery.h"

@implementation AAPLMotionActivityQuery

- (instancetype)initWithDateRangeStartingFrom:(NSDate *)startDate to:(NSDate *)endDate isToday:(BOOL)today
{
	if ((self = [super init]) != nil) {
		_startDate = startDate;
		_endDate = endDate;
		_isToday = today;
		return self;
	}
	return nil;
}

- (NSString *)description
{
	if (_isToday) {
		return @"Today";
	} else {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		NSString *format = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0
															locale:[NSLocale currentLocale]];
		[formatter setDateFormat:format];
		return [formatter stringFromDate:_startDate];
	}
}

+ (AAPLMotionActivityQuery *)queryStartingFromDate:(NSDate *)date offsetByDay:(NSInteger)offset{
	 NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	 NSDateComponents *timeComponents = [currentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	 timeComponents.hour = 0;
	 timeComponents.day = timeComponents.day + offset;

	 NSDate *queryStart = [currentCalendar dateFromComponents:timeComponents];

	 timeComponents.day = timeComponents.day + 1;
	 NSDate *queryEnd = [currentCalendar dateFromComponents:timeComponents];

	 return [[AAPLMotionActivityQuery alloc] initWithDateRangeStartingFrom:queryStart to:queryEnd isToday:(offset == 0)];
}
@end
