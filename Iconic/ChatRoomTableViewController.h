//
//  ChatRoomTableViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 9/16/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>
#import <Parse/PFObject.h>
#import <Parse/PFQuery.h>
#import <ParseUI/PFTableViewCell.h>

@interface ChatRoomTableViewController : PFQueryTableViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *team;

-(void)initWithChatTeam:(NSString*)aTeam;

@property (strong, nonatomic) IBOutlet UITextField *chatInputField;



@end
