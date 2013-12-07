//
//  MyStatsViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/5/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "MyStatsViewController.h"

@interface MyStatsViewController ()
{
    int pointslabelNumber;
    
}

@end

@implementation MyStatsViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //pageNumber = page;
    }
    return self;
}
 */

- (id)initWithPointsLabelNumber:(NSUInteger)pointslabel
{
    if (self = [super initWithNibName:@"MyStatsViewController" bundle:nil])
    {
        pointslabelNumber = pointslabel;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Cycle through label string
    for (int i = 0; i <= pointslabelNumber; i++) {
        NSArray *myArray =  [NSArray arrayWithObjects: @"", @"7 Days", @"24 hrs", nil];
        
        //self.pointsLabel.text = [NSString stringWithFormat:@"Points %d", pointslabelNumber + 1];
        self.pointsLabel.text = [NSString stringWithFormat:@"XP %@", myArray[i]];

    
    }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
