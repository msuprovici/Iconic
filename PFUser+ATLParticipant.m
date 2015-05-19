//
//  PFUser+ATLParticipant.m
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import "PFUser+ATLParticipant.h"

@implementation PFUser (ATLParticipant)


- (NSString *)firstName
{
    return self.username;
}

- (NSString *)lastName
{
//    return @"Test";
    return @"";
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.username, self.lastName];
}

- (NSString *)participantIdentifier
{
    return self.objectId;
}

- (UIImage *)avatarImage
{
//    return self.avatarImage;
    return nil;
}

- (NSString *)avatarInitials
{
//    return [[NSString stringWithFormat:@"%@%@", [self.firstName substringToIndex:1], [self.lastName substringToIndex:1]] uppercaseString];
    
    return [[NSString stringWithFormat:@"%@", [self.firstName substringToIndex:1]] uppercaseString];
}


@end
