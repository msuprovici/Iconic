//
//  AppDelegate.m
//  Iconic
//
//  Created by Mike Suprovici on 11/11/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//


#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ContentController.h"


@interface AppDelegate ()
//@property (nonatomic, strong) IBOutlet ContentController * contentController;
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"LiLukyOROzCPxkNIvG9SD6nPMFdZsFNxzYsB06LT"
                  clientKey:@"NWnu7sQiFf9t3vyruSWQ8CqepFjKQh7IAZr8b3WA"];
    
    //Round Robin: testing out new schedule parse cloud function
    /*[PFCloud callFunctionInBackground:@"schedule"
                       withParameters:@{@"NumberOfTeams":@3}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                        NSLog(@"%@", result);
                                    }
                                }];*/
    //Intitialize FB
    [PFFacebookUtils initializeFacebook];
    
    //If user is already logged in, skip the login screen and go to the main view
   if([PFUser currentUser]) {
        
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
        self.window.rootViewController = rootViewController;
    }

    [self customizeAppearance];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)customizeAppearance
{
    // Customize the title text for *all* UINavigationBars
    /*[[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      NSForegroundColorAttributeName,[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      NSShadowAttributeName, [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSShadowAttributeName, [UIFont fontWithName:@"DIN Alternate" size:17],
      NSFontAttributeName,
      nil]];*/
    
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
   
}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
    [FBSession.activeSession handleDidBecomeActive];
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/*- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}*/

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
