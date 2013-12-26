//
//  Cache.m
//  Iconic
//
//  Created by Mike Suprovici on 12/23/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "Cache.h"
#import "Constants.h"

@interface Cache()

@property (nonatomic, strong) NSCache *cache;

- (void)setAttributes:(NSDictionary *)attributes forActivity:(PFObject *)activity;

@end

@implementation Cache

@synthesize cache;


#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - Cache

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)setAttributesForActivity:(PFObject *)activity likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:likedByCurrentUser],kActivityAttributesIsLikedByCurrentUserKey,
                                [NSNumber numberWithInt:[likers count]],kActivityAttributesLikeCountKey,
                                likers,kActivityAttributesLikersKey,
                                [NSNumber numberWithInt:[commenters count]],kActivityAttributesCommentCountKey,
                                commenters,kActivityAttributesCommentersKey,
                                nil];
    [self setAttributes:attributes forActivity:activity];
}

- (NSDictionary *)attributesForActivity:(PFObject *)activity {
    NSString *key = [self keyForActivity:activity];
    return [self.cache objectForKey:key];
}

- (NSNumber *)likeCountForActivity:(PFObject *)activity {
    NSDictionary *attributes = [self attributesForActivity:activity];
    if (attributes) {
        return [attributes objectForKey:kActivityAttributesLikeCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForActivity:(PFObject *)activity {
    NSDictionary *attributes = [self attributesForActivity:activity];
    if (attributes) {
        return [attributes objectForKey:kActivityAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForActivity:(PFObject *)activity {
    NSDictionary *attributes = [self attributesForActivity:activity];
    if (attributes) {
        return [attributes objectForKey:kActivityAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForActivity:(PFObject *)activity {
    NSDictionary *attributes = [self attributesForActivity:activity];
    if (attributes) {
        return [attributes objectForKey:kActivityAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setActivityIsLikedByCurrentUser:(PFObject *)activity liked:(BOOL)liked {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForActivity:activity]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kActivityAttributesIsLikedByCurrentUserKey];
    [self setAttributes:attributes forActivity:activity];
}

- (BOOL)isActivityLikedByCurrentUser:(PFObject *)activity {
    NSDictionary *attributes = [self attributesForActivity:activity];
    if (attributes) {
        return [[attributes objectForKey:kActivityAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikerCountForActivity:(PFObject *)activity{
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForActivity:activity] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForActivity:activity]];
    [attributes setObject:likerCount forKey:kActivityAttributesLikeCountKey];
    [self setAttributes:attributes forActivity:activity];
}

- (void)decrementLikerCountForActivity:(PFObject *)activity {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForActivity:activity] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForActivity:activity]];
    [attributes setObject:likerCount forKey:kActivityAttributesLikeCountKey];
    [self setAttributes:attributes forActivity:activity];
}

- (void)incrementCommentCountForActivity:(PFObject *)activity {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForActivity:activity] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForActivity:activity]];
    [attributes setObject:commentCount forKey:kActivityAttributesCommentCountKey];
    [self setAttributes:attributes forActivity:activity];
}

- (void)decrementCommentCountForActivity:(PFObject *)activity {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForActivity:activity] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForActivity:activity]];
    [attributes setObject:commentCount forKey:kActivityAttributesCommentCountKey];
    [self setAttributes:attributes forActivity:activity];
}

- (void)setAttributesForUser:(PFUser *)user activityCount:(NSNumber *)count followedByCurrentUser:(BOOL)following {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,kUserAttributesActivityCountKey,
                                [NSNumber numberWithBool:following],kUserAttributesIsFollowedByCurrentUserKey,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)activityCountForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *activityCount = [attributes objectForKey:kUserAttributesActivityCountKey];
        if (activityCount) {
            return activityCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }
    
    return NO;
}

- (void)setActivityCount:(NSNumber *)count user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kUserAttributesActivityCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends {
    NSString *key = kUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends {
    NSString *key = kUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends) {
        [self.cache setObject:friends forKey:key];
    }
    
    return friends;
}


#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forActivity:(PFObject *)activity {
    NSString *key = [self keyForActivity:activity];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForActivity:(PFObject *)activity {
    return [NSString stringWithFormat:@"photo_%@", [activity objectId]];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}


@end
