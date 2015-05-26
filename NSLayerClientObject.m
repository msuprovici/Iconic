//
//  NSLayerClientObject.m
//  Iconic
//
//  Created by Mike Suprovici on 5/21/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import "NSLayerClientObject.h"

static NSLayerClientObject *sharedInstance;

@interface NSLayerClientObject ()
//@property (nonatomic, strong) NSCache *layerClientCache;
@property (nonatomic, strong) NSMutableDictionary *layerClientCacheDictionary;
@end

@implementation NSLayerClientObject



+ (NSLayerClientObject*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSLayerClientObject alloc] init];
            });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
//        self.layerClientCache = [[NSCache alloc] init];
        self.layerClientCacheDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)cacheLayerClient:(LYRClient*)layerClient forKey:(NSString*)key {
//    [self.layerClientCache setObject:layerClient forKey:key];
    
    [self.layerClientCacheDictionary setObject:layerClient forKey:key];
}

- (LYRClient*)getCachedLayerClientForKey:(NSString*)key {
//    return [self.layerClientCache objectForKey:key];
    return [self.layerClientCacheDictionary objectForKey:key];
}

- (void)setLayerClient:(LYRClient *)layerClient
{
    self.layerClient = layerClient;
    
//    NSLog(@"layerClient nslayerclientobject: %@", layerClient);
    self.layerClient.delegate  = self;
}

@end
