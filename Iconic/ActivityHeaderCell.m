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
    
    
    //show user in feed
    

    if ([activity objectForKey:@"user"]) {
       
        self.userSelectedButton.enabled = YES;
        self.userSelectedButton.hidden = NO;
        self.teamSelectedButton.enabled = NO;
        self.teamSelectedButton.hidden = YES;
    
    
    // user's avatar
    PFUser *user = [activity objectForKey:kActivityUserKey];
    //PFFile *profilePictureSmall = [user objectForKey:kUserProfilePicSmallKey];
    

  
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
        
//        self.activityStatusTextView = [[UITextView alloc] init];
        
//        UITextPosition *Pos2 = [self.activityStatusTextView positionFromPosition: self.activityStatusTextView.endOfDocument offset: 0];
//        
//        UITextPosition *Pos1 = [self.activityStatusTextView positionFromPosition: self.activityStatusTextView.endOfDocument offset: -3];
//        
//        UITextRange *range = [self.activityStatusTextView textRangeFromPosition:Pos1 toPosition:Pos2];
//        
//        CGRect result1 = [self.activityStatusTextView firstRectForRange:(UITextRange *)range ];
//        
//        NSLog(@"%f, %f", result1.origin.x, result1.origin.y);
//        
//        
//        //button to test
//        UIButton *selectFollowedUserOrTeam =  [UIButton buttonWithType:UIButtonTypeSystem];
//        selectFollowedUserOrTeam.frame = result1;
////        selectFollowedUserOrTeam.backgroundColor = [UIColor clearColor];
//        selectFollowedUserOrTeam.backgroundColor = [UIColor blueColor];
//        [self.activityStatusTextView addSubview:selectFollowedUserOrTeam];
//        
//        
//        //view to test
//        UIView *view1 = [[UIView alloc] initWithFrame:result1];
//        view1.backgroundColor = [UIColor colorWithRed:0.2f green:0.5f blue:0.2f alpha:0.4f];
//        [self.activityStatusTextView addSubview:view1];
//        
        
//        NSRange range=self.activityStatusTextView.selectedRange;
//        [self.activityStatusTextView.text enumerateSubstringsInRange:NSMakeRange(0, [self.activityStatusTextView.text length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
//            NSRange intersectionRange=NSIntersectionRange(range,wordRange);
//            if(intersectionRange.length>0){
//                [self.activityStatusTextView setSelectedRange:wordRange];
//            }
//        }];


    }
        
    
//    - (void)textViewDidChangeSelection:(UITextView *)textView{
//        NSRange range=textView.selectedRange;
//        [textView.text enumerateSubstringsInRange:NSMakeRange(0, [textView.text length]) options:NSStringEnumerationByWords usingBlock:^(NSString* word, NSRange wordRange, NSRange enclosingRange, BOOL* stop){
//            NSRange intersectionRange=NSIntersectionRange(range,wordRange);
//            if(interesectionRange.length>0){
//                [textView setSelectedRange:wordRange];
//            }
//        }];
//    }
    
    
    
    
    
    
        
        
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
    
//    NSMutableAttributedString *paragraph = [[NSMutableAttributedString alloc] initWithString:@"We lost the " attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
//    
//    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:@"lead" attributes:@{ @"myCustomTag" : @(YES) }];
//    [paragraph appendAttributedString:attributedString];
    
    [self.activityStatusTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(didReceiveGestureOnText:)]];
    

}


-(void)didReceiveGestureOnText:(UITapGestureRecognizer*)recognizer
{
    //check if this is actual user
    NSString* pressedWord = [self getPressedWordWithRecognizer:recognizer];
    NSLog(@"%@", pressedWord);
    
    PFUser *user = [activity objectForKey:kActivityUserKey];
    NSString * userName = [user objectForKey:@"username"];
    
//    if([pressedWord isEqualToString:userName])
//    {
//    
////    FeedViewController * feedViewController = [[FeedViewController alloc]init];
////    
////    [feedViewController performSegueWithIdentifier:@"FeedToPlayerSegue" sender:self];
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"Achievment"];
//        
//        [(UINavigationController*)self.window.rootViewController presentViewController:ivc animated:YES completion:nil];
//    }

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
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"hi-five-icon_edit2.png"] forState:UIControlStateSelected];
    
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
