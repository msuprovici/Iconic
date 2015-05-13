//
//  League.h
//  Iconic
//
//  Created by Mike Suprovici on 5/16/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface League : NSManagedObject

@property (nonatomic, retain) NSString * league;
@property (nonatomic, retain) NSSet *teams;
@end

@interface League (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
