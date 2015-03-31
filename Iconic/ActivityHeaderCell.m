//
//  ActivityHeaderCell.m
//  Iconic
//
//  Created by Mike Suprovici on 1/14/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import "ActivityHeaderCell.h"
#import "Constants.h"
#import "PlayerProfileViewController.h"
#import "TeamPlayersViewController.h"
#import "FeedViewController.h"

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
    
    [self.activityStatusTextView setTextColor:[UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]];
    [self.activityStatusTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    
    //show user in feed
    

    if ([activity objectForKey:@"user"]) {
       
        self.userSelectedButton.enabled = YES;
        self.userSelectedButton.hidden = NO;
        self.teamSelectedButton.enabled = NO;
        self.teamSelectedButton.hidden = YES;
    
    
    // user's avatar
    PFUser *user = [activity objectForKey:kActivityUserKey];
   
    // Set a placeholder image first
    self.avatarImageView.image = [UIImage imageNamed:@"empty_avatar.png"];
    self.avatarImageView.file = (PFFile *)user[kUserProfilePicSmallKey];
//    PFFile *imageFile = [user objectForKey:kUserProfilePicSmallKey];
    [self.avatarImageView loadInBackground];
//    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        // Now that the data is fetched, update the cell's image property.
//        self.avatarImageView.image = [UIImage imageWithData:data];
//
//    }];
    
        //turn photo to circle
        CALayer *imageLayer = self.avatarImageView.layer;
        [imageLayer setCornerRadius:self.avatarImageView.frame.size.width/2];
        [imageLayer setBorderWidth:0];
        [imageLayer setMasksToBounds:YES];
    
    
    NSString *authorName = [user objectForKey:kUserDisplayNameKey];
    [self.userButton setTitle:authorName forState:UIControlStateNormal];
   
    [self.userButton addTarget:self action:@selector(didTapUserButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.commentButton addTarget:self action:@selector(didTapCommentOnActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.likeButton addTarget:self action:@selector(didTapLikeActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.likeButton.hidden = NO;
        self.commentButton.hidden = NO;
        self.likeCount.hidden = NO;
        self.commentCount.hidden = NO;

    }
    
    else
    {
        
        self.userSelectedButton.enabled = NO;
        self.userSelectedButton.hidden = YES;
        self.teamSelectedButton.enabled = YES;
        self.teamSelectedButton.hidden = NO;
        
        // user's avatar
        [activity fetchIfNeededInBackground];
        PFObject *team = [activity objectForKey:@"team"];


        // Set a placeholder image first
        self.avatarImageView.image = [UIImage imageNamed:@"team2.png"];
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
        
        
        //hiding buttons because current archiecture does not allow for likes & comments on team activity, just user activity.
        self.likeButton.hidden = YES;
        self.commentButton.hidden = YES;
        self.likeCount.hidden = YES;
        self.commentCount.hidden = YES;
        



    }
        
    
        //determine what word was tapped by the user
        //if user - segue to user profile, if team segue to team, if league segue to league...
        [self.activityStatusTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(didReceiveGestureOnText:)]];
    

}




-(void)didReceiveGestureOnText:(UITapGestureRecognizer*)recognizer
{
    //determine the pressed word
    NSString* pressedWord = [self getPressedWordWithRecognizer:recognizer];
//    NSLog(@"%@", pressedWord);
    

    PFUser *user = [activity objectForKey:@"toUser"];
    NSString * userName = [user objectForKey:@"username"];
    
    PFObject *team = [activity objectForKey:@"toTeam"];
    NSString * teamName = [team objectForKey:@"teams"];

    
    PFObject *league = [activity objectForKey:@"league"];
    NSString * leagueName = [league objectForKey:@"league"];
    
    
    
    if([pressedWord isEqualToString:userName])
    {
//        NSLog(@"%@", userName);
        NSDictionary* toUser = @{@"user": user};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"selectedUserName" object:self userInfo:toUser];
        
    }
    
    else if([pressedWord isEqualToString:teamName])
    {
//        NSLog(@"%@", teamName);
        NSDictionary* teamObject = @{@"team": team};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"selectedTeamName" object:self userInfo:teamObject];
        
    }

    else if([pressedWord isEqualToString:leagueName])
    {
//        NSLog(@"%@", leagueName);
        NSDictionary* leagueObject = @{@"league": league};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"selectedLeagueName" object:self userInfo:leagueObject];
        
    }


}

-(NSString*)getPressedWordWithRecognizer:(UIGestureRecognizer*)recognizer
{
    //get view
//    UITextView *textView = (UITextView *)recognizer.view;
    //get location
    CGPoint location = [recognizer locationInView:self.activityStatusTextView];
    UITextPosition *tapPosition = [self.activityStatusTextView closestPositionToPoint:location];
    UITextRange *textRange = [self.activityStatusTextView.tokenizer rangeEnclosingPosition:tapPosition withGranularity:UITextGranularityWord inDirection:UITextLayoutDirectionRight];
    
    //return string
    return [self.activityStatusTextView textInRange:textRange];
}


//dismisses 'copy menu'
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.activityStatusTextView resignFirstResponder];
}


- (void)setLikeStatus:(BOOL)liked {
    [self.likeButton setSelected:liked];
//    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"hi-five-icon_edit2.png"] forState:UIControlStateSelected];
    
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
