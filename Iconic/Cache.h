//
//  Cache.h
//  Iconic
//
//  Created by Mike Suprovici on 12/23/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Cache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForActivity:(PFObject *)activity likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)attributesForActivity:(PFObject *)activity;
- (NSNumber *)likeCountForActivity:(PFObject *)activity;
- (NSNumber *)commentCountForActivity:(PFObject *)activity;
- (NSArray *)likersForActivity:(PFObject *)activity;
- (NSArray *)commentersForActivity:(PFObject *)activity;
- (void)setActivityIsLikedByCurrentUser:(PFObject *)activity liked:(BOOL)liked;
- (BOOL)isActivityLikedByCurrentUser:(PFObject *)activity;
- (void)incrementLikerCountForActivity:(PFObject *)activity;
- (void)decrementLikerCountForActivity:(PFObject *)activity;
- (void)incrementCommentCountForActivity:(PFObject *)activity;
- (void)decrementCommentCountForActivity:(PFObject *)activity;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)activityCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setActivityCount:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;


@end
