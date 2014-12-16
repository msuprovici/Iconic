//
//  ActivityHeaderCell.m
//  Iconic
//
//  Created by Mike Suprovici on 1/14/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "ActivityHeaderCell.h"
#import "Constants.h"

@implementation ActivityHeaderCell

@synthesize containerView;
@synthesize avatarImageView;
@synthesize userButton;
@synthesize timestampLabel;
@synthesize activityStatusLabel;
//@synthesize timeIntervalFormatter;
@synthesize activity;
@synthesize buttons;
@synthesize likeButton;
@synthesize commentButton;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

//- (id)initWithStyle:(UITableViewCellStyle)style buttons:(ActivityHeaderButtons)otherButtons
//- (id)initWithFrame:(CGRect)frame buttons:(ActivityHeaderButtons)otherButtons
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    //self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self.likeButton setBackgroundImage:[UIImage imageNamed:@"activity_speaker_icon_green-01.png"] forState:UIControlStateSelected];
        
        
//        [ActivityHeaderCell validateButtons:otherButtons];
//        buttons = otherButtons;
//
        
        
// we will set the parameters bellow in the storyboard
        
//        if (self.buttons & ActivityHeaderButtonsComment) {
//            // comments button
//            commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [containerView addSubview:self.commentButton];
//            [self.commentButton setFrame:CGRectMake( 242.0f, 10.0f, 29.0f, 28.0f)];
//            [self.commentButton setBackgroundColor:[UIColor clearColor]];
//            [self.commentButton setTitle:@"" forState:UIControlStateNormal];
//            [self.commentButton setTitleColor:[UIColor colorWithRed:0.369f green:0.271f blue:0.176f alpha:1.0f] forState:UIControlStateNormal];
//            [self.commentButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
//            [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake( -4.0f, 0.0f, 0.0f, 0.0f)];
//            [[self.commentButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
//            [[self.commentButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
//            [[self.commentButton titleLabel] setMinimumScaleFactor:11.0f];
//            [[self.commentButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
//            [self.commentButton setBackgroundImage:[UIImage imageNamed:@"IconComment.png"] forState:UIControlStateNormal];
//            [self.commentButton setSelected:NO];
//        }
//        
//        if (self.buttons & ActivityHeaderButtonsLike) {
//            // like button
//            likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [containerView addSubview:self.likeButton];
//            [self.likeButton setFrame:CGRectMake(206.0f, 8.0f, 29.0f, 29.0f)];
//            [self.likeButton setBackgroundColor:[UIColor clearColor]];
//            [self.likeButton setTitle:@"" forState:UIControlStateNormal];
//            [self.likeButton setTitleColor:[UIColor colorWithRed:0.369f green:0.271f blue:0.176f alpha:1.0f] forState:UIControlStateNormal];
//            [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//            [self.likeButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
//            [self.likeButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
//            [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//            [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
//            [[self.likeButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
//            [[self.likeButton titleLabel] setMinimumScaleFactor:11.0f];
//            [[self.likeButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
//            [self.likeButton setAdjustsImageWhenHighlighted:NO];
//            [self.likeButton setAdjustsImageWhenDisabled:NO];
//            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
//            [self.likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
//            [self.likeButton setSelected:NO];
//        }
//        
//        if (self.buttons & ActivityHeaderButtonsUser) {
//            // This is the user's display name, on a button so that we can tap on it
//            self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [containerView addSubview:self.userButton];
//            [self.userButton setBackgroundColor:[UIColor clearColor]];
//            [[self.userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
//            [self.userButton setTitleColor:[UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
//            [self.userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
//            //[[self.userButton titleLabel] setLineBreakMode:UILineBreakModeTailTruncation];
//            [[self.userButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
//            [self.userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
//        }

        
        
        // timestamp
//        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake( 50.0f, 24.0f, containerView.bounds.size.width - 50.0f - 72.0f, 18.0f)];
//        [containerView addSubview:self.timestampLabel];
//        [self.timestampLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
//        [self.timestampLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
//        [self.timestampLabel setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
//        [self.timestampLabel setFont:[UIFont systemFontOfSize:11.0f]];
//        [self.timestampLabel setBackgroundColor:[UIColor clearColor]];
//        
//        CALayer *layer = [containerView layer];
//        layer.backgroundColor = [[UIColor whiteColor] CGColor];
//        layer.masksToBounds = NO;
//        layer.shadowRadius = 1.0f;
//        layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
//        layer.shadowOpacity = 0.5f;
//        layer.shouldRasterize = YES;
//        layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, containerView.frame.size.height - 4.0f, containerView.frame.size.width, 4.0f)].CGPath;
    
        //self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
     //likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
     //[self.likeButton setSelected:NO];
        
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}


#pragma mark - ActivityHeaderCell

- (void)setActivity:(PFObject *)anActivity {
    activity = anActivity;
    
    
    //show user in feed
    

    if ([activity objectForKey:@"user"]) {
       
    
    
    // user's avatar
    PFUser *user = [activity objectForKey:kActivityUserKey];
    //PFFile *profilePictureSmall = [user objectForKey:kUserProfilePicSmallKey];
    
//    [self.avatarImageView setFile:[user objectForKey:kUserProfilePicSmallKey]];
//    [self.avatarImageView loadInBackground];
//    //turn photo to circle
//    CALayer *imageLayer = self.avatarImageView.layer;
//    [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
//    [imageLayer setBorderWidth:0];
//    [imageLayer setMasksToBounds:YES];

    //new approach for setting the photo that is more robust
    // Set a placeholder image first
    self.avatarImageView.image = [UIImage imageNamed:@"empty_avatar.png"];
    PFFile *imageFile = [user objectForKey:kUserProfilePicSmallKey];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        // Now that the data is fetched, update the cell's image property.
        self.avatarImageView.image = [UIImage imageWithData:data];

    }];
    
        //turn photo to circle
        CALayer *imageLayer = self.avatarImageView.layer;
        [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
        [imageLayer setBorderWidth:0];
        [imageLayer setMasksToBounds:YES];
    
    
    NSString *authorName = [user objectForKey:kUserDisplayNameKey];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
   
    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    else
    {
        
        // user's avatar
        [activity fetchIfNeededInBackground];
        PFObject *team = [activity objectForKey:@"team"];
//        [team fetchIfNeededInBackground];
        
        
        //new approach for setting the photo that is more robust
        // Set a placeholder image first
        self.avatarImageView.image = [UIImage imageNamed:@"empty_avatar.png"];
        PFFile *imageFile = [team objectForKey:@"teamAvatar"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            // Now that the data is fetched, update the cell's image property.
            self.avatarImageView.image = [UIImage imageWithData:data];
            
        }];
        
        //turn photo to circle
        CALayer *imageLayer = self.avatarImageView.layer;
        [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
        [imageLayer setBorderWidth:0];
        [imageLayer setMasksToBounds:YES];
        

        
        NSString *teamName = [team objectForKey:@"teams"];
        [self.userButton setTitle:teamName forState:UIControlStateNormal];
        self.userButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Neue-Medium" size:20];//changing font to differentiate between team & user activity
        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
        
    
    
    
    
    
    
    
    [self.commentButton addTarget:self action:@selector(didTapCommentOnActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
        
        
//    CGFloat constrainWidth = containerView.bounds.size.width;
//    
//    if (self.buttons & ActivityHeaderButtonsUser) {
//        [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    if (self.buttons & ActivityHeaderButtonsComment) {
//        constrainWidth = self.commentButton.frame.origin.x;
//        [self.commentButton addTarget:self action:@selector(didTapCommentOnActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    if (self.buttons & ActivityHeaderButtonsLike) {
//       constrainWidth = self.likeButton.frame.origin.x;
//        [self.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        NSLog(@"like activity is tapped");
//    }
    
// moved the time stamp to FeedViewController in cellForRowAtIndexPath
//    NSTimeInterval timeInterval = [[self.activity createdAt] timeIntervalSinceNow];
//    NSString *timestamp = [self.timeIntervalFormatter stringForTimeInterval:timeInterval];
//    [self.timestampLabel setText:timestamp];
    

    
    [self setNeedsDisplay];
}

- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"activity_speaker_icon_green-01.png"] forState:UIControlStateSelected];
    
//    
//    if (liked) {
//        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f)];
//        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
//    } else {
//        [self.likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//        [[self.likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
//    }
}

- (void)shouldEnableLikeButton:(BOOL)enable {
    if (enable) {
        [self.likeButton removeTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       
    } else {
        [self.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}



#pragma mark - ()

+ (void)validateButtons:(ActivityHeaderButtons)buttons {
    if (buttons == ActivityHeaderButtonsNone) {
        [NSException raise:NSInvalidArgumentException format:@"Buttons must be set before initializing ActivityHeaderCell."];
    }
}

- (void)didTapUserButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(activityHeaderCell:didTapUserButton:user:)]) {
        [delegate activityHeaderCell:self didTapUserButton:sender user:[self.activity objectForKey:kActivityUserKey]];
    }
}

- (void)didTapLikeActivityButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(activityHeaderCell:didTapLikeActivityButton:activity:)]) {
        [delegate activityHeaderCell:self didTapLikeActivityButton:button activity:self.activity];
       
    }
}



- (void)didTapCommentOnActivityButtonAction:(UIButton *)sender {
    if (delegate && [delegate respondsToSelector:@selector(activityHeaderCell:didTapCommentOnActivityButton:activity:)]) {
        [delegate activityHeaderCell:self didTapCommentOnActivityButton:sender activity:self.activity];
    }
}


@end
