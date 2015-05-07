//
//  ResultsTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 5/6/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "Participant.h"
#import "ResultsTableViewController.h"
#import "ChallongeCommunicator.h"

@implementation ResultsTableViewController {
    NSMutableArray *results;
    
}

-(void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
                              
    self.navigationItem.rightBarButtonItem = share;
    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    
    [communicator getParticipants:self.currentTournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey block:^(NSArray *participants, NSError *error) {
        
        if (!error) {
            NSLog(@"Participants Loaded");
            results = [[NSMutableArray alloc]initWithArray:participants];
            
            
            NSSortDescriptor* sortByRank = [NSSortDescriptor sortDescriptorWithKey:@"finalRank" ascending:YES];
            [results sortUsingDescriptors:[NSArray arrayWithObject:sortByRank]];
            
            [self.tableView reloadData];
  
        } else {
            NSLog(@"Error loading participants: %@", error);
        }
        
    }];
}

-(void)share {
    
    NSString *string = [NSString stringWithFormat:@"http://images.challonge.com/%@.png", self.currentTournament.tournamentURL];
    NSURL *url = [[NSURL alloc]initWithString:string];
    NSData *imgData = [[NSData alloc]initWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:imgData];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[img]
                                                                                         applicationActivities:nil];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:^{
                         NSLog(@"complerted.");
                     }];}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Participant *cellParticipant = results[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"#%@ - %@", cellParticipant.finalRank, cellParticipant.name];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1];
    }
    
    return cell;
    
    
    
}

@end
