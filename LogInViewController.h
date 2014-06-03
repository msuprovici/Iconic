//
//  LogInViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 11/12/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LogInPageContentViewController.h"


@interface LogInViewController :
UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *startWalkthroughButton;



@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageSubTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic) NSInteger vcIndex;
@property UILabel *myLabel;

@end
