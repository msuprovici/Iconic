//
//  Constants.m
//  Iconic
//
//  Created by Mike Suprovici on 12/26/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "Constants.h"

NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.stickyplay.Iconic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kUserDefaultsCacheFacebookFriendsKey                     = @"com.stickyplay.Iconic.userDefaults.cache.facebookFriends";


#pragma mark - Launch URLs

NSString *const kLaunchURLHostLoadActivity = @"camera";// <- define
// player physical activity keys

#pragma mark - Player Physical Activity Points

NSString *const kPhysicalActivityClass = @"Test";

NSString *const kPlayerPoints = @"points";
NSString *const kPlayerXP = @"playerXP";
NSString *const kPlayerSteps = @"playerSteps";


#pragma mark - NSNotification

NSString *const AppDelegateApplicationDidReceiveRemoteNotification           = @"com.stickyplay.Iconic.appDelegate.applicationDidReceiveRemoteNotification";
NSString *const UtilityUserFollowingChangedNotification                      = @"com.stickyplay.Iconic.utility.userFollowingChanged";
NSString *const UtilityUserLikedUnlikedActivityCallbackFinishedNotification     = @"com.stickyplay.Iconic.utility.userLikedUnlikedPhotoCallbackFinished";
NSString *const UtilityDidFinishProcessingProfilePictureNotification         = @"com.stickyplay.Iconic.utility.didFinishProcessingProfilePictureNotification";

//be carefull with the naming here - we currently don't have a TabBarController
NSString *const TabBarControllerDidFinishEditingActivityNotification            = @"com.stickyplay.Iconic.tabBarController.didFinishEditingPhoto";
NSString *const TabBarControllerDidFinishActivityUploadNotification         = @"com.stickyplay.Iconic.tabBarController.didFinishImageFileUploadNotification";

NSString *const ActivityDetailsViewControllerUserDeletedActivityNotification       = @"com.stickyplay.Iconic.photoDetailsViewController.userDeletedPhoto";
NSString *const ActivityDetailsViewControllerUserLikedUnlikedActivityNotification  = @"com.stickyplay.Iconic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification";
NSString *const ActivityDetailsViewControllerUserCommentedOnActivityNotification   = @"com.stickyplay.Iconic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification";


#pragma mark - User Info Keys
NSString *const ActivityDetailsViewControllerUserLikedUnlikedActivityNotificationUserInfoLikedKey = @"liked";
NSString *const kEditActivityViewControllerUserInfoCommentKey = @"comment";

#pragma mark - Installation Class

// Field keys
NSString *const kInstallationUserKey = @"user";

#pragma mark - Activity Class
// Class key
NSString *const kPlayerActionClassKey = @"PlayerAction";

// Field keys
NSString *const kPlayerActionTypeKey        = @"type";
NSString *const kPlayerActionFromUserKey    = @"fromUser";
NSString *const kPlayerActionToUserKey      = @"toUser";
NSString *const kPlayerActionContentKey     = @"content";
NSString *const kPlayerActionActivityKey       = @"activity";

// Type values
NSString *const kPlayerActionTypeLike       = @"like";
NSString *const kPlayerActionTypeFollow     = @"follow";
NSString *const kPlayerActionTypeComment    = @"comment";
NSString *const kPlayerActionTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kUserDisplayNameKey                          = @"displayName";
NSString *const kUserFacebookIDKey                           = @"facebookId";
NSString *const kUserActivityIDKey                              = @"photoId";
NSString *const kUserProfilePicSmallKey                      = @"profilePictureSmall";
NSString *const kUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";

#pragma mark - Activity Class
// Class key
NSString *const kActivityClassKey = @"Photo";// <-careful, make sure to set the right class here

// Field keys
NSString *const kActivityKey         = @"image";
//NSString *const kPhotoThumbnailKey       = @"thumbnail";
NSString *const kActivityUserKey            = @"user";
NSString *const kActivityOpenGraphIDKey    = @"fbOpenGraphID";


#pragma mark - Cached Photo Attributes
// keys
NSString *const kActivityAttributesIsLikedByCurrentUserKey = @"isLikedByCurrentUser";
NSString *const kActivityAttributesLikeCountKey            = @"likeCount";
NSString *const kActivityAttributesLikersKey               = @"likers";
NSString *const kActivityAttributesCommentCountKey         = @"commentCount";
NSString *const kActivityAttributesCommentersKey           = @"commenters";


#pragma mark - Cached User Attributes
// keys
NSString *const kUserAttributesActivityCountKey                 = @"photoCount";
NSString *const kUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";


#pragma mark - Push Notification Payload Keys

NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kPushPayloadPayloadTypeKey          = @"p";
NSString *const kPushPayloadPayloadTypeActivityKey  = @"a";

NSString *const kPushPayloadActivityTypeKey     = @"t";
NSString *const kPushPayloadActivityLikeKey     = @"l";
NSString *const kPushPayloadActivityCommentKey  = @"c";
NSString *const kPushPayloadActivityFollowKey   = @"f";

NSString *const kPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kPushPayloadPhotoObjectIdKey    = @"pid";



