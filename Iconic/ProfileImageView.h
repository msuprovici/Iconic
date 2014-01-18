//
//  ProfileImageView.h
//  Iconic
//
//  Created by Mike Suprovici on 1/17/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class PFImageView;
@interface ProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;


@end
