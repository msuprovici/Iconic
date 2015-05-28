//
//  ATLMLayerClient.h
//  Atlas Messenger
//
//  Created by Kevin Coleman on 11/25/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import <LayerKit/LayerKit.h>

/**
 @abstract The `ATLMLayerClient` is a subclass of `LYRClient` which provides an interface for performing routine queries against Layer messaging content.
 */
@interface ATLMLayerClient : LYRClient

/**
 @abstract Queries LayerKit for the total count of `LYRMessage` objects whose `isUnread` property is true.
 */
- (NSUInteger)countOfUnreadMessages;

/**
 @abstract Queries LayerKit for the total count of `LYRMessage` objects.
 */
- (NSUInteger)countOfMessages;

/**
 @abstract Queries LayerKit for the total count of `LYRConversation` objects.
 */
- (NSUInteger)countOfConversations;

/**
 @abstract Queries LayerKit for an existing message whose `identifier` property matches the supplied identifier.
 @param identifier An NSURL representing the `identifier` property of an `LYRMessage` object for which the query will be performed.
 @retrun An `LYRMessage` object or `nil` if none is found.
 */
- (LYRMessage *)messageForIdentifier:(NSURL *)identifier;

/**
 @abstract Queries LayerKit for an existing conversation whose `identifier` property matches the supplied identifier.
 @param identifier An NSURL representing the `identifier` property of an `LYRConversation` object for which the query will be performed.
 @retrun An `LYRConversation` object or `nil` if none is found.
 */
- (LYRConversation *)existingConversationForIdentifier:(NSURL *)identifier;

/** 
 @abstract Queries LayerKit for an existing conversation whose `participants` property matches the supplied set.
 @param participants An `NSSet` of participant identifier strings for which the query will be performed.
 @retrun An `LYRConversation` object or `nil` if none is found.
 */
- (LYRConversation *)existingConversationForParticipants:(NSSet *)participants;

@end

