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
#import "Constants.h"
@implementation SWUITableViewCell

@end

@interface MenuViewController ()

@end

@implementation MenuViewController



- (void)viewDidLoad
{
    
    //[super viewDidLoad];
    
    
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



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
            
       case 4:
            CellIdentifier = @"findfriendsmenu";
            break;
            
        
    }
    
     if (indexPath.row == 0) {
                SWUITableViewCell *profileCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
         
         PFQuery* query = [PFUser query];
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
         PFUser* currentUser = [PFUser currentUser];

         
         if (currentUser) {
         [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         
        
        //My Profile Name
        profileCell.profileName.text = [NSString stringWithFormat:@"%@",[currentUser valueForKey:kUsername]] ;
        
        profileCell.profilePhoto.file = [currentUser objectForKey:kProfilePicture];
             
         PFImageView *photo = [[PFImageView alloc] init];
         
         photo.image = [UIImage imageWithContentsOfFile:@"user_place_holder.png"]; // placeholder image
         photo.file = (PFFile *)profileCell.profilePhoto.file;
         
         [photo loadInBackground];
             CALayer *imageLayer = profileCell.profilePhoto.layer;
             [imageLayer setCornerRadius:profileCell.profilePhoto.frame.size.width/2];
             [imageLayer setBorderWidth:0];
             
             [imageLayer setMasksToBounds:YES];

             
             
             [profileCell addSubview:profileCell.profilePhoto];
         }];
             
}
        return profileCell;
    }
    

     else{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
       

    return cell;
        
    }
}

@end
