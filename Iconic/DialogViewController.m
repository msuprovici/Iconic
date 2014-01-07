//
//  DialogViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/6/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//


#import "MZFormSheetController.h"
#import "DialogViewController.h"

@interface DialogViewController ()

@end

@implementation DialogViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
    }];
    
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar; // your own visibility code
}

- (IBAction)Share:(id)sender {
        NSArray *items   = [NSArray arrayWithObjects: UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypeMessage, nil];
    
    UIActivityViewController *activityController =  [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    ;

    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
