//
//  MyStatsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStatsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *pointsLabel;

@property (nonatomic, strong) IBOutlet UILabel *xpTitle;
@property (nonatomic, strong) IBOutlet UIImageView *statsImage;

- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel;

@end
