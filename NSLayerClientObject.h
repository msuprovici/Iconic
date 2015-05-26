//
//  NSLayerClientObject.h
//  Iconic
//
//  Created by Mike Suprovici on 5/21/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Atlas.h"

@interface NSLayerClientObject : NSObject <LYRClientDelegate>

+ (NSLayerClientObject*)sharedInstance;

@property (nonatomic) LYRClient *layerClient;


// set
- (void)cacheLayerClient:(LYRClient*)layerClient forKey:(NSString*)key;
// get
- (LYRClient*)getCachedLayerClientForKey:(NSString*)key;

@end
