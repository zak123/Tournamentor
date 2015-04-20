//
//  TournamentListTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/18/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "TournamentListTableViewController.h"

@interface TournamentListTableViewController ()

@property (nonatomic) NSArray *tournaments;


@end

@implementation TournamentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    User *user = [[User alloc]init];

    
    [[DataHolder sharedInstance] loadData];
    
    user.name = [DataHolder sharedInstance].username;
    
    user.apiKey = [DataHolder sharedInstance].apiKey;
    
    [self setTitle:user.name];

    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    
    [communicator getTournaments:user.name withKey:user.apiKey block:^(NSArray *tournamentsArray, NSError *error) {
        
        NSLog(@"%@", tournamentsArray);
        
        if (error) {
            NSLog(@"Error detected");
            [self performSegueWithIdentifier:@"needsApiKey" sender:self];
            //            [self.navigationController popViewControllerAnimated:YES];
        }
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                _tournaments = tournamentsArray;
                
                [self.tableView reloadData];
                
                
            });
            
        }
        
        
        
    }];
    

}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.tournaments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TournamentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tournamentCell" forIndexPath:indexPath];
    Tournament *cellTourn = _tournaments[indexPath.row];
    cell.tournamentNameLabel.text = cellTourn.tournamentName;
    
    
    
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
