//
//  CustomTransition.h
//  Iconic
//
//  Created by Mike Suprovici on 1/6/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "MZTransition.h"
extern NSString *const MZTransitionExceptionMethodNotImplemented;

typedef void(^MZTransitionCompletionHandler)();

@interface CustomTransition : MZTransition

- (void)entryFormSheetControllerTransition:(MZFormSheetController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler;

- (void)exitFormSheetControllerTransition:(MZFormSheetController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler;


@end
