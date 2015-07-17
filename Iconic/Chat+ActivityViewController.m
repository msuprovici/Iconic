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
#import "NSLayerClientObject.h"


@interface Chat_ActivityViewController ()

//layer
@property (nonatomic) LYRClient *layerClient;

@property (nonatomic) NSLayerClientObject *layerClientObject;


@end

@implementation Chat_ActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // add viewController so you can switch them later.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layerSetUp];
    
    //get the activitySegmentIndex set 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.typeSegmentedControl.selectedSegmentIndex = [defaults integerForKey:@"activitySegementedControlIndex"];
    
    
    UIViewController *vc = [self viewControllerForSegmentIndex:self.typeSegmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    self.currentViewController = vc;
    
    


}


-(void)layerSetUp
{
    

    //retrieve cached layer client
    LYRClient * cachedLayerClient = [[NSLayerClientObject sharedInstance] getCachedLayerClientForKey:@"layerClient"];
    self.layerClient = cachedLayerClient;
        

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
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //set the index for the segment for UISegmentControl in the activity view contorller
    [defaults setInteger:sender.selectedSegmentIndex forKey:@"activitySegementedControlIndex"];
    [defaults synchronize];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    
    
    if(index == 0)
    {
        
        UIBarButtonItem *followFriendsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Follow_Icon_White.png"] style:UIBarButtonItemStylePlain target:self action:@selector(followButtonTapped:)];

        [self.navigationItem setRightBarButtonItem:followFriendsItem];
        
        [Amplitude logEvent:@"Activity: Segment Toggle Presed"];
    }
    
    
    if(index == 1)
    {
        UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
        
        [self.navigationItem setRightBarButtonItem:composeItem];
        
        [Amplitude logEvent:@"Conversation: Segment Toggle Presed"];
    }
    
 

   
    
    switch (index) {
            
          case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedViewController"];
            break;
            
        case 1:
            
            vc = [LayerConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];

            break;
       
    }
    return vc;
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
    FindFriendsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFriendsNavigationController"];

//    [self.navigationController pushViewController:controller animated:YES];
    
    [self.navigationController presentViewController:controller animated:YES completion:^{
        
    }];
    
    [Amplitude logEvent:@"Activity Feed: Find People Tapped"];
}




@end