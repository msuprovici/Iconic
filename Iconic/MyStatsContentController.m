//
//  MyStatsContentController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Iconic All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "MyStatsContentController.h"

@implementation MyStatsContentController


- (void)awakeFromNib
{
	// load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content_mystats" ofType:@"plist"];
    self.contentList = [NSArray arrayWithContentsOfFile:path];
    self.homeViewController.contentList = self.contentList;
    
    /*AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = (UIViewController *)self.homeViewController;*/
}

@end
