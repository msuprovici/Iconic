//
//  MyStatsContentController.h
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#import "ContentController.h"

@class HomeViewController;

@interface MyStatsContentController : ContentController

@property (nonatomic, strong) IBOutlet HomeViewController *homeViewController;

@end
