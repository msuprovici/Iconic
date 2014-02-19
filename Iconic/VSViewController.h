//
//  VSViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/16/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "PNChart.h"
#import "MZTimerLabel.h"

@interface VSViewController : UIViewController<MZTimerLabelDelegate>



@property (strong, nonatomic) DACircularProgressView *progressView;

@property (strong, nonatomic) IBOutlet DACircularProgressView *circleProgressView;

@property (strong, nonatomic) IBOutlet MZTimerLabel *timerLabel;

@end
