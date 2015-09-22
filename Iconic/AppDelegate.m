//
//  AppDelegate.m
//  Iconic
//
//  Created by Mike Suprovici on 11/11/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//


#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "ContentController.h"
#import "Cache.h"
#import "Constants.h"
#import "Utility.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "SimpleHomeViewController.h"
#import "CalculatePoints.h"
#import "Amplitude.h"
#import <Crashlytics/Crashlytics.h>
#import "Intercom.h"
#import "Heap.h"
#import "ParseCrashReporting/ParseCrashReporting.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AchievmentsViewController.h"
#import <LayerKit/LayerKit.h>
//#import "Flurry.h"
#import "NSLayerClientObject.h"
#import "ATLMLayerClient.h"
#import "LayerConversationListViewController.h"
#import "Helpshift.h"


@interface AppDelegate ()
//@property (nonatomic, strong) IBOutlet ContentController * contentController;

{
    NSMutableData *_data;
    BOOL firstLaunch;
}

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;

@property (nonatomic, strong) Reachability *hostReach;
@property (nonatomic, strong) Reachability *internetReach;
@property (nonatomic, strong) Reachability *wifiReach;

- (BOOL)shouldProceedToMainInterface:(PFUser *)user;


@property (nonatomic) LYRClient *layerClient;

@property (nonatomic) ATLMLayerClient *ATLMlayerClient;

@property (nonatomic) LayerConversationListViewController *conversationListViewController;

@end


@implementation AppDelegate

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //perform background fetch
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //Parse crash reporting
    [ParseCrashReporting enable];
    
    //local data store
//    [Parse enableLocalDatastore];

    //initialize Parse
    [Parse setApplicationId:@"LiLukyOROzCPxkNIvG9SD6nPMFdZsFNxzYsB06LT"
                  clientKey:@"NWnu7sQiFf9t3vyruSWQ8CqepFjKQh7IAZr8b3WA"];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    
    
    
    
    
    
    //Helpshift - user feedback crm
    [Helpshift installForApiKey:@"9397c3001d4a630a953359add784a5a0"
                     domainName:@"iconic.helpshift.com"
                          appID:@"iconic_platform_20150822182921470-d193036549166a3"];

    
    
    //layer
    // Initializes a LYRClient object
//    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"42b66e50-f517-11e4-9829-c8f500001922"];
//    LYRClient *layerClient = [LYRClient clientWithAppID:appID];
    
//    // Tells LYRClient to establish a connection with the Layer service
//    [layerClient connectWithCompletion:^(BOOL success, NSError *error) {
//        if (success) {
//            NSLog(@"Layer Client is Connected!");
//        }
//    }];
    
    
    
    
    
       
    //initialize Amplitude analytics
     //beta key
//   [Amplitude initializeApiKey:@"43017a7316efee7bf680d57d7c3ab327"]; //live
    
    //testing key
    [Amplitude initializeApiKey:@"57b975d88461d62229be49013e2b5465"]; //dev
    
    //Flurry
    
    //beta key
//  [Flurry startSession:@"MNPN945STSGP59PFCSFW"];
    
    //testing key
//    [Flurry startSession:@"GFB5TWRMW9J2YNCMPK7R"];

    //initialize intercom
    
//    [Intercom setApiKey:@"ios_sdk-ef94768add5214ef0cd00d0bf8195444ee082b0c" forAppId:@"tx0dtabz"];//live
    
//    [Intercom setApiKey:@"ios_sdk-ef94768add5214ef0cd00d0bf8195444ee082b0c" forAppId:@"c1ubvxjw"];//dev
    
    
    //initialize heap analytics
    
//    [Heap setAppId:@"1914446395"]; //live
//    
////    [Heap setAppId:@"3704495766"]; //dev
//    #ifdef DEBUG
////        [Heap enableVisualizer]; //uncomment to set up events
//    #endif
    
    //Intitialize FB
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
//    [FBAppEvents activateApp];
    
//    // Checking if app is running iOS 8
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        // Register device for iOS8
//        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:notificationSettings];
//        [application registerForRemoteNotifications];
//    }
//    else {
//        // Register device for iOS7
//        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
//    }

    
//    // Register for push notifications
//    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (ver >= 8.0) {
//        // Only executes on version OS 8 or above.
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
//         UIUserNotificationTypeBadge |
//         UIUserNotificationTypeSound
//                                          categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//    
//    [application registerForRemoteNotificationTypes:
//     UIRemoteNotificationTypeBadge |
//     UIRemoteNotificationTypeAlert |
//     UIRemoteNotificationTypeSound];
//    }
    
    
    
    //Crashlytics crash reporting
    [Crashlytics startWithAPIKey:@"dccd1cb0874211ca77a81c83ab5926ee77e129d4"];
    
    //local notification
    
    CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
    
//    [calculatePointsClass  createFinalTeamScoresNotificationBody];
//    if ([PFUser currentUser]) {
//    [calculatePointsClass retrieveFromParse];
//    [calculatePointsClass incrementPlayerPointsInBackground];
//        
////    [[UIApplication sharedApplication] cancelAllLocalNotifications];
////    [calculatePointsClass scheduleDailySummaryLocalNotification];
////    [calculatePointsClass migrateLeaguesToCoreData];
//    }

    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    
    
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    //If user is already logged in, skip the login screen and go to the main view
   if([PFUser currentUser]) {
       
       //set parse username as the user id in Amplitude
       NSString *userId =  [[PFUser currentUser] objectForKey:@"username"];
       [Amplitude setUserId:userId];
       
       //set parse username for Intercom
       [Intercom beginSessionForUserWithUserId:userId completion:nil];
       
       
       // set parse username for Heap
       NSDictionary* userProperties = @{
                                        @"name": userId,
                                        };
       
       [Heap identify:userProperties];
       
       [calculatePointsClass migrateLeaguesToCoreData];
       
       [calculatePointsClass autoFollowUsers];
       
       
       //layer
       LYRClient * cachedLayerClient = [[NSLayerClientObject sharedInstance] getCachedLayerClientForKey:@"layerClient"];
       
       if(cachedLayerClient)
       {
           //        NSLog(@"cached Layer Client");
       }
       else
       {
           CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
           
            NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"42b66e50-f517-11e4-9829-c8f500001922"];
           self.layerClient = [LYRClient clientWithAppID:appID];
           [calculatePointsClass loginLayer:self.layerClient];
           
           
       }

       
       
       
        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
        self.window.rootViewController = rootViewController;
       
       if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
           NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
           [PFPush handlePush:notificationPayload];
       }

       
    }
    else
    {
        [self logOut];
    }
    
    
    // Extract the notification data
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSString *notificationId = [notificationPayload objectForKey:@"teamAchievmentID"];
    
    if ([notificationId isEqualToString:@"AchievmentReceived"]) {
        
    // Present Achievment View Controller
    NSString *achievmentId = [notificationPayload objectForKey:@"teamAchievmentID"];
    
    PFObject *achievmentObject = [PFObject objectWithoutDataWithClassName:@"AchievmentDefinitions"
                                                            objectId:achievmentId];
    
    // Fetch achievment object
    [achievmentObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        // Show achievment view controller
        if (!error && [PFUser currentUser]) {
            
//             NSLog(@"achievmentReceived notification sent in did finish launching");
            
            //send achievement object to simplehomeviewcontroller via nsnotificaiton
            NSDictionary* userInfo = @{@"achievment": object};
            
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"achievmentReceived" object:self userInfo:userInfo];
            
        }
    }];
        
    }
    
//    pageControl.hidden = YES;
    
    
    [self customizeAppearance];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)customizeAppearance
{
   //sets the font for the title of each view controller
 //   [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSFontAttributeName, nil]];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]];
    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor whiteColor],
//                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20], nil]];
    
    
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0]];

    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]];
    
    [[UINavigationBar appearance] setTranslucent:FALSE];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
   
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f],NSFontAttributeName,
                                                           nil] forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f], NSFontAttributeName,
                                                          nil] ];
    
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    
//    ACAccountStore *accountStore;
//    ACAccountType *accountTypeFB;
//    if ((accountStore = [[ACAccountStore alloc] init]) &&
//        (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
//        
//        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
//        id account;
//        if (fbAccounts && [fbAccounts count] > 0 &&
//            (account = [fbAccounts objectAtIndex:0])){
//            
//            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
//                //we don't actually need to inspect renewResult or error.
//                if (error){
//                    
//                }
//            }];
//        }
//    }
    
    
   //sets color of the text inside the button but not the image/accessory
//   [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:15], NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    //this changes the color of all accessories & buttons
    //self.window.tintColor = [UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    //this changes the clor of just UIBarButtonItems
//    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
//        [UINavigationBar appearance].tintColor = [UIColor blackColor];
//    }
    
}

// Facebook oauth callback
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [PFFacebookUtils handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [PFFacebookUtils handleOpenURL:url];
//}
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    // attempt to extract a token from the url
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
//}

// Facebook oauth callback
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];
    
    //reset push notification badge to 0 once the app has been opened
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    // Handle an interruption during the authorization flow, such as the user clicking the home button.
//    [FBSession.activeSession handleDidBecomeActive];
    
    CalculatePoints * calculatePointsClass = [[CalculatePoints alloc]init];
    
    if ([PFUser currentUser]) {
//    [calculatePointsClass retrieveFromParse];
//    [calculatePointsClass findPastWeekleySteps];
    }
    
//     [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    
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
    
    //track if the app was terminated
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:kAppWasTerminated];
//    [defaults setObject:[NSDate date] forKey:@"dateAppWasTerminated"];
//    [defaults synchronize];
    
}

#pragma mark background fetch

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    // Call or write any code necessary to get new data, process it and update the UI.

    NSDate *fetchStart = [NSDate date];
    
   CalculatePoints *calculatePoints = [[CalculatePoints alloc]init];
    
//    [calculatePoints fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
//        completionHandler(result);
    
        NSDate *fetchEnd = [NSDate date];
        NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
    
        NSLog(@"Background Fetch Duration: %f seconds", timeElapsed);
    
     if ([PFUser currentUser]) {
        [calculatePoints findPastWeekleySteps];
//        [calculatePoints retrieveFromParse];
//        [calculatePoints getYesterdaysPointsAndSteps];
     }
    
//    }];
    NSLog(@"Background fetch intialized");
    
    
    //buying Parse 20 seconds to perform retrieve and save
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       
//    [Amplitude logEvent:@"Background Fetch Completed"];
                       NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:[NSDate date] forKey:kDateAppLastRan];
                       [defaults synchronize];

                       
    completionHandler(UIBackgroundFetchResultNewData);
    });
    
    

    // The logic for informing iOS about the fetch results in plain language:
//    if (/** NEW DATA EXISTS AND WAS SUCCESSFULLY PROCESSED **/) {
//        completionHandler(UIBackgroundFetchResultNewData);
//    }
//    
//    if (/** NO NEW DATA EXISTS **/) {
//        completionHandler(UIBackgroundFetchResultNoData);
//    }
//    
//    if (/** ANY ERROR OCCURS **/) {
//        completionHandler(UIBackgroundFetchResultFailed);
//    }
}

#pragma mark push notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    
    if ([PFUser currentUser]) {
        currentInstallation[@"user"] = [PFUser currentUser];
    } else {
        [currentInstallation removeObjectForKey:@"user"];
    }
    
    [currentInstallation saveInBackground];
    
    NSError *error;
    BOOL success = [self.layerClient updateRemoteNotificationDeviceToken:newDeviceToken error:&error];
    if (success) {
//        NSLog(@"Layer did register for remote notifications");
    } else {
//        NSLog(@"Error updating Layer device token for push:%@", error);
    }

    
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    NSLog(@"did receive cheer push");
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}


//silent push notification to retrieve points at the end of the day
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    

//    NSLog(@"User Info: %@", userInfo);
    BOOL userTappedRemoteNotification = application.applicationState == UIApplicationStateInactive;
    __block LYRConversation *conversation = [self conversationFromRemoteNotification:userInfo];
    if (userTappedRemoteNotification && conversation) {

    } else if (userTappedRemoteNotification) {
    }
    
    BOOL success = [self.layerClient synchronizeWithRemoteNotification:userInfo completion:^(NSArray *changes, NSError *error) {
        if (changes.count) {
            handler(UIBackgroundFetchResultNewData);
        } else {
            handler(error ? UIBackgroundFetchResultFailed : UIBackgroundFetchResultNoData);
        }
        
        // Try navigating once the synchronization completed
        if (userTappedRemoteNotification && !conversation) {
//            [SVProgressHUD dismiss];
            NSLog(@"userTappedRemoteNotification");
            conversation = [self conversationFromRemoteNotification:userInfo];
            
            NSDictionary* chatConversation = [[NSMutableDictionary alloc]init];
            
            [chatConversation setValue:conversation forKey:@"conversation"];
  
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"newChatMessage" object:chatConversation ];
            
            
            [nc postNotificationName:@"newConversation" object:chatConversation ];
            
            
            
//            [self navigateToViewForConversation:conversation];
        }
    }];
    
    if (!success) {
        handler(UIBackgroundFetchResultNoData);
    }

    
    
    
    
    NSString *notificationId = [userInfo objectForKey:@"notificationID"];
    
    if ([notificationId isEqualToString:@"GetFinalScorePush"]) {
        
//        NSLog(@"silent notificaiton: get score push");
        
        
        CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
        [calculatePointsClass  createFinalTeamScoresNotificationBody];
        
        
        
//        [Amplitude logEvent:@"GetFinalScore Push Received"];
        //reset mysteps at 11:58 pm
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        
        int myStoredSteps = (int)[defaults integerForKey:kMyFetchedStepsToday];
        [defaults setInteger:myStoredSteps   forKey:@"myFinalStepsForTheDay"];
        //    [defaults synchronize];
        
        //    [defaults setInteger:0   forKey:kMyFetchedStepsToday];
        //    [defaults synchronize];
        
        //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //If the day of the week is Sunday, change the bool "hasRunAppThisWeekKey"  so that we can display FinalScoresTableViewController tomorrow or the next time the user opens the app next week.
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        
        
        
        NSInteger weekday = [weekdayComponents weekday];
        //Sunday = 1
        if (weekday == 1) {
            
            [defaults setBool:NO forKey:@"hasRunAppThisWeekKey"];
            [defaults setObject:[NSDate date] forKey:kDateAppLastRan];
            [defaults synchronize];
            
            //schedule notification
             if ([PFUser currentUser]) {
            CalculatePoints *calculatePointsClass = [[CalculatePoints alloc]init];
            [calculatePointsClass  saveFinalTeamScoresToDefaults];
            [calculatePointsClass  createFinalTeamScoresNotificationBody];
             }
        }
        
        //    if([userInfo[@"aps"][@"content-available"] intValue]== 1)
        
        //    if([userInfo[@"content-available"] intValue]== 1) //it's the silent notification
        //    {
        
        
        //fetch the team & player stats for today
        NSDate *fetchStart = [NSDate date];
        
        CalculatePoints *calculatePoints = [[CalculatePoints alloc]init];
        
        
        NSDate *fetchEnd = [NSDate date];
        NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
        NSLog(@"Background Fetch From Push Duration: %f seconds", timeElapsed);
        
        //send and retrieve data from Parse
         if ([PFUser currentUser]) {
        [calculatePoints findPastWeekleySteps];
//        [calculatePoints retrieveFromParse];
         }
        
        
        
        
        //buying Parse 20 seconds to perform retrieve and save
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           

                           int myStoredSteps = (int)[defaults integerForKey:kMyFetchedStepsToday];
                           [defaults setInteger:myStoredSteps   forKey:@"myFinalStepsForTheDay"];
                           [defaults setObject:[NSDate date] forKey:kDateAppLastRan];
                           [defaults synchronize];
                           
                           
                           [defaults setInteger:0   forKey:kMyFetchedStepsToday];
                           [defaults synchronize];
                           
                           
                           NSLog(@"Background Fetch From weekley notification retrieve and save");
                           handler(UIBackgroundFetchResultNewData);
                           
                       });

        
    }
    
    if ([notificationId isEqualToString:@"GetHourlyUpdatePush"]) {
        
//        [Amplitude logEvent:@"GetHourlyUpdate Push Received"];
        
//        NSLog(@"Get Hourly Push Received");
        NSDate *fetchStart = [NSDate date];
        
        CalculatePoints *calculatePoints = [[CalculatePoints alloc]init];
        
        NSDate *fetchEnd = [NSDate date];
        NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
        NSLog(@"Background Fetch From hourly push notifications Duration: %f seconds", timeElapsed);
        
         if ([PFUser currentUser]) {
        [calculatePoints findPastWeekleySteps];
//        [calculatePoints retrieveFromParse];
         }
        //        [calculatePoints getYesterdaysPointsAndSteps];
        
        //    }];
//        NSLog(@"Background fetch from silent push notification intialized");
        
        //buying Parse 20 seconds to perform retrieve and save
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           
                           
                           NSLog(@"Background Fetch from hourly push retrieve and save");
                           NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                           [defaults setObject:[NSDate date] forKey:kDateAppLastRan];
                           [defaults synchronize];
                           
                           handler(UIBackgroundFetchResultNewData);
                       });

        
    }
    if ([notificationId isEqualToString:@"CheersPush"]) {
        
        [PFPush handlePush:userInfo];
        NSLog(@"did receive cheer push in background");
        handler(UIBackgroundFetchResultNewData);
        
    }
    
    if ([notificationId isEqualToString:@"AchievmentReceived"]) {
        
        // Create a pointer to the Photo object
        NSString *achievmentId = [userInfo objectForKey:@"teamAchievmentID"];
        PFObject *achievmentObject = [PFObject objectWithoutDataWithClassName:@"AchievmentDefinitions"
                                                                     objectId:achievmentId];
        
        // Fetch achievment object
        [achievmentObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (error) {
                handler(UIBackgroundFetchResultFailed);
            } else if ([PFUser currentUser]) {

                
//                 NSLog(@"achievmentReceived notification sent in push");
                
                //send achievement object to simplehomeviewcontroller via nsnotificaiton
                NSDictionary* userInfo = @{@"achievment": object};
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"achievmentReceived" object:self userInfo:userInfo];
                
                
                handler(UIBackgroundFetchResultNewData);
            } else {
                handler(UIBackgroundFetchResultNoData);
            }        }];

    }
    
//    handler(UIBackgroundFetchResultNewData);
  
        
        return;
    
}

- (LYRMessage *)messageFromRemoteNotification:(NSDictionary *)remoteNotification
{
    static NSString *const LQSPushMessageIdentifierKeyPath = @"layer.message_identifier";
    
    // Retrieve message URL from Push Notification
    NSURL *messageURL = [NSURL URLWithString:[remoteNotification valueForKeyPath:LQSPushMessageIdentifierKeyPath]];
    
    // Retrieve LYRMessage from Message URL
    LYRQuery *query = [LYRQuery queryWithClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"identifier" operator:LYRPredicateOperatorIsIn value:[NSSet setWithObject:messageURL]];
    
    NSError *error;
    NSOrderedSet *messages = [self.layerClient executeQuery:query error:&error];
    if (!error) {
        NSLog(@"Query contains %lu messages", (unsigned long)messages.count);
        LYRMessage *message= messages.firstObject;
        LYRMessagePart *messagePart = message.parts[0];
        NSLog(@"Pushed Message Contents: %@",[[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    
    return [messages firstObject];
}

- (LYRConversation *)conversationFromRemoteNotification:(NSDictionary *)remoteNotification
{
    NSURL *conversationIdentifier = [NSURL URLWithString:[remoteNotification valueForKeyPath:@"layer.conversation_identifier"]];
    return [self.ATLMlayerClient existingConversationForIdentifier:conversationIdentifier];
}

//- (void)navigateToViewForConversation:(LYRConversation *)conversation
//{
//    if (![NSThread isMainThread]) {
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempted to navigate UI from non-main thread" userInfo:nil];
//    }
//    
//    self.conversationListViewController = [LayerConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];
//    NSLog(@"navigateToViewForConversation");
//    [self.conversationListViewController presentControllerWithConversation:conversation];
//}





#pragma mark local notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Summary"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if(state == UIApplicationStateInactive){
        
    }
    
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}



#pragma mark background log out

- (void)logOut {
    // clear cache
    [[Cache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] removeObjectForKey:kInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    //clear allLocalNotificaitons
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
//    [self.navController popToRootViewControllerAnimated:NO];
//    
//    [self presentLoginViewController];
//    
//    self.homeViewController = nil;
//    self.activityViewController = nil;
}



#pragma mark facebook

- (void)facebookRequestDidLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    PFUser *user = [PFUser currentUser];
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
                
                
            }
        }
        
        // cache friend data
        [[Cache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
            
            
            
            
            
            if (![user objectForKey:kUserAlreadyAutoFollowedFacebookFriendsKey]) {
                self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                firstLaunch = YES;
                
                [user setObject:@YES forKey:kUserAlreadyAutoFollowedFacebookFriendsKey];
                NSError *error = nil;
                
                // find common Facebook friends already using Iconic
                PFQuery *facebookFriendsQuery = [PFUser query];
                [facebookFriendsQuery whereKey:kUserFacebookIDKey containedIn:facebookIds];
                
                // auto-follow Parse employees <- create teams/interests to autofollow here
                PFQuery *autoFollowAccountsQuery = [PFUser query];
               [autoFollowAccountsQuery whereKey:kUserFacebookIDKey containedIn:kAutoFollowAccountFacebookIds];
         
                // combined query
                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:autoFollowAccountsQuery,facebookFriendsQuery, nil]];
                
                NSArray *iconicFollowers = [query findObjects:&error];
                
                if (!error) {
                    [iconicFollowers enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                        
                        PFObject *joinActivity = [PFObject objectWithClassName:kPlayerActionClassKey];
                        [joinActivity setObject:user forKey:kPlayerActionFromUserKey];
                        [joinActivity setObject:newFriend forKey:kPlayerActionToUserKey];
                        [joinActivity setObject:kPlayerActionTypeJoined forKey:kPlayerActionTypeKey];
                        
                        PFACL *joinACL = [PFACL ACL];
                        [joinACL setPublicReadAccess:YES];
                        joinActivity.ACL = joinACL;
                        
                        // make sure our join activity is always earlier than a follow
                        [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [Utility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                // This block will be executed once for each friend that is followed.
                                // We need to refresh the timeline when we are following at least a few friends
                                // Use a timer to avoid refreshing innecessarily
                                if (self.autoFollowTimer) {
                                    [self.autoFollowTimer invalidate];
                                }
                                
//                                self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                            }];
                        }];
                    }];
                }
                
                if (![self shouldProceedToMainInterface:user]) {
                    [self logOut];
                    return;
                }
                
                if (!error) {
                    //[MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                    if (iconicFollowers.count > 0) {
                        //self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                        self.hud.dimBackground = YES;
                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                    } else {
                      //  [self.homeViewController loadObjects];
                    }
                }
            }
            
            [user saveEventually];
        } else {
            NSLog(@"No user session found. Forcing logOut.");
            [self logOut];
        }
    } else {
        self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);
        
        if (user) {
            NSString *facebookName = result[@"name"];
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kUserDisplayNameKey];
            } else {
                [user setObject:@"Someone" forKey:kUserDisplayNameKey];
            }
            
            NSString *facebookId = result[@"id"];
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kUserFacebookIDKey];
            }
            
            [user saveEventually];
        }
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//- (NSDictionary*)parseURLParams:(NSString *)query {
//    NSArray *pairs = [query componentsSeparatedByString:@"&"];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *pair in pairs) {
//        NSArray *kv = [pair componentsSeparatedByString:@"="];
//        NSString *val =
//        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        params[kv[0]] = val;
//    }
//    return params;
//}



#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LeaguesTeamsModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LeagueTeamData.sqlite"];
//    DLog(@"Core Data store path = \"%@\"", [storeURL path]);
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}



#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
