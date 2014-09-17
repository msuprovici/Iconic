//
//  ChatTextInputTableViewCell.m
//  Iconic
//
//  Created by Mike Suprovici on 9/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "ChatTextInputTableViewCell.h"

@implementation ChatTextInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
