//
//  MyFinalScoresTableViewController.m
//  Iconic
//
//  Created by Mike Suprovici on 1/28/15.
//  Copyright (c) 2015 Iconic All rights reserved.
//

#import "MyFinalScoresTableViewController.h"
#import "MyFinalScoresCell.h"

#import "Constants.h"
#import "PNColor.h"
#import <Parse/Parse.h>

@interface MyFinalScoresTableViewController ()

@property (strong, nonatomic) NSMutableArray * arrayOfTeamRounds;
@property (strong, nonatomic) NSMutableArray * arrayOfTeamMatchupsObjects;



@end

@implementation MyFinalScoresTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    

 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];

    
    return homeTeamNames.count;

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"MyFinalScoresCell";
    

    
    MyFinalScoresCell * cell = (MyFinalScoresCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (nil == cell){
        cell = [[MyFinalScoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }


    
    
    
    cell.myTeamName.textColor = PNWeiboColor;
    cell.myTeamScore.textColor = PNWeiboColor;
    
    
    cell.vsTeamName.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0];
    cell.vsTeamScore.textColor = [UIColor colorWithRed:124.0/255.0 green:124.0/255.0 blue:134.0/255.0 alpha:1.0];
    
    cell.myLeague.textColor = [UIColor colorWithRed:0.0/255.0 green:42.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    
    NSUserDefaults *RetrievedTeams = [NSUserDefaults standardUserDefaults];
    
    NSArray *homeTeamScores = [RetrievedTeams objectForKey:@"FinalHomeTeamScores"];
    NSArray *awayTeamScores = [RetrievedTeams objectForKey:@"FinalAwayTeamScores"];
    
    NSArray *homeTeamNames = [RetrievedTeams objectForKey:kArrayOfHomeTeamNames];
    NSArray *awayTeamNames = [RetrievedTeams objectForKey:kArrayOfAwayTeamNames];
    
    NSArray *arrayOfLeagueNames = [RetrievedTeams objectForKey:kArrayOfLeagueNames];
    
    
    //set team names
    NSString * homeTeamName = [NSString stringWithFormat:@"%@",[homeTeamNames objectAtIndex:indexPath.row]];
   
    
    NSString * awayTeamName = [NSString stringWithFormat:@"%@",[awayTeamNames objectAtIndex:indexPath.row]];
    
    
    
    //set league names
    NSString * leagueName = [NSString stringWithFormat:@"%@",[arrayOfLeagueNames objectAtIndex:indexPath.row]];
    
    cell.myLeague.text = leagueName;
    
    //set score
    NSString * homeTeamScore = [NSString stringWithFormat:@"%@",[homeTeamScores objectAtIndex:indexPath.row]];
    
    NSString * awayTeamScore = [NSString stringWithFormat:@"%@",[awayTeamScores objectAtIndex:indexPath.row]];

    NSArray *myTeamsNames = [RetrievedTeams objectForKey:kArrayOfMyTeamsNames];
      
        for (int i = 0; i < myTeamsNames.count; i++) {
            
            if([myTeamsNames[i] isEqualToString: homeTeamName])
            {
                
                cell.myTeamName.text = homeTeamName;
                
                cell.myTeamScore.text = homeTeamScore;
                
                
                cell.vsTeamName.text = awayTeamName;
                
                cell.vsTeamScore.text = awayTeamScore;

                
            }
            
            else if([myTeamsNames[indexPath.row] isEqualToString: awayTeamName])
            {
                
                cell.myTeamName.text = awayTeamName;
               
                cell.myTeamScore.text = awayTeamScore;
                
                
                cell.vsTeamName.text = homeTeamName;
                
                cell.vsTeamScore.text = homeTeamScore;
                
                
            }
        }

    
    
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
