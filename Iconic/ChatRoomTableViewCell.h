//
//  ChatRoomTableViewCell.h
//  Iconic
//
//  Created by Mike Suprovici on 9/16/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userName;

//@property (strong, nonatomic) IBOutlet UILabel *message;

@property (strong, nonatomic) IBOutlet UITextView *message;

@property (strong, nonatomic) IBOutlet UILabel *date;


@end
