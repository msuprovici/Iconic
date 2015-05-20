//
//  Chat+ActivityViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Explorence. All rights reserved.
//

#import "Chat+ActivityViewController.h"
#import "LayerConversationListViewController.h"
#import "CalculatePoints.h"
#import <LayerKit/LayerKit.h>
#import "ATLConstants.h"
#import "ATLConversationTableViewCell.h"
#import "LayerConversationListViewController.h"
#import "LayerConversationViewController.h"
#import "FindFriendsViewController.h"
#import "Amplitude.h"


@interface Chat_ActivityViewController ()

//layer
@property (nonatomic) LYRClient *layerClient;



@end

@implementation Chat_ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // add viewController so you can switch them later.
    
    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"42b66e50-f517-11e4-9829-c8f500001922"];
    self.layerClient  = [LYRClient clientWithAppID:appID];
    self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:@"image/jpeg", @"image/png",@"image/gif",nil];
    
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.typeSegmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;
}
- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        [self.currentViewController.view removeFromSuperview];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
    self.navigationItem.title = vc.title;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    
    if(index == 0)
    {
        UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
        
        [self.navigationItem setRightBarButtonItem:composeItem];
        
        [Amplitude logEvent:@"Conversation: Segment Toggle Presed"];
    }
    
    if(index == 1)
    {
        
        UIBarButtonItem *followFriendsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Follow_Icon_White.png"] style:UIBarButtonItemStylePlain target:self action:@selector(followButtonTapped:)];

        [self.navigationItem setRightBarButtonItem:followFriendsItem];
        
        [Amplitude logEvent:@"Activity: Segment Toggle Presed"];
    }

   
    
    switch (index) {
            
        case 0:
            
            vc = [LayerConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];

            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
            break;
    }
    return vc;
}

-(void)receivedLayerAuthenticationNotification:(NSNotification *) notification
{
    if([[notification name] isEqualToString:@"LayerAuthenticated"])
    {
        NSLog(@"LayerAuthenticated");
        NSDictionary* userInfo = notification.userInfo;
        
        self.layerClient = userInfo[@"layerClient"];
        
    }
}

- (void)composeButtonTapped:(id)sender
{
    LayerConversationViewController *controller = [LayerConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
    controller.displaysAddressBar = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    [Amplitude logEvent:@"Conversation: Compose Button Presed"];
}

- (void)followButtonTapped:(id)sender
{
    FindFriendsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFreindsViewController"];;

    [self.navigationController pushViewController:controller animated:YES];
    
    [Amplitude logEvent:@"Activity Feed: Find People Tapped"];
}




@end
