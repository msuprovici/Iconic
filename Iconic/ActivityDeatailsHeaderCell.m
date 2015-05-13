//
//  ActivityDeatailsHeaderCell.m
//  Iconic
//
//  Created by Mike Suprovici on 1/17/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "ActivityDeatailsHeaderCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "Constants.h"
#import "ProfileImageView.h"
#import "Cache.h"
#import "Utility.h"


#define baseHorizontalOffset 20.0f
#define baseWidth 280.0f

#define horiBorderSpacing 6.0f
#define horiMediumSpacing 8.0f

#define vertBorderSpacing 6.0f
#define vertSmallSpacing 2.0f


#define nameHeaderX baseHorizontalOffset
#define nameHeaderY 0.0f
#define nameHeaderWidth baseWidth
#define nameHeaderHeight 46.0f

#define avatarImageX horiBorderSpacing
#define avatarImageY vertBorderSpacing
#define avatarImageDim 35.0f

#define nameLabelX avatarImageX+avatarImageDim+horiMediumSpacing
#define nameLabelY avatarImageY+vertSmallSpacing
#define nameLabelMaxWidth 280.0f - (horiBorderSpacing+avatarImageDim+horiMediumSpacing+horiBorderSpacing)

#define timeLabelX nameLabelX
#define timeLabelMaxWidth nameLabelMaxWidth

#define mainImageX baseHorizontalOffset
#define mainImageY nameHeaderHeight
#define mainImageWidth baseWidth
#define mainImageHeight 280.0f

#define likeBarX baseHorizontalOffset
#define likeBarY nameHeaderHeight + mainImageHeight
#define likeBarWidth baseWidth
#define likeBarHeight 43.0f

#define likeButtonX 9.0f
#define likeButtonY 7.0f
#define likeButtonDim 28.0f

#define likeProfileXBase 46.0f
#define likeProfileXSpace 3.0f
#define likeProfileY 6.0f
#define likeProfileDim 30.0f

#define viewTotalHeight likeBarY+likeBarHeight
#define numLikePics 7.0f


@interface ActivityDeatailsHeaderCell()

@property (nonatomic, strong) UIView *nameHeaderView;
@property (nonatomic, strong) UIView *likeBarView;
@property (nonatomic, strong) NSMutableArray *currentLikeAvatars;


// Redeclare for edit
@property (nonatomic, strong, readwrite) PFUser *activeplayer;

// Private methods
- (void)createView;

@end

static TTTTimeIntervalFormatter *timeFormatter;

@implementation ActivityDeatailsHeaderCell

@synthesize activity;
@synthesize activeplayer;
@synthesize likeUsers;
@synthesize nameHeaderView;
@synthesize avatarImage;
@synthesize likeBarView;
@synthesize likeButton;
@synthesize delegate;
@synthesize currentLikeAvatars;

-(id)initWithFrame:(CGRect)frame activity:(PFObject *)anActivity

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    //self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.activity = anActivity;
        self.activeplayer = [self.activity objectForKey:kActivityUserKey];
        self.likeUsers = nil;
        
       [self createView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame activity:(PFObject*)anActivity activeplayer:(PFUser*)anActiveplayer likeUsers:(NSArray*)theLikeUsers {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        self.activity = anActivity;
        self.activeplayer = anActiveplayer;
        self.likeUsers = theLikeUsers;
        
       // self.backgroundColor = [UIColor clearColor];
        
        if (self.activity && self.activeplayer && self.likeUsers) {
            [self createView];
        }
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - ActivityDetailsHeaderCell

+ (CGRect)rectForView {
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, viewTotalHeight);
}


- (void)setActivity:(PFObject *)anActivity {
    activity = anActivity;
    
    
//    // user's avatar
//    PFUser *user = [self.activity objectForKey:kActivityUserKey];
//    PFFile *profilePictureSmall = [user objectForKey:kUserProfilePicSmallKey];
//    [self.avatarImageView setFile:profilePictureSmall];
//    
//    //turn photo to circle
//    CALayer *imageLayer = self.avatarImageView.layer;
//    [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
//    [imageLayer setBorderWidth:0];
//    [imageLayer setMasksToBounds:YES];
//    
//    
//    NSString *authorName = [user objectForKey:kUserDisplayNameKey];
//    [self.userButton setTitle:authorName forState:UIControlStateNormal];
//
//    if (self.activity && self.activeplayer && self.likeUsers) {
//        //[self createView];
//        [self setNeedsDisplay];
//    }
}

- (void)setLikeUsers:(NSMutableArray *)anArray {
    likeUsers = [anArray sortedArrayUsingComparator:^NSComparisonResult(PFUser *liker1, PFUser *liker2) {
        NSString *displayName1 = [liker1 objectForKey:kUserDisplayNameKey];
        NSString *displayName2 = [liker2 objectForKey:kUserDisplayNameKey];
        
        if ([[liker1 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedAscending;
        } else if ([[liker2 objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            return NSOrderedDescending;
        }
        
        return [displayName1 compare:displayName2 options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    }];;
    
    for (ProfileImageView *image in currentLikeAvatars) {
        [image removeFromSuperview];
    }
    
    [likeButton setTitle:[NSString stringWithFormat:@"%d", self.likeUsers.count] forState:UIControlStateNormal];
    
    self.currentLikeAvatars = [[NSMutableArray alloc] initWithCapacity:likeUsers.count];
    int i;
    int numOfPics = numLikePics > self.likeUsers.count ? self.likeUsers.count : numLikePics;
    
    for (i = 0; i < numOfPics; i++) {
        ProfileImageView *profilePic = [[ProfileImageView alloc] init];
        [profilePic setFrame:CGRectMake(likeProfileXBase + i * (likeProfileXSpace + likeProfileDim), likeProfileY, likeProfileDim, likeProfileDim)];
        [profilePic.profileButton addTarget:self action:@selector(didTapLikerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        profilePic.profileButton.tag = i;
        [profilePic setFile:[[self.likeUsers objectAtIndex:i] objectForKey:kUserProfilePicSmallKey]];
        [likeBarView addSubview:profilePic];
        [currentLikeAvatars addObject:profilePic];
    }
    
    [self setNeedsDisplay];
}

- (void)setLikeButtonState:(BOOL)selected {
//    if (selected) {
//        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( -1.0f, 0.0f, 0.0f, 0.0f)];
//        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, -1.0f)];
//    } else {
//        [likeButton setTitleEdgeInsets:UIEdgeInsetsMake( 0.0f, 0.0f, 0.0f, 0.0f)];
//        [[likeButton titleLabel] setShadowOffset:CGSizeMake( 0.0f, 1.0f)];
//    }
    [likeButton setSelected:selected];
}

- (void)reloadLikeBar {
    self.likeUsers = [[Cache sharedCache] likersForActivity:self.activity];
    [self setLikeButtonState:[[Cache sharedCache] isActivityLikedByCurrentUser:self.activity]];
    [likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ()

//- (void)createView {
//
//    
//    self.ActivityLabel.text = [NSString stringWithFormat:@"Scored %@ points",[self.activity objectForKey:kActivityKey]];
//
//    /*
//     Create top of header view with name and avatar
//     */
////    self.nameHeaderView = [[UIView alloc] initWithFrame:CGRectMake(nameHeaderX, nameHeaderY, nameHeaderWidth, nameHeaderHeight)];
////    self.nameHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]];
////    [self addSubview:self.nameHeaderView];
////    
////    CALayer *layer = self.nameHeaderView.layer;
////    layer.backgroundColor = [UIColor whiteColor].CGColor;
////    layer.masksToBounds = NO;
////    layer.shadowRadius = 1.0f;
////    layer.shadowOffset = CGSizeMake( 0.0f, 2.0f);
////    layer.shadowOpacity = 0.5f;
////    layer.shouldRasterize = YES;
////    
////    layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake( 0.0f, self.nameHeaderView.frame.size.height - 4.0f, self.nameHeaderView.frame.size.width, 4.0f)].CGPath;
//
//    
//    // Load data for header
//    [self.activeplayer fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        // Create avatar view
//        ProfileImageView *avatarImageView = [[ProfileImageView alloc] initWithFrame:CGRectMake(avatarImageX, avatarImageY, avatarImageDim, avatarImageDim)];
//        [avatarImageView setFile:[self.activeplayer objectForKey:kUserProfilePicSmallKey]];
////        [avatarImageView setBackgroundColor:[UIColor clearColor]];
////        [avatarImageView setOpaque:NO];
//        [avatarImageView.profileButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        //[nameHeaderView addSubview:avatarImageView];
//        
//        // Create name label
//        NSString *nameString = [self.activeplayer objectForKey:kUserDisplayNameKey];
////        UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
////        UIButton *userButton = self.userButton;
//        [self.userButton setTitle:nameString forState:UIControlStateNormal];
////        [nameHeaderView addSubview:userButton];
////        [userButton setBackgroundColor:[UIColor clearColor]];
////        [[userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];
////        [userButton setTitle:nameString forState:UIControlStateNormal];
////        [userButton setTitleColor:[UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
////        [userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
////        [[userButton titleLabel] setLineBreakMode:NSLineBreakByTruncatingTail];
////        [[userButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
////        [userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
//        [self.userButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        // we resize the button to fit the user's name to avoid having a huge touch area  boundingRectWithSize:options:attributes:context:
////        CGPoint userButtonPoint = CGPointMake(50.0f, 6.0f);
////        CGFloat constrainWidth = self.nameHeaderView.bounds.size.width - (avatarImageView.bounds.origin.x + avatarImageView.bounds.size.width);
////        CGSize constrainSize = CGSizeMake(constrainWidth, self.nameHeaderView.bounds.size.height - userButtonPoint.y*2.0f);
////        CGSize userButtonSize = [userButton.titleLabel.text sizeWithFont:userButton.titleLabel.font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByTruncatingTail];
////       
////        
////        CGRect userButtonFrame = CGRectMake(userButtonPoint.x, userButtonPoint.y, userButtonSize.width, userButtonSize.height);
////        [userButton setFrame:userButtonFrame];
//        
//        // Create time label
//        NSString *timeString = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[self.activity createdAt]];
////        CGSize timeLabelSize = [timeString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(nameLabelMaxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByTruncatingTail];
////        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabelX, nameLabelY+userButtonSize.height, timeLabelSize.width, timeLabelSize.height)];
////        UILabel * timeLabel = self.timeLabel;
//        
//        
//        [self.timeLabel setText:timeString];
//        
//        
////        [timeLabel setFont:[UIFont systemFontOfSize:11.0f]];
////        [timeLabel setTextColor:[UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f]];
////        [timeLabel setShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f]];
////        [timeLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
////        [timeLabel setBackgroundColor:[UIColor clearColor]];
////        [self.nameHeaderView addSubview:timeLabel];
//        
//        [self setNeedsDisplay];
//    }];
//    
//    /*
//     Create bottom section fo the header view; the likes
//     */
//    
////    likeBarView = [[UIView alloc] initWithFrame:CGRectMake(likeBarX, likeBarY, likeBarWidth, likeBarHeight)];
////    [likeBarView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
////    [self addSubview:likeBarView];
//    
//    // Create the heart-shaped like button
//    //likeButton = self.likeButton;
////    [likeButton setFrame:CGRectMake(likeButtonX, likeButtonY, likeButtonDim, likeButtonDim)];
////    [likeButton setBackgroundColor:[UIColor clearColor]];
////    [likeButton setTitleColor:[UIColor colorWithRed:0.369f green:0.271f blue:0.176f alpha:1.0f] forState:UIControlStateNormal];
////    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
////    [likeButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
////    [likeButton setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.750f] forState:UIControlStateSelected];
////    [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
////    [[likeButton titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
////    [[likeButton titleLabel] setMinimumScaleFactor:11.0f];
////    [[likeButton titleLabel] setAdjustsFontSizeToFitWidth:YES];
////    [[likeButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
////    [likeButton setAdjustsImageWhenDisabled:NO];
////    [likeButton setAdjustsImageWhenHighlighted:NO];
////    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLike.png"] forState:UIControlStateNormal];
////    [likeButton setBackgroundImage:[UIImage imageNamed:@"ButtonLikeSelected.png"] forState:UIControlStateSelected];
////    [likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    [likeBarView addSubview:likeButton];
//    
//    [self.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    
//    [self reloadLikeBar];
//    
////    UIImageView *separator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f)]];
////    [separator setFrame:CGRectMake(0.0f, likeBarView.frame.size.height - 2.0f, likeBarView.frame.size.width, 2.0f)];
////    [likeBarView addSubview:separator];
//    
//    
//    }

- (void)didTapLikeActivityButtonAction:(UIButton *)button {
    BOOL liked = !button.selected;
    [button removeTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setLikeButtonState:liked];
    
    NSArray *originalLikeUsersArray = [NSArray arrayWithArray:self.likeUsers];
    NSMutableSet *newLikeUsersSet = [NSMutableSet setWithCapacity:[self.likeUsers count]];
    
    for (PFUser *likeUser in self.likeUsers) {
        // add all current likeUsers BUT currentUser
        if (![[likeUser objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            [newLikeUsersSet addObject:likeUser];
        }
    }
    
    if (liked) {
        [[Cache sharedCache] incrementLikerCountForActivity:self.activity];
        [newLikeUsersSet addObject:[PFUser currentUser]];
    } else {
        [[Cache sharedCache] decrementLikerCountForActivity:self.activity];
    }
    
    [[Cache sharedCache] setActivityIsLikedByCurrentUser:self.activity liked:liked];
    
    [self setLikeUsers:[newLikeUsersSet allObjects]];
    
    if (liked) {
        [Utility likeActivityInBackground:self.activity block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [button addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self setLikeUsers:originalLikeUsersArray];
                [self setLikeButtonState:NO];
            }
        }];
    } else {
        [Utility unlikeActivityInBackground:self.activity block:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                [button addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self setLikeUsers:originalLikeUsersArray];
                [self setLikeButtonState:YES];
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ActivityDetailsViewControllerUserLikedUnlikedActivityNotification object:self.activity userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:liked] forKey:ActivityDetailsViewControllerUserLikedUnlikedActivityNotificationUserInfoLikedKey]];
}

- (void)didTapLikerButtonAction:(UIButton *)button {
    PFUser *user = [self.likeUsers objectAtIndex:button.tag];
    
    
    [self reloadLikeBar];
    if (delegate && [delegate respondsToSelector:@selector(activityDetailsHeaderCell:didTapUserButton:user:)]) {
        [delegate activityDetailsHeaderCell:self didTapUserButton:button user:user];
    }
}



- (void)didTapUserNameButtonAction:(UIButton *)button {
    if (delegate && [delegate respondsToSelector:@selector(activityDetailsHeaderCell:didTapUserButton:user:)]) {
        [delegate activityDetailsHeaderCell:self didTapUserButton:button user:self.activeplayer];
    }    
}



@end
