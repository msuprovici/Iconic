//
//  UserManager.h
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFUser;
@class LYRConversation;

@interface UserManager : NSObject

+ (instancetype)sharedManager;

///-------------------------
/// @name Querying for Users
///-------------------------

- (void)queryForUserWithName:(NSString *)searchText completion:(void (^)(NSArray *participants, NSError *error))completion;

- (void)queryForAllUsersWithCompletion:(void (^)(NSArray *users, NSError *error))completion;

///---------------------------
/// @name Accessing User Cache
///---------------------------

- (void)queryAndCacheUsersWithIDs:(NSArray *)userIDs completion:(void (^)(NSArray *participants, NSError *error))completion;

- (PFUser *)cachedUserForUserID:(NSString *)userID;

- (void)cacheUserIfNeeded:(PFUser *)user;

- (NSArray *)unCachedUserIDsFromParticipants:(NSArray *)participants;

- (NSArray *)resolvedNamesFromParticipants:(NSArray *)participants;


@end
