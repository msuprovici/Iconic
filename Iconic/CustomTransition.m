//
//  CustomTransition.m
//  Iconic
//
//  Created by Mike Suprovici on 1/6/14.
//  Copyright (c) 2014 Iconic. All rights reserved.
//

#import "CustomTransition.h"
#import <Foundation/Foundation.h>
#import "MZTransition.h"
#import "MZFormSheetController.h"

@implementation CustomTransition 

- (void)entryFormSheetControllerTransition:(MZFormSheetController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    bounceAnimation.fillMode = kCAFillModeBoth;
    bounceAnimation.removedOnCompletion = YES;
    bounceAnimation.duration = 0.4;
    bounceAnimation.values = @[
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 0.01f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 0.9f)],
                               [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.1f)],
                               [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.timingFunctions = @[
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    bounceAnimation.delegate = self;
    [bounceAnimation setValue:completionHandler forKey:@"completionHandler"];
    [formSheetController.presentedFSViewController.view.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    
    
}
- (void)exitFormSheetControllerTransition:(MZFormSheetController *)formSheetController completionHandler:(MZTransitionCompletionHandler)completionHandler
{
    CGRect formSheetRect = formSheetController.presentedFSViewController.view.frame;
    formSheetRect.origin.x = formSheetController.view.bounds.size.width;
    
    CGPathRef fromPath = [UIBezierPath bezierPathWithRoundedRect:formSheetController.presentedFSViewController.view.frame cornerRadius:formSheetController.cornerRadius].CGPath;
    CGPathRef toPath = [UIBezierPath bezierPathWithRoundedRect:formSheetRect cornerRadius:formSheetController.cornerRadius].CGPath;
    
    // shadow optimalization
    formSheetController.view.layer.shadowPath = fromPath;
    CABasicAnimation *shadowPathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    shadowPathAnimation.duration = MZFormSheetControllerDefaultAnimationDuration;
    shadowPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shadowPathAnimation.fromValue = (id) formSheetController.view.layer.shadowPath;
    formSheetController.view.layer.shadowPath = toPath;
    shadowPathAnimation.toValue = (id) formSheetController.view.layer.shadowPath;
    [formSheetController.view.layer addAnimation:shadowPathAnimation forKey:@"shadowPath"];
    
    [UIView animateWithDuration:MZFormSheetControllerDefaultAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         formSheetController.presentedFSViewController.view.frame = formSheetRect;
                     }
                     completion:^(BOOL finished) {
                         completionHandler();
                     }];
}


@end
