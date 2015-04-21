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
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [[User alloc]init];

    
    [[DataHolder sharedInstance] loadData];
    
    self.user.name = [DataHolder sharedInstance].username;
    
    self.user.apiKey = [DataHolder sharedInstance].apiKey;
    
    [self setTitle:self.user.name];

    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    
    [communicator getTournaments:self.user.name withKey:self.user.apiKey block:^(NSArray *tournamentsArray, NSError *error) {
        
        NSLog(@"%@", tournamentsArray);
        
        if (error) {
            NSLog(@"Error detected");
            
            if (self.user.apiKey.length < 1) {
                [self performSegueWithIdentifier:@"needsApiKey" sender:self];
            }
            else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your sign in information is not valid" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
            
            [self performSegueWithIdentifier:@"needsApiKey" sender:self];
            //            [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                _tournaments = [[tournamentsArray reverseObjectEnumerator] allObjects];
                
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
    
    
    
    TournamentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Tournament *cellTourn = _tournaments[indexPath.row];
    
    cell.tournamentNameLabel.text = cellTourn.tournamentName;
    
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showMatches"]) {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    MatchListTableViewController *dVC = (MatchListTableViewController *)segue.destinationViewController;
    
    dVC.selectedTournament = self.tournaments[indexPath.row];
    dVC.currentUser = self.user;
    }
    
    
    
    
    
    
    

    
}


@end
