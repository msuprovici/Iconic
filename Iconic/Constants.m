//
//  Constants.m
//  Iconic
//
//  Created by Mike Suprovici on 12/26/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

//s9bHjtPJmIosc4TX9QqG9NTkbZHc2usrJDxoEExx
//ziKjpay7oUalpigStoBzZ5Stp9WTI3IeYhhCYEk2

#import "Constants.h"


// Define an array of Facebook Ids for accounts to auto-follow on signup
#define kAutoFollowAccountFacebookIds @[ ]

NSString *const kUserDefaultsActivityFeedViewControllerLastRefreshKey    = @"com.stickyplay.Iconic.userDefaults.activityFeedViewController.lastRefresh";
NSString *const kUserDefaultsCacheFacebookFriendsKey                     = @"com.stickyplay.Iconic.userDefaults.cache.facebookFriends";

#pragma mark - My Stats (NSUserDefaults)
//points
NSString *const kMyPointsToday = @"TodayPoints";
NSString *const kMyPointsTotal = @"MyTotalPoints";
NSString *const kMyPointsWeekArray = @"MyWeekleyPoints";

NSString *const kMyFetchedPointsToday = @"TodayFetchedPoints";
NSString *const kMyFetchedPointsTotal = @"MyTotalFetchedPoints";

NSString *const kMyMostRecentFetchedPointsBeforeSaving = @"theMostRecentFetchedPointsBeforeSaving";
NSString *const kMyLevelOnLastLaunch = @"myLevelOnPreviousLaunch";

//NSString *const kMyFetchedPointsWeekArray = @"MyWeekleyFetchedPoints";

NSString *const kMyMostRecentPointsBeforeSaving = @"theMostRecentPointsBeforeSaving";
NSString *const kMyMostRecentStepsBeforeSaving = @"NumberOfStepsBeforeSaving";
NSString *const kMyMostRecentTotalPointsBeforeSaving = @"MyTotalPointsBeforeSaving";

//arrays
NSString *const kMyTeamDataArray = @"myTeamDataArray";
NSString *const kMyMatchupsArray = @"myMatchupsArray";
NSString *const kArrayOfAwayTeamPointers = @"arrayOfAwayTeamPointers";
NSString *const kArrayOfHomeTeamPointers = @"arrayOfHomeTeamPointers";
NSString *const kArrayOfHomeTeamScores = @"arrayOfHomeTeamScores";
NSString *const kArrayOfAwayTeamScores = @"arrayOfAwayTeamScores";
NSString *const kArrayOfAwayTeamNames = @"arrayOfAwayTeamNames";
NSString *const kArrayOfHomeTeamNames = @"arrayOfHomeTeamNames";
NSString *const kArrayOfTodayHomeTeamScores = @"ArrayOfTodayHomeTeamScores";
NSString *const kArrayOfTodayAwayTeamScores = @"ArrayOfTodayAwayTeamScores";
NSString *const kArrayOfWeekleyHomeTeamScores = @"ArrayOfWeekleyHomeTeamScores";
NSString *const kArrayOfWeekleyAwayTeamScores = @"ArrayOfWeekleyAwayTeamScores";

//nuber of teams
NSString *const kNumberOfTeams = @"numberOfTeams";

//step counting
NSString *const STEPS_KEY = @"steps";
NSString *const kMyStepsWeekArray = @"MyWeekleySteps";



#pragma mark - Launch URLs

NSString *const kLaunchURLHostLoadActivity = @"camera";// <- define
// player physical activity keys

#pragma mark - Player Physical Activity Points

NSString *const kUserClass = @"Test";


NSString *const kUser = @"User";
NSString *const kUsername = @"username";
NSString *const kProfilePicture = @"photo";
NSString *const kPlayerTitle = @"Title";
NSString *const kPlayerPoints = @"points";
NSString *const kPlayerPointsToday = @"pointstoday";
NSString *const kPlayerPointsWeek = @"pointsweek"; //array of points for past 7 days
NSString *const kPlayerStepsWeek = @"stepsweek"; //array of steps for past 7 days
NSString *const kPlayerXP = @"xp";
NSString *const kPlayerPointsToNextLevel = @"pointsToNextLevel";
NSString *const kPlayerSteps = @"steps";

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
NSString *const kPlayerActionActivityKey       = @"playerActivity";

// Type values
NSString *const kPlayerActionTypeLike       = @"like";
NSString *const kPlayerActionTypeFollow     = @"follow";
NSString *const kPlayerActionTypeComment    = @"comment";
NSString *const kPlayerActionTypeJoined     = @"joined";

#pragma mark - User Class
// Field keys
NSString *const kUserDisplayNameKey                          = @"username";
NSString *const kUserFacebookIDKey                           = @"facebookId";
NSString *const kUserActivityIDKey                              = @"photoId";
NSString *const kUserProfilePicSmallKey                      = @"photo";
NSString *const kUserProfilePicMediumKey                     = @"profilePictureMedium";
NSString *const kUserFacebookFriendsKey                      = @"facebookFriends";
NSString *const kUserAlreadyAutoFollowedFacebookFriendsKey   = @"userAlreadyAutoFollowedFacebookFriends";

#pragma mark - Activity Class
// Class key
NSString *const kActivityClassKey = @"Activity";// <-careful, make sure to set the right class here

// Field keys
NSString *const kActivityKey         = @"activity";
//NSString *const kPhotoThumbnailKey       = @"thumbnail";
NSString *const kActivityUserKey            = @"user";
NSString *const kActivityOpenGraphIDKey    = @"fbOpenGraphID";

#pragma mark - Timer Class
//Class key
NSString *const kTimerClass = @"Timer";


#pragma mark - Team Class
//Class key
NSString *const kTeamPlayersClass = @"TeamPlayers";

//Field keys
NSString *const kTeamate = @"playerpointer";
NSString *const kTeam = @"team";
NSString *const kTeamObjectIdString = @"teamObjectIdString";
NSString *const kUserObjectIdString = @"playerObjectIdString";

#pragma mark - Teams Class
//Class key
NSString *const kTeamTeamsClass = @"TeamName";
//Field keys
NSString *const kTeams = @"teams";

NSString *const kTeamsAbr = @"abriviatedName";

NSString *const kLeagues = @"league";

NSString *const kScore = @"score";

NSString *const kScoreToday = @"scoretoday";
NSString *const kScoreWeek = @"scoreweek"; //array of kScoreToday


#pragma mark - Team Matchups Class

//Class key
NSString *const kTeamMatchupClass = @"TeamMatchups";

//Field keys
NSString *const kHomeTeam = @"hometeam";//pointer to object in Teams class
NSString *const kHomeTeamName = @"hometeamname";
NSString *const kHomeTeamNumber = @"hometeamNumber";

NSString *const kAwayTeam = @"awayteam";//pointer to object in Teams class
NSString *const kAwayTeamName = @"awayteamname";
NSString *const kAwayTeamNumber = @"awayteamNumber";

NSString *const kRound = @"round";

#pragma mark - Leage Class
//Class key
NSString *const kLeagueClass = @"league";

//Field keys
NSString *const kLeagueCategories = @"categories";
//using kLeagues for league filed

#pragma mark - Cached Activity Attributes
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



