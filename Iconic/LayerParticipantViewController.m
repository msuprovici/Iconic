//
//  LayerParticipantViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 5/19/15.
//  Copyright (c) 2015 Iconic. All rights reserved.
//

#import "LayerParticipantViewController.h"
#import "ATLParticipantSectionHeaderView.h"
#import "ATLAddressBarViewController.h"
#import "Constants.h"

@interface LayerParticipantViewController ()

@end

@implementation LayerParticipantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancelTap)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    [self configureUI];
}

-(void)configureUI
{
    [[ATLParticipantTableViewCell appearance] setTitleColor:IconicBalck];
    [[ATLParticipantTableViewCell appearance] setTitleFont:IconicTitleFont];
    [[ATLParticipantSectionHeaderView appearance] setSectionHeaderTextColor:IconicBalck];
    [[ATLParticipantSectionHeaderView appearance] setBackgroundColor:IconicGrey];
    
    
//    [[ATLParticipantTableViewController appearance] set]
    
}

- (void)handleCancelTap
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
