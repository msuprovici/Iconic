//
//  Team.h
//  Iconic
//
//  Created by Mike Suprovici on 4/4/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject
//store team name and weather a player joined the team in a property
@property (nonatomic, copy) NSString *teamName;
@property BOOL playerJoinedTeam;

@end
