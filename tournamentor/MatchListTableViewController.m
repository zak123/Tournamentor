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


@interface MatchListTableViewController () < UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (nonatomic) NSArray *matches;
@property (weak, nonatomic) IBOutlet BracketCollectionView *bracketView;

@end

@implementation MatchListTableViewController {
    MBProgressHUD *_hud;
    
}

static NSString * const reuseIdentifier = @"bracketCollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    

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
    
    // Configure the cell
    
    return bracketCollectionViewCell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPickedMatch"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = self.matches[indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        
        
    }
    


}


@end
