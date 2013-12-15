//
//  ProfileContentController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/13/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "ProfileContentController.h"
#import "AppDelegate.h"
//#import "MyStatsContentController.h"
#import "ProfileViewController.h"

@implementation ProfileContentController

- (void)awakeFromNib
{
	// load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content_mystats" ofType:@"plist"];
    self.contentList = [NSArray arrayWithContentsOfFile:path];
    
    
    self.profileViewController.contentList = self.contentList;
    
}


@end
