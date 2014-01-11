//
//  SimpleHomeViewController.h
//  Iconic
//
//  Created by Mike Suprovici on 1/10/14.
//  Copyright (c) 2014 Explorence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChart.h"

@interface SimpleHomeViewController : UIViewController <UIScrollViewDelegate>

{
    
    NSArray *teamScores;
    
    
}


@property (nonatomic, strong) NSArray *contentList;




@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;



//Team Chart labels



@property (weak, nonatomic) IBOutlet UILabel *MyTeamScore;


@property (weak, nonatomic) IBOutlet UILabel *VSTeamScore;


@property (strong, nonatomic) IBOutlet UILabel *xChartLabel;

@property (strong, nonatomic) IBOutlet UILabel *yChartLabel;

@property (strong, nonatomic) IBOutlet PNLineChart *teamMatchChart;


@end
