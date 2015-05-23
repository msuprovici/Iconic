//
//  Chat+ActivityViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Atlas.h"

@interface Chat_ActivityViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UIViewController * currentViewController;



@end
