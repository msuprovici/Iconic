//
//  ChatTextInputTableViewCell.h
//  Iconic
//
//  Created by Mike Suprovici on 9/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTextInputTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *chatTextInput;

@property (strong, nonatomic) IBOutlet UIButton *chatSendButton;

@end
