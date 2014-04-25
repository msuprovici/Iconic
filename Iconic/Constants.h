//
//  Constants.h
//  Iconic
//
//  Created by Mike Suprovici on 12/26/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

// Define an array of Facebook Ids for accounts to auto-follow on signup
#define kAutoFollowAccountFacebookIds @[ ]


//table headers
#define HeaderColor PNWhite
#define HeaderTextColor PNDeepGrey
#define HeaderHeight    20
#define HeaderAlignment  NSTextAlignmentCenter
#define HeaderFont [UIFont boldSystemFontOfSize:17]

#pragma mark - NSUserDefaults
extern NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kUserDefaultsCacheFacebookFriendsKey;

#pragma mark - Launch URLs

extern NSString *const kLaunchURLHostLoadActivity;

#pragma mark - My Stats (NSUserDefaults)
//points
extern NSString *const kMyPointsToday;
extern NSString *const kMyPointsTotal;
extern NSString *const kMyPointsWeekArray;

extern NSString *const kMyFetchedPointsToday;
extern NSString *const kMyFetchedPointsTotal;
extern NSString *const kMyMostRecentFetchedPointsBeforeSaving;
//extern NSString *const kMyFetchedPointsWeekArray;

extern NSString *const kMyMostRecentPointsBeforeSaving;
extern NSString *const kMyMostRecentStepsBeforeSaving;
extern NSString *const kMyMostRecentTotalPointsBeforeSaving;

//team arrays
extern NSString *const kMyTeamDataArray;
extern NSString *const kMyMatchupsArray;
extern NSString *const kArrayOfAwayTeamPointers;
extern NSString *const kArrayOfHomeTeamPointers;
extern NSString *const kArrayOfHomeTeamScores;
extern NSString *const kArrayOfAwayTeamScores;
extern NSString *const kArrayOfAwayTeamNames;
extern NSString *const kArrayOfHomeTeamNames;



//step counting
extern NSString *const STEPS_KEY;
extern NSString *const kMyStepsWeekArray;
//test class
extern NSString *const kPhysicalActivityClass;

extern NSString *const kUser;
extern NSString *const kUsername;
extern NSString *const kProfilePicture;
extern NSString *const kPlayerTitle;
extern NSString *const kPlayerPoints;
extern NSString *const kPlayerPointsToday;
extern NSString *const kPlayerStepsWeek;
extern NSString *const kPlayerPointsWeek;
extern NSString *const kPlayerXP;
extern NSString *const kPlayerPointsToNextLevel;
extern NSString *const kPlayerSteps;

#pragma mark - NSNotification
extern NSString *const AppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const UtilityUserFollowingChangedNotification;
extern NSString *const UtilityUserLikedUnlikedActivityCallbackFinishedNotification;
extern NSString *const UtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const TabBarControllerDidFinishEditingActivityNotification;//<- define which viewcontroller
extern NSString *const TabBarControllerDidFinishActivityUploadNotification;//<- define which viewcontroller
extern NSString *const ActivityDetailsViewControllerUserDeletedActivityNotification;
extern NSString *const ActivityDetailsViewControllerUserLikedUnlikedActivityNotification;
extern NSString *const ActivityDetailsViewControllerUserCommentedOnActivityNotification;


#pragma mark - User Info Keys
extern NSString *const ActivityDetailsViewControllerUserLikedUnlikedActivityNotificationUserInfoLikedKey;
extern NSString *const kEditActivityViewControllerUserInfoCommentKey;


#pragma mark - Installation Class

// Field keys
extern NSString *const kInstallationUserKey;


#pragma mark - PFObject PlayerAction Class
// Class key
extern NSString *const kPlayerActionClassKey;

// Field keys
extern NSString *const kPlayerActionTypeKey;
extern NSString *const kPlayerActionFromUserKey;
extern NSString *const kPlayerActionToUserKey;
extern NSString *const kPlayerActionContentKey;
extern NSString *const kPlayerActionActivityKey;

// Type values
extern NSString *const kPlayerActionTypeLike;
extern NSString *const kPlayerActionTypeFollow;
extern NSString *const kPlayerActionTypeComment;
extern NSString *const kPlayerActionTypeJoined;


#pragma mark - PFObject User Class
// Field keys
extern NSString *const kUserDisplayNameKey;
extern NSString *const kUserFacebookIDKey;
extern NSString *const kUserActivityIDKey;
extern NSString *const kUserProfilePicSmallKey;
extern NSString *const kUserProfilePicMediumKey;
extern NSString *const kUserFacebookFriendsKey;
extern NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey;


#pragma mark - PFObject Activity Class
// Class key
extern NSString *const kActivityClassKey;

// Field keys
extern NSString *const kActivityKey;
//extern NSString *const kPhotoThumbnailKey;
extern NSString *const kActivityUserKey;
extern NSString *const kActivityOpenGraphIDKey;

#pragma mark - Timer Class
//Class key
NSString *const kTimerClass;

#pragma mark - Team Players Class
//Class key
NSString *const kTeamPlayersClass;

//Field keys
NSString *const kTeamate;
NSString *const kTeam;
NSString *const kTeamObjectIdString;
NSString *const kUserObjectIdString;

#pragma mark - Teams Class
//Class key
NSString *const kTeamTeamsClass;

//Field keys
NSString *const kTeams;
NSString *const kTeamsAbr;
NSString *const kLeagues;
NSString *const kScore;
NSString *const kScoreToday;
NSString *const kScoreWeek;

#pragma mark - Team Matchups Class

//Class key
NSString *const kTeamMatchupClass;

//Field keys
NSString *const kHomeTeam;
NSString *const kHomeTeamName;
NSString *const kHomeTeamNumber;
NSString *const kAwayTeam;
NSString *const kAwayTeamName;
NSString *const kAwayTeamNumber;
NSString *const kRound;


#pragma mark - Leage Class
//Class key
NSString *const kLeagueClass;

//Field keys
NSString *const kLeagueCategories;
//using kLeagues for league filed


#pragma mark - Cached Activity Attributes
// keys
extern NSString *const kActivityAttributesIsLikedByCurrentUserKey;
extern NSString *const kActivityAttributesLikeCountKey;
extern NSString *const kActivityAttributesLikersKey;
extern NSString *const kActivityAttributesCommentCountKey;
extern NSString *const kActivityAttributesCommentersKey;


#pragma mark - Cached User Attributes
// keys
extern NSString *const kUserAttributesActivityCountKey;
extern NSString *const kUserAttributesIsFollowedByCurrentUserKey;


#pragma mark - PFPush Notification Payload Keys

extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kPushPayloadPayloadTypeKey;
extern NSString *const kPushPayloadPayloadTypeActivityKey;

extern NSString *const kPushPayloadActivityTypeKey;
extern NSString *const kPushPayloadActivityLikeKey;
extern NSString *const kPushPayloadActivityCommentKey;
extern NSString *const kPushPayloadActivityFollowKey;

extern NSString *const kPushPayloadFromUserObjectIdKey;
extern NSString *const kPushPayloadToUserObjectIdKey;
extern NSString *const kPushPayloadPhotoObjectIdKey;

