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
@property (nonatomic) IBOutlet BracketCollectionView *bracketView;

@end

@implementation MatchListTableViewController {
    int numMatches;
    NSMutableArray *numMatchesArray;
    NSNumber *numberRounds;
    MBProgressHUD *_hud;
    NSMutableDictionary *roundDictionary;
    NSArray *roundsArray;
    NSArray *newSorted;
    NSString *titleForHeader;

    
}

static NSString * const reuseIdentifier = @"bracketCollectionViewCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self headerViewToggle];


    
    newSorted = [[NSArray alloc]init];


    


}

-(void)viewWillAppear:(BOOL)animated {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    [_hud show:YES];
    
    
    [self setTitle:self.selectedTournament.tournamentName];
    
    [self updateTournamentsAndDictionary];
    
    
}

-(void)headerViewToggle {
    
    CGRect frame = self.tableView.tableHeaderView.frame;
    frame.size.height = 0;
    self.tableView.tableHeaderView.frame = frame;
    
    self.tableView.tableHeaderView.hidden = YES;


}


-(void)updateTournamentsAndDictionary {
    numMatchesArray = [[NSMutableArray alloc]init];

    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    [communicator getMatchesForTournament:self.selectedTournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey block:^(NSArray *matchArray, NSError *error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^() {
                
                for (numMatches = 0; numMatches < matchArray.count; numMatches++) {
                    [numMatchesArray addObject:[NSString stringWithFormat:@"%i", numMatches]];
                }
                self.matches = matchArray;
                roundDictionary = [NSMutableDictionary dictionary];
                
                for (Match *match in matchArray) {
                    if (!roundDictionary[match.round])
                        roundDictionary[match.round] = [NSMutableArray array];
                    [roundDictionary[match.round] addObject:match];
                }
                
                NSMutableArray *openMatches = [[NSMutableArray alloc]init];
                NSMutableArray *notOpenMatches = [[NSMutableArray alloc]init];
                //                NSDictionary *openDic = [[NSDictionary alloc]init];
                
                
                for (NSNumber *key in [roundDictionary allKeys]) {
                    NSArray *objectArray = [roundDictionary objectForKey:key];
                    
                    //                    openDic = @{ key : @(0) };
                    
                    for (int i = 0; i < objectArray.count; i++) {
                        Match *aMatch = objectArray[i];
                        
                        if ([aMatch.state  isEqual: @"open"]) {
                            [openMatches addObject:key];
                        }
                        else {
                            [notOpenMatches addObject:key];
                        }
                    }
                }
                NSMutableArray *openMatchesWinners = [[NSMutableArray alloc]init];
                NSMutableArray *openMatchesLosers = [[NSMutableArray alloc]init];
                
                NSMutableArray *closedMatchesWinners = [[NSMutableArray alloc]init];
                NSMutableArray *closedMatchesLosers = [[NSMutableArray alloc]init];
                
                NSArray *openMatchesWinnersSorted = [[NSArray alloc]init];
                NSArray *openMatchesLosersSorted = [[NSArray alloc]init];
                
                NSArray *closedMatchesWinnersSorted = [[NSArray alloc]init];
                NSArray *closedMatchesLosersSorted = [[NSArray alloc]init];
                
                //                NSArray *openMatchesSorted = [[NSArray alloc]init];
                for (NSNumber *j in openMatches) {
                    if ([j intValue] > 0 && [j intValue] < 9000) {
                        [openMatchesWinners addObject:j];
                        
                    }
                    else {
                        [openMatchesLosers addObject:j];
                    }
                }
                for (NSNumber *k in notOpenMatches) {
                    if ([k intValue] > 0 && [k intValue] < 9000) {
                        [closedMatchesWinners addObject:k];
                    }
                    else {
                        [closedMatchesLosers addObject:k];
                    }
                }
                
                openMatchesWinnersSorted = [openMatchesWinners sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                openMatchesLosersSorted = [openMatchesLosers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                
                closedMatchesWinnersSorted = [closedMatchesWinners sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                
                closedMatchesLosersSorted = [closedMatchesLosers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                
                
                NSArray *reverseOpenMatchesLosersSorted = [[NSArray alloc]init];
                NSArray *reverseClosedMatchesLosersSorted = [[NSArray alloc]init];
                
                reverseOpenMatchesLosersSorted = [[openMatchesLosersSorted reverseObjectEnumerator] allObjects];
                reverseClosedMatchesLosersSorted = [[closedMatchesLosersSorted reverseObjectEnumerator] allObjects];
                
                NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                [sortedArray addObjectsFromArray:openMatchesWinnersSorted];
                [sortedArray addObjectsFromArray:reverseOpenMatchesLosersSorted];
                [sortedArray addObjectsFromArray:closedMatchesWinnersSorted];
                [sortedArray addObjectsFromArray:reverseClosedMatchesLosersSorted];
                
                newSorted = [NSArray arrayWithArray:[[NSOrderedSet orderedSetWithArray:sortedArray] array]];
                
                
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

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    
//    UICollectionReusableView *reusableview;
//    
//    
//    BracketCollectionViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
//    
//    headerView.viewHeader.text = @"TEST";
//    
//    if (reusableview == nil) {
//        reusableview = [[UICollectionReusableView alloc] init];
//    }
//    
//    return reusableview;
//    
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    NSString *str = [self getSectionHeaderForKeys:newSorted andSection:section];
    

    
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        BracketCollectionViewHeader *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[BracketCollectionViewHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
        
        reusableview.viewHeader.text=str;
        return reusableview;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return newSorted.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSArray *keys = newSorted;
    
    NSArray *match = roundDictionary[keys[section]];
    
    return match.count;
}

-(NSString *)getSectionHeaderForKeys:(NSArray *)keysArray andSection:(NSInteger)section {
    NSArray *keys = keysArray;
    
    NSNumber *max=[keys valueForKeyPath:@"@max.self"];
    NSNumber *min=[keys valueForKeyPath:@"@min.self"];
    
    
    NSString *str = [NSString stringWithFormat:@"%@", keys[section]];
    
    if ([str containsString:@"-"]) {
        if ([str doubleValue] == [min doubleValue]) {
            str = [NSString stringWithFormat:@"Loser Finals"];
        }else {
            str = [NSString stringWithFormat:@"Losers Round %@", keys[section]];
            str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    }
    else {
        if ([str doubleValue] == [max doubleValue]) {
            str = [NSString stringWithFormat:@"Finals"];
        } else {
            str = [NSString stringWithFormat:@"Winners Round %@", keys[section]];
        }
    }
    
    return str;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self getSectionHeaderForKeys:newSorted andSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matchCell" forIndexPath:indexPath];
    
    
    
    id cellMatchKey = [newSorted objectAtIndex:indexPath.section];
    
    Match *cellMatch = [[roundDictionary objectForKey:cellMatchKey] objectAtIndex:indexPath.row];
    
    if ([cellMatch.state  isEqual: @"complete"]) {
        cell.roundImage.image = [UIImage imageNamed:@"complete"];
    }
    if ([cellMatch.state isEqual: @"pending"]) {
        cell.roundImage.image = [UIImage imageNamed:@"pending"];
    }
    if ([cellMatch.state isEqual: @"open"]) {
        cell.roundImage.image = [UIImage imageNamed:@"edit"];
    }
    
    cell.player2Label.alpha = 0;
    cell.player1Label.alpha = 0;
    cell.player1Score.alpha = 0;
    cell.player2Score.alpha = 0;
    cell.roundLabel.alpha = 0;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        cell.player2Label.alpha = 1;
        cell.player1Label.alpha = 1;
        cell.player1Score.alpha = 1;
        cell.player2Score.alpha = 1;
        cell.roundLabel.alpha = 1;
        
    }];

    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:0.231 green:0.231 blue:0.231 alpha:1];
    }
 

    if (cellMatch.score.length > 1) {
        cell.player1Label.text = cellMatch.player1_name;
        cell.player2Label.text = cellMatch.player2_name;
        
        NSArray *scoresArray = [cellMatch.score componentsSeparatedByString:@"-"];
        
        cell.player1Score.text = [NSString stringWithFormat:@"%.0f", [scoresArray[0] doubleValue]];
        
        cell.player2Score.text = [NSString stringWithFormat:@"%.0f", [scoresArray[1] doubleValue]];
        
        
        
        if ([cell.player1Score.text intValue] > [cell.player2Score.text intValue]) {
           
        }
        
        if ([cell.player2Score.text intValue] > [cell.player1Score.text intValue]) {
            
        }
 
        
    
        
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
    return newSorted.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    NSArray *keys = newSorted;
    
    NSArray *match = roundDictionary[keys[section]];
    
    return match.count;
    
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BracketCollectionViewCell *bracketCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    id cellMatchKey = [newSorted objectAtIndex:indexPath.section];
    
    Match *cellMatch = [[roundDictionary objectForKey:cellMatchKey] objectAtIndex:indexPath.row];
    
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
        
        Match *selectedMatch = roundDictionary[newSorted[indexPath.section]][indexPath.row];
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
        Match *selectedMatch = roundDictionary[newSorted[indexPath.section]][indexPath.row];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    id cellMatchKey = [newSorted objectAtIndex:indexPath.section];

    if ([segue.identifier isEqualToString:@"showPickedMatch"]) {
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = [[roundDictionary objectForKey:cellMatchKey] objectAtIndex:indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        
        
        dVC.roundText = titleForHeader;

        
    }
    else if ([segue.identifier isEqualToString:@"showPickedMatchHeader"]) {
        
        NSIndexPath *indexPath = [self.bracketView indexPathForCell:sender];
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = [[roundDictionary objectForKey:cellMatchKey] objectAtIndex:indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        

        dVC.roundText = titleForHeader;
        
        
    }
    
    else if ([segue.identifier isEqualToString:@"AddParticipantsTableViewControllerStoryboardID"]){
        
        MatchEditTableViewController *dVC = (MatchEditTableViewController *)segue.destinationViewController;
        
        dVC.selectedMatch = [[roundDictionary objectForKey:cellMatchKey] objectAtIndex:indexPath.row];
        dVC.currentUser = self.currentUser;
        dVC.currentTournament = self.selectedTournament;
        NSLog(@"Adding more participants");
    }
}

    





@end
