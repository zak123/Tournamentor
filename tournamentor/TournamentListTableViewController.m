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
    
    
    
    TournamentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Tournament *cellTourn = _tournaments[indexPath.row];
    
    cell.tournamentNameLabel.text = cellTourn.tournamentName;
    
    
    
    return cell;
}


@end
