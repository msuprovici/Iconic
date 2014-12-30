//
//  AchievmentsViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/23/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AchievmentsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

@property (strong, nonatomic) IBOutlet UIImageView *achievmentImage;

@property (strong, nonatomic) IBOutlet UIButton *exitButton;

- (IBAction)exitButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)shareButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *achievmentName;

@property (strong, nonatomic) IBOutlet UILabel *achivmentDetails;


-(void)initWithAchievment:(PFObject*)anAchievment;
@property (nonatomic, strong) PFObject *achievment;

@end
