//
//  TournamentListTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/18/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "TournamentListTableViewController.h"
#import <SSKeychain/SSKeychain.h>
#import <SSKeychain/SSKeychainQuery.h>

@interface TournamentListTableViewController ()

@property (nonatomic) NSArray *tournaments;


@end

@implementation TournamentListTableViewController {
    MBProgressHUD *_hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [[User alloc]init];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    [_hud show:YES];
    
    
    self.user.name = [[SSKeychain accountsForService:@"Challonge"][0] valueForKey:@"acct"];
    self.user.apiKey = [SSKeychain passwordForService:@"Challonge" account:self.user.name];
    
    [self setTitle:self.user.name];

    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    
    [communicator getTournaments:self.user.name withKey:self.user.apiKey block:^(NSArray *tournamentsArray, NSError *error) {
        
        NSLog(@"%@", tournamentsArray);
        
        if (error) {
            [_hud hide:YES];
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
                [_hud hide:YES];
                
                
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
    
    float progressFloat = [cellTourn.progress floatValue];
    
    cell.backgroundColor = [UIColor clearColor];
    int fillWidth = (progressFloat/100.0) * cell.frame.size.width;
    
    CGRect rect = CGRectMake(0, 0, fillWidth, cell.frame.size.height);
    UIView * view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:view];
    [cell.contentView sendSubviewToBack:view];
    
    
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showMatches"]) {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    MatchListTableViewController *dVC = (MatchListTableViewController *)segue.destinationViewController;
    
    dVC.selectedTournament = self.tournaments[indexPath.row];
    dVC.currentUser = self.user;
    }
    
    if ([segue.identifier isEqualToString:@"addTournament"]) {
        
        
        NewTournamentViewController *dVC = (NewTournamentViewController *)segue.destinationViewController;
        
        dVC.currentUser = self.user;
        
    }
    
    
    
    
    
    
    

    
}


@end
