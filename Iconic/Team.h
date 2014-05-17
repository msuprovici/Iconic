//
//  Team.h
//  Iconic
//
//  Created by Mike Suprovici on 5/16/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "League.h"

@class League;

@interface Team : League

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * onteam;
@property (nonatomic, retain) League *inleague;

@end
