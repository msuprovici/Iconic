//
//  LogInPageContentViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 5/29/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInPageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *subTitleText;
@property NSString *imageFile;


@end
