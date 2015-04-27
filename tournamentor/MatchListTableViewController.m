//
//  MatchListTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/21/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "MatchListTableViewController.h"
#import <UAProgressView.h>
#import "BracketCollectionView.h"
#import "BracketCollectionViewCell.h"


@interface MatchListTableViewController () < UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic) NSArray *matches;
@property (weak, nonatomic) IBOutlet BracketCollectionView *bracketView;

@end

@implementation MatchListTableViewController {
    int numMatches;
    MBProgressHUD *_hud;
    
}

static NSString * const reuseIdentifier = @"bracketCollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // How to load participants from a tournament
//    ChallongeCommunicator *testComm = [[ChallongeCommunicator alloc]init];
//    [testComm getParticipants:self.selectedTournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey block:^(NSArray *participants, NSError *error) {
//        if (!error) {
//            NSLog(@"%@", participants);
//        }
//    }];
    

}

-(void)viewWillAppear:(BOOL)animated {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    [_hud show:YES];
    
    
    [self setTitle:self.selectedTournament.tournamentName];
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    [communicator getMatchesForTournament:self.selectedTournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey block:^(NSArray *matchArray, NSError *error) {
        NSLog(@"%@", matchArray);
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                
                for (numMatches = 0; numMatches < matchArray.count; numMatches++) {
//                    NSLog(@"NumMatches = %i", i+1);
                    
                    
                }
                
                
                
                self.matches = matchArray;
                self.bracketView.matches = self.matches;
                [self.tableView reloadData];
                [self.bracketView reloadData];

                
                [_hud hide:YES];
                
            });
          
        }

        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Tournament not found. Maybe it was deleted recently?" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            [alert show];

            [_hud hide:YES];
        }
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.matches.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];
    
    Match *cellMatch = _matches[indexPath.row];
    
    cell.roundLabel.text = cellMatch.state;
    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1];
    }
 

    if (cellMatch.score.length > 1) {
        
        cell.player1Label.text = [NSString stringWithFormat:@"%@ -", cellMatch.player1_name];
        cell.player2Label.text = [NSString stringWithFormat:@"%@ -", cellMatch.player2_name];
        
        NSArray *scoresArray = [cellMatch.score componentsSeparatedByString:@"-"];
        
        cell.player1Score.text = [NSString stringWithFormat:@"%.0f", [scoresArray[0] doubleValue]];
        
        cell.player2Score.text = [NSString stringWithFormat:@"%.0f", [scoresArray[1] doubleValue]];
        

        
    } else {
        cell.player1Label.text = cellMatch.player1_name;
        cell.player2Label.text = cellMatch.player2_name;
        cell.player1Score.text = nil;
        cell.player2Score.text = nil;
    }
    
    
    return cell;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    
    return self.matches.count;
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BracketCollectionViewCell *bracketCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Match *cellMatch = _matches[indexPath.row];
    
    bracketCollectionViewCell.player1Label.text = cellMatch.player1_name;
    bracketCollectionViewCell.player2Label.text = cellMatch.player2_name;
    
    bracketCollectionViewCell.layer.masksToBounds = YES;
    bracketCollectionViewCell.layer.cornerRadius = 6;
    
    // Configure the cell
    
    return bracketCollectionViewCell;
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([sender isKindOfClass:[BracketCollectionViewCell class]]){
        
        
        BracketCollectionViewCell *bracketCollectionViewCell = sender;
        NSIndexPath *indexPath = [self.bracketView indexPathForCell:bracketCollectionViewCell];
        bracketCollectionViewCell = [self.bracketView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        Match *selectedMatch = self.matches[indexPath.item];
        NSLog(@"State: %@", selectedMatch.state);
        if ([selectedMatch.state isEqualToString:@"complete"]) {
            
            UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Illegal Action" message:@"You can't edit a match that is complete! Either reset the tournament (Long press a tournament on the preview screen) or edit \"Open\" matches."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [confirmation show];
            return NO;
        }
        else if ([selectedMatch.state isEqualToString:@"pending"]) {
            UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Illegal Action" message:@"You are trying to edit a match too far into the future! You can only edit \"Open\" matches."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [confirmation show];
            return NO;
            
        }
        else {
            return YES;
        }
    }
    
    if ([sender isKindOfClass:[MatchListTableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Match *selectedMatch = self.matches[indexPath.row];
        NSLog(@"State: %@", selectedMatch.state);
        if ([selectedMatch.state isEqualToString:@"complete"]) {
            
            UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Illegal Action" message:@"You can't edit a match that is complete! Either reset the tournament (Long press a tournament on the preview screen) or edit \"Open\" matches."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [confirmation show];
            return NO;
        }
        if ([selectedMatch.state isEqualToString:@"pending"]) {
            UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Illegal Action" message:@"You are trying to edit a match too far into the future! You can only edit \"Open\" matches."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [confirmation show];
            return NO;
            
        }
        else {
            return YES;
        }
    }
    else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"showPickedMatch"]) {
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = self.matches[indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        
        
    }
    else if ([segue.identifier isEqualToString:@"showPickedMatchHeader"]) {
        
        NSIndexPath *indexPath = [self.bracketView indexPathForCell:sender];
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = self.matches[indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        
        
    }
}

    





@end
