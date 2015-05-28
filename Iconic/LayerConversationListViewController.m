//
//  LayerConversationListViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import "LayerConversationListViewController.h"
#import "LayerConversationViewController.h"
#import "UserManager.h"
#import "ATLConstants.h"
#import "ATLConversationTableViewCell.h"
#import "Constants.h"
#import "Amplitude.h"
#import "NSLayerClientObject.h"


@interface LayerConversationListViewController ()<ATLConversationListViewControllerDelegate, ATLConversationListViewControllerDataSource>

@end

@implementation LayerConversationListViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    //layer conversation from push
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(showNewLayerConversationViewController:)
//                                                 name:@"newChatMessage"
//                                               object:nil];

    
    self.dataSource = self;
    self.delegate = self;
    
//    [self.navigationController.navigationBar setTintColor:ATLBlueColor()];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:logoutItem];
    
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped:)];
    [self.navigationItem setRightBarButtonItem:composeItem];
    
    [self configureUI];
}


-(void)configureUI
{
    [[ATLConversationTableViewCell appearance] setConversationTitleLabelColor:IconicBalck];
    [[ATLConversationTableViewCell appearance] setConversationTitleLabelFont:IconicTitleFont];
    [[ATLConversationTableViewCell appearance] setLastMessageLabelColor:IconicGrey];
    [[ATLConversationTableViewCell appearance] setLastMessageLabelFont:IconicSubTitleFont];
    [[ATLConversationTableViewCell appearance] setUnreadMessageIndicatorBackgroundColor:IconicRed];
    [[ATLConversationTableViewCell appearance] setDateLabelColor: IconicGrey];
    [[ATLConversationTableViewCell appearance] setDateLabelFont:IconicSmallFont];
    
    
    //    [[ATLParticipantTableViewController appearance] set]
    
}


#pragma mark - ATLConversationListViewControllerDelegate Methods

- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didSelectConversation:(LYRConversation *)conversation
{
    [Amplitude logEvent:@"Conversation List: conversatoin selcted"];
    LayerConversationViewController *controller = [LayerConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
    controller.conversation = conversation;
    controller.displaysAddressBar = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didDeleteConversation:(LYRConversation *)conversation deletionMode:(LYRDeletionMode)deletionMode
{
    [Amplitude logEvent:@"Conversation List: conversatoin deleated"];
    NSLog(@"Conversation deleted");
}

- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didFailDeletingConversation:(LYRConversation *)conversation deletionMode:(LYRDeletionMode)deletionMode error:(NSError *)error
{
    NSLog(@"Failed to delete conversation with error: %@", error);
}

- (void)conversationListViewController:(ATLConversationListViewController *)conversationListViewController didSearchForText:(NSString *)searchText completion:(void (^)(NSSet *filteredParticipants))completion
{
    
    [Amplitude logEvent:@"Conversation List: conversatoin search"];
    [[UserManager sharedManager] queryForUserWithName:searchText completion:^(NSArray *participants, NSError *error) {
        if (!error) {
            if (completion) completion([NSSet setWithArray:participants]);
        } else {
            if (completion) completion(nil);
            NSLog(@"Error searching for Users by name: %@", error);
        }
    }];
}

#pragma mark - ATLConversationListViewControllerDataSource Methods

- (NSString *)conversationListViewController:(ATLConversationListViewController *)conversationListViewController titleForConversation:(LYRConversation *)conversation
{
    if ([conversation.metadata valueForKey:@"title"]){
        return [conversation.metadata valueForKey:@"title"];
    } else {
        NSArray *unresolvedParticipants = [[UserManager sharedManager] unCachedUserIDsFromParticipants:[conversation.participants allObjects]];
        NSArray *resolvedNames = [[UserManager sharedManager] resolvedNamesFromParticipants:[conversation.participants allObjects]];
        
        if ([unresolvedParticipants count]) {
            [[UserManager sharedManager] queryAndCacheUsersWithIDs:unresolvedParticipants completion:^(NSArray *participants, NSError *error) {
                if (!error) {
                    if (participants.count) {
                        [self reloadCellForConversation:conversation];
                    }
                } else {
                    NSLog(@"Error querying for Users: %@", error);
                }
            }];
        }
        
        if ([resolvedNames count] && [unresolvedParticipants count]) {
            return [NSString stringWithFormat:@"%@ and %lu others", [resolvedNames componentsJoinedByString:@", "], (unsigned long)[unresolvedParticipants count]];
        } else if ([resolvedNames count] && [unresolvedParticipants count] == 0) {
            return [NSString stringWithFormat:@"%@", [resolvedNames componentsJoinedByString:@", "]];
        } else {
            return [NSString stringWithFormat:@"Conversation with %lu users...", (unsigned long)conversation.participants.count];
        }
    }
}

#pragma mark - Actions

- (void)composeButtonTapped:(id)sender
{
    LayerConversationViewController *controller = [LayerConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
    controller.displaysAddressBar = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)logoutButtonTapped:(id)sender
{
    NSLog(@"logOutButtonTapAction");
    
    [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        if (!error) {
            [PFUser logOut];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSLog(@"Failed to deauthenticate: %@", error);
        }
    }];
}

- (void)closeButtonTapped:(id)sender
{
    
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil]; 
    
}

#pragma mark - Conversation Selection From Push Notification

- (void)selectConversation:(LYRConversation *)conversation
{
    if (conversation) {
        
        NSLog(@"navigateToViewForConversation  selectConversation");
        
        [self presentControllerWithConversation:conversation];
    }
}

//#pragma mark - Conversation Selection
//
//// The following method handles presenting the correct `ATLMConversationViewController`, regardeless of the current state of the navigation stack.
//- (void)presentControllerWithConversation:(LYRConversation *)conversation
//{
////    NSLog(@"presentControllerWithConversation");
////    LayerConversationViewController *existingConversationViewController = [self existingConversationViewController];
////    if (existingConversationViewController && existingConversationViewController.conversation == conversation) {
////        if (self.navigationController.topViewController == existingConversationViewController) return;
////        [self.navigationController popToViewController:existingConversationViewController animated:YES];
////        return;
////    }
//    
//    BOOL shouldShowAddressBar = (conversation.participants.count > 2 || !conversation.participants.count);
//    LayerConversationViewController *conversationViewController = [LayerConversationViewController conversationViewControllerWithLayerClient:self.layerClient];
//    //conversationViewController.applicationController = self;
//    
//    conversationViewController.displaysAddressBar = shouldShowAddressBar;
//    conversationViewController.conversation = conversation;
//    
//    [self.navigationController pushViewController:conversationViewController animated:YES];
//    
////    if (self.navigationController.topViewController == self) {
////        [self.navigationController pushViewController:conversationViewController animated:YES];
////    } else {
////        NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
////        NSUInteger listViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
////        NSRange replacementRange = NSMakeRange(listViewControllerIndex + 1, viewControllers.count - listViewControllerIndex - 1);
////        [viewControllers replaceObjectsInRange:replacementRange withObjectsFromArray:@[conversationViewController]];
////        [self.navigationController setViewControllers:viewControllers animated:YES];
////    }
//}
//
//#pragma mark - Helpers
//
//- (LayerConversationViewController *)existingConversationViewController
//{
//    if (!self.navigationController) return nil;
//    
//    NSUInteger listViewControllerIndex = [self.navigationController.viewControllers indexOfObject:self];
//    if (listViewControllerIndex == NSNotFound) return nil;
//    
//    NSUInteger nextViewControllerIndex = listViewControllerIndex + 1;
//    if (nextViewControllerIndex >= self.navigationController.viewControllers.count) return nil;
//    
//    id nextViewController = [self.navigationController.viewControllers objectAtIndex:nextViewControllerIndex];
//    if (![nextViewController isKindOfClass:[LayerConversationViewController class]]) return nil;
//    
//    return nextViewController;
//}

//#pragma mark - NSNotifications
//
//-(void)showNewLayerConversationViewController:(NSNotification *) notification
//{
//    if([[notification name] isEqualToString:@"newChatMessage"])
//    {
////        NSLog(@"LayerAuthenticated");
//                NSDictionary* chatMessage = notification.userInfo;
//        
////        LayerConversationListViewController *controller = [LayerConversationListViewController  conversationListViewControllerWithLayerClient:self.layerClient];
//        
//        LYRConversation *conversation = [chatMessage objectForKey:@"newChatMessage"];
//        NSLog(@"conversation: %@", conversation);
//
//        
//        LYRClient * cachedLayerClient = [[NSLayerClientObject sharedInstance] getCachedLayerClientForKey:@"layerClient"];
//        
//        LayerConversationViewController *controller = [LayerConversationViewController conversationViewControllerWithLayerClient:cachedLayerClient];
//        controller.conversation = conversation;
//        controller.displaysAddressBar = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//
//        
//            }
//}

@end
