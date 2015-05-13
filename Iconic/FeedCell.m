//
//  FeedCell.m
//  Iconic
//
//  Created by Mike Suprovici on 12/20/13.
//  Copyright (c) 2013 Iconic. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likePressed:(id)sender {
    
    
}
- (IBAction)commentPressed:(id)sender {
    
}

@end
