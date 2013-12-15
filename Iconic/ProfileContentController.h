//
//  ProfileContentController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/13/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "ContentController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>




@class ProfileViewController;

@interface ProfileContentController : ContentController

@property (nonatomic, strong) IBOutlet ProfileViewController * profileViewController;

@end
