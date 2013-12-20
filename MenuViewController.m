//
//  MenuViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 12/15/13.
//  Copyright (c) 2013 Explorence. All rights reserved.
//

#import "MenuViewController.h"
#import "ScheduleViewController.h"
#import "SWRevealViewController.h"

@implementation SWUITableViewCell

@end

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [self performSelector:@selector(retrieveFromParse)];
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
//    if ( [segue.destinationViewController isKindOfClass: [ScheduleViewController class]] &&
//        [sender isKindOfClass:[UITableViewCell class]] )
//    {
//        UILabel* c = [(SWUITableViewCell *)sender menuLabel];
//        ScheduleViewController * cvc = segue.destinationViewController;
//        
//        /*cvc.color = c.textColor;
//        cvc.text = c.text;*/
//    }
//    
    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        
        
        
        
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        
        
        SWRevealViewController* rvc = self.revealViewController;
        
        
        
                NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            
            
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}


//to do: wire this to the correspoing user class in parse instead of "Test"
- (void) retrieveFromParse {
    
    //My Teamates
    PFQuery *retrieveTeamates = [PFQuery queryWithClassName:@"Test"];
    retrieveTeamates.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    
    [retrieveTeamates findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSLog(@"%@", objects);
        if (!error) {
            playerProfile = [[NSArray alloc] initWithArray:objects];
        }
        //[self reloadData];
    }];
    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
   
    
    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"profile";
            break;
        
        case 1:
            CellIdentifier = @"home";
            break;
            
        case 2:
            CellIdentifier = @"leagues";
            break;
            
        case 3:
            CellIdentifier = @"schedule";
            break;
            
       /* case 4:
            CellIdentifier = @"activity";
            break;*/
            
        
    }
    
     if (indexPath.row == 0) {
                SWUITableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        PFObject *tempObject = [playerProfile objectAtIndex:indexPath.row];
        
        //My Profile Name
        profileCell.profileName.text = [tempObject objectForKey:@"teammate"];
        
        
        //My Profile Picture
        PFFile *imageFile = [tempObject objectForKey: @"Photo"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if(!error)
            {
                profileCell.profilePhoto.image = [UIImage imageWithData:data];
            }
        }];
        
        return profileCell;
    }
    

     else{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
       

    return cell;
        
    }
}

@end
