//
//  TutorialViewController.m
//  Iconic
//
//  Created by Tyler Phelps on 11/27/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGRect insetFrame = [[UIScreen mainScreen] bounds];
    _imageView = [[UIImageView alloc] initWithFrame:insetFrame];
    _imageView.backgroundColor = [UIColor clearColor];
    [_imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_imageView setImage:[UIImage imageNamed:_model.imageName]];
    [[self view] addSubview:_imageView];
}

@end
