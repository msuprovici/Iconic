+ (BOOL)checkAvailability
{
	static dispatch_once_t sentinel;
	static BOOL available;
	dispatch_once(&sentinel, ^{
		 available = YES;
		 if ([CMMotionActivityManager isActivityAvailable]  == NO) {
			NSLog(@"Motion Activity is not available!");
			available = NO;
		 }

		 if ([CMPedometer isStepCountingAvailable] == NO) {
			NSLog(@"Step counting is not available!");
			available = NO;
		 }
	});
	return available;
}

- (void)_initMotionActivity
{
	_motionActivityMgr = [[CMMotionActivityManager alloc] init];
	_pedometer = [[CMPedometer alloc] init];
}

- (void)checkAuthorization:(void (^)(BOOL authorized))authorizationCheckCompletedHandler
{
	NSDate *now = [NSDate date];
	[_pedometer queryPedometerDataFromDate:now toDate:now withHandler:^(CMPedometerData *pedometerData, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			authorizationCheckCompletedHandler(!error || error.code != CMErrorMotionActivityNotAuthorized);
		});
	}];
}

- (void)queryHistoricalDataFrom:(NSDate *)startDate toDate:(NSDate *)endDate
{
	[_motionActivityMgr queryActivityStartingFromDate:startDate
											toDate:endDate
											toQueue:[NSOperationQueue mainQueue]
										withHandler:^(NSArray *activities, NSError *error) {
		if (error) {
			[self _handleError:error];
		} else {
			[self _additionalProcessingOn:activities];

			[_pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
				if (error) {
					[self _handleError:error];
				} else {
					_stepCounts = pedometerData.numberOfSteps;
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					_queryCompletionHandler();
				});
			}];
		}
	}];
}

- (void)startStepUpdates:(AAPLStepUpdateHandler)handler;
{
	[_pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			handler(pedometerData.numberOfSteps);
		});
	}];
}

- (void)stopStepUpdates
{
	[_pedometer stopPedometerUpdates];
}

- (void)startMotionUpdates:(AAPLMotionUpdateHandler)handler
{
	[_motionActivityMgr startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity) {
		handler([AAPLActivityDataManager activityToType:activity]);
	}];
}

- (void)stopMotionUpdates;
{
	[_motionActivityMgr stopActivityUpdates];
}

