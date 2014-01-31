//
//  Utility.m
//  Iconic
//
//  Created by Mike Suprovici on 12/26/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//



#import "Utility.h"
#import "Cache.h"
#import "Constants.h"
#import "UIImage+ResizeAdditions.h"


@implementation Utility


#pragma mark - Utility
#pragma mark Like Activities

+ (void)likeActivityInBackground:(id)activity block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [queryExistingLikes whereKey:kPlayerActionActivityKey equalTo:activity];
    [queryExistingLikes whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeLike];
    [queryExistingLikes whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *playeraction in activities) {
                [playeraction deleteInBackground];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kPlayerActionClassKey];
        [likeActivity setObject:kPlayerActionTypeLike forKey:kPlayerActionTypeKey];
        [likeActivity setObject:[PFUser currentUser] forKey:kPlayerActionFromUserKey];
        [likeActivity setObject:[activity objectForKey:kActivityUserKey] forKey:kPlayerActionToUserKey];
        [likeActivity setObject:activity forKey:kPlayerActionActivityKey];
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[activity objectForKey:kActivityUserKey]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            // refresh cache
            PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike] && [activity objectForKey:kPlayerActionFromUserKey]) {
                            [likers addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                        } else if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeComment] && [activity objectForKey:kPlayerActionFromUserKey]) {
                            [commenters addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[Cache sharedCache] setAttributesForActivity:activity likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:activity userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:ActivityDetailsViewControllerUserLikedUnlikedActivityNotification]];
            }];
            
        }];
    }];
    
}

+ (void)unlikeActivityInBackground:(id)activity block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [queryExistingLikes whereKey:kPlayerActionActivityKey equalTo:activity];
    [queryExistingLikes whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeLike];
    [queryExistingLikes whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *playeraction in activities) {
                [playeraction deleteInBackground];
            }
            
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
            // refresh cache
            PFQuery *query = [Utility queryForActivitiesOnActivity:activity cachePolicy:kPFCachePolicyNetworkOnly];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    NSMutableArray *likers = [NSMutableArray array];
                    NSMutableArray *commenters = [NSMutableArray array];
                    
                    BOOL isLikedByCurrentUser = NO;
                    
                    for (PFObject *activity in objects) {
                        if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
                            [likers addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                        } else if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeComment]) {
                            [commenters addObject:[activity objectForKey:kPlayerActionFromUserKey]];
                        }
                        
                        if ([[[activity objectForKey:kPlayerActionFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                            if ([[activity objectForKey:kPlayerActionTypeKey] isEqualToString:kPlayerActionTypeLike]) {
                                isLikedByCurrentUser = YES;
                            }
                        }
                    }
                    
                    [[Cache sharedCache] setAttributesForActivity:activity likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UtilityUserLikedUnlikedActivityCallbackFinishedNotification object:activity userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:ActivityDetailsViewControllerUserLikedUnlikedActivityNotificationUserInfoLikedKey]];
            }];
            
        } else {
            if (completionBlock) {
                completionBlock(NO,error);
            }
        }
    }];
}


#pragma mark Facebook

+ (void)processFacebookProfilePictureData:(NSData *)newProfilePictureData {
    if (newProfilePictureData.length == 0) {
        return;
    }
    
    // The user's Facebook profile picture is cached to disk. Check if the cached profile picture data matches the incoming profile picture. If it does, avoid uploading this data to Parse.
    
    NSURL *cachesDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]; // iOS Caches directory
    
    NSURL *profilePictureCacheURL = [cachesDirectoryURL URLByAppendingPathComponent:@"FacebookProfilePicture.jpg"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[profilePictureCacheURL path]]) {
        // We have a cached Facebook profile picture
        
        NSData *oldProfilePictureData = [NSData dataWithContentsOfFile:[profilePictureCacheURL path]];
        
        if ([oldProfilePictureData isEqualToData:newProfilePictureData]) {
            return;
        }
    }
    
    UIImage *image = [UIImage imageWithData:newProfilePictureData];
    
    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
    
    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithData:mediumImageData];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileMediumImage forKey:kUserProfilePicMediumKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
    
    if (smallRoundedImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithData:smallRoundedImageData];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [[PFUser currentUser] setObject:fileSmallRoundedImage forKey:kUserProfilePicSmallKey];
                [[PFUser currentUser] saveEventually];
            }
        }];
    }
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user {
    NSString *facebookId = [user objectForKey:kUserFacebookIDKey];
    return (facebookId && facebookId.length > 0);
}

+ (BOOL)userHasProfilePictures:(PFUser *)user {
    PFFile *profilePictureMedium = [user objectForKey:kUserProfilePicMediumKey];
    PFFile *profilePictureSmall = [user objectForKey:kUserProfilePicSmallKey];
    
    return (profilePictureMedium && profilePictureSmall);
}


#pragma mark Display Name

+ (NSString *)firstNameForDisplayName:(NSString *)displayName {
    if (!displayName || displayName.length == 0) {
        return @"Someone";
    }
    
    NSArray *displayNameComponents = [displayName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [displayNameComponents objectAtIndex:0];
    if (firstName.length > 100) {
        // truncate to 100 so that it fits in a Push payload
        firstName = [firstName substringToIndex:100];
    }
    return firstName;
}


#pragma mark User Following

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPlayerActionClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPlayerActionFromUserKey];
    [followActivity setObject:user forKey:kPlayerActionToUserKey];
    [followActivity setObject:kPlayerActionTypeFollow forKey:kPlayerActionTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[Cache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPlayerActionClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPlayerActionFromUserKey];
    [followActivity setObject:user forKey:kPlayerActionToUserKey];
    [followActivity setObject:kPlayerActionTypeFollow forKey:kPlayerActionTypeKey];
    
    PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [followACL setPublicReadAccess:YES];
    followActivity.ACL = followACL;
    
    [followActivity saveEventually:completionBlock];
    [[Cache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    for (PFUser *user in users) {
        [Utility followUserEventually:user block:completionBlock];
        [[Cache sharedCache] setFollowStatus:YES user:user];
    }
}

+ (void)unfollowUserEventually:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [query whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPlayerActionToUserKey equalTo:user];
    [query whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    NSLog(@"player unfollowed");
    [[Cache sharedCache] setFollowStatus:NO user:user];
}

+ (void)unfollowUsersEventually:(NSArray *)users {
    PFQuery *query = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [query whereKey:kPlayerActionFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPlayerActionToUserKey containedIn:users];
    [query whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        for (PFObject *activity in activities) {
            [activity deleteEventually];
        }
    }];
    for (PFUser *user in users) {
        [[Cache sharedCache] setFollowStatus:NO user:user];
    }
}


#pragma mark Activities

+ (PFQuery *)queryForActivitiesOnActivity:(PFObject *)activity cachePolicy:(PFCachePolicy)cachePolicy {
    PFQuery *queryLikes = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [queryLikes whereKey:kPlayerActionActivityKey equalTo:activity];
    [queryLikes whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeLike];
    
    PFQuery *queryComments = [PFQuery queryWithClassName:kPlayerActionClassKey];
    [queryComments whereKey:kPlayerActionActivityKey equalTo:activity];
    [queryComments whereKey:kPlayerActionTypeKey equalTo:kPlayerActionTypeComment];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryLikes,queryComments,nil]];
    [query setCachePolicy:cachePolicy];
    [query includeKey:kPlayerActionFromUserKey];
    [query includeKey:kPlayerActionActivityKey];
    
    return query;
}

#pragma mark Points Algorithm


-(float)calculatePoints:(float)steps
{
    
    //alogrithm for calcuating steps: yourPoints = ((0.75^( ln(steps) /ln (2)))/time)*steps*constantValue
    
    return ((pow(0.85, ((log(steps)/log(2))))/20) * steps * 50);
    

}


@end
