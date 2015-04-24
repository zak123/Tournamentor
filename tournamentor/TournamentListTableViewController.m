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

@interface TournamentListTableViewController () <UIActionSheetDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic) NSArray *tournaments;


@end

@implementation TournamentListTableViewController {
    MBProgressHUD *_hud;
    NSIndexPath *longPressedTournament;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showActionSheet];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated {
    self.user = [[User alloc]init];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    
    
    self.user.name = [[SSKeychain accountsForService:@"Challonge"][0] valueForKey:@"acct"];
    self.user.apiKey = [SSKeychain passwordForService:@"Challonge" account:self.user.name];
    
    [self setTitle:self.user.name];
    [self updateTournaments];
    
    

}

-(void) updateTournaments {
    [_hud show:YES];

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

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        longPressedTournament = [self.tableView indexPathForRowAtPoint:p];
        if (longPressedTournament == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:longPressedTournament];
            if (cell.isHighlighted) {
                NSLog(@"long press on table view at section %ld row %ld", (long)longPressedTournament.section, (long)longPressedTournament.row);
                [self showActionSheetForCell];
            }
        }
    }
}

-(void)showActionSheetForCell {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete Tournament"
                                                    otherButtonTitles:@"Start Tournament", @"Reset Tournament", @"End Tournament", nil];
    
    [actionSheet showInView:self.view];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    Tournament *selectedTournament = self.tournaments[longPressedTournament.row];

    if (buttonIndex == 1) {
        NSLog(@"Confirmed to delete tournament");
        
        [communicator deleteTournament:selectedTournament.tournamentURL withUsername:self.user.name andAPIKey:self.user.apiKey block:^(NSError *error) {
            if (!error) {
                NSLog(@"deleted tournament");
                [self updateTournaments];
            }
            else {
                NSLog(@"%@", error);
            }
        }];
    
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    Tournament *selectedTournament = self.tournaments[longPressedTournament.row];
    NSString *deleteMessage = [NSString stringWithFormat:@"Are you sure you want to delete %@", selectedTournament.tournamentName];
    
    if (buttonIndex == 0) {
        NSLog(@"Deleted Tournament picked %ld", (long)longPressedTournament.row);
        UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:deleteMessage  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [confirmation show];
        
        // delete tournament at this index
        
    }
    if (buttonIndex ==1) {
        NSLog(@"start tournament");
        [communicator startTournament:selectedTournament.tournamentURL withUsername:self.user.name andAPIKey:self.user.apiKey block:^(NSError *error) {
            if (!error) {
                NSLog(@"tournament started");
                [self updateTournaments];

            }
            else {
                NSLog(@"error");
            }
        }];
        
    }
    if (buttonIndex == 2) {
        NSLog(@"reset tournament");
        [communicator resetTournament:selectedTournament.tournamentURL withUsername:self.user.name andAPIKey:self.user.apiKey block:^(NSError *error) {
            if (!error) {
                NSLog(@"tournament reset");
                [self updateTournaments];

            }
            else {
                NSLog(@"%@", error);
            }
        }];
    }
    if (buttonIndex == 3) {
        NSLog(@"end tournament");
        [communicator endTournament:selectedTournament.tournamentURL withUsername:self.user.name andAPIKey:self.user.apiKey block:^(NSError *error) {
            if (!error) {
                NSLog(@"tournament finalized");
                [self updateTournaments];

            }
            else {
                NSLog(@"%@", error);
            }
        }];
    }
  
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
    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1];
    }
    
//    [cell setFillWidth:fillWidth];
    // __block means that blocks can make a variable/value mutable
    __block CGRect rect = CGRectMake(0, 70, 0, cell.frame.size.height-80);
    __block UIView * view = [[UIView alloc] initWithFrame:rect];
    
//    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fade"]];
//    [cell.contentView addSubview:backgroundView];

    view.backgroundColor = [UIColor colorWithRed:0.373 green:0.706 blue:0.376 alpha:1];
    view.tag = 100;
    
    for (UIView *subview in cell.contentView.subviews) {
        if (subview.tag == 100) {
            [subview removeFromSuperview];
        }
    }
    
    [cell.contentView addSubview:view];
    [cell.contentView sendSubviewToBack:view];
    
    
    [UIView animateWithDuration:1 animations:^{

        rect.size.width = fillWidth;
        view.frame = rect;
    }];
    
    NSLog(@"Cell at index called: %ld", (long)indexPath.row);
    
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
