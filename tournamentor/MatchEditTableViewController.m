//
//  MatchEditTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/21/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//



// Here we do the logic to post to challonge the scores that we set for the current match ID
#import "MatchEditTableViewController.h"

@interface MatchEditTableViewController ()

@property (nonatomic) NSString *scores_csv;


@property (nonatomic) NSNumber *winnerID;

@end

@implementation MatchEditTableViewController {
    double p1score;
    double p2score;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Awesome";
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_navigationBar];
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    [self setTitle:self.selectedMatch.bracketID];
    
    [self updateUI];
    

    
    
}
-(void)updateUI {
    
    
    self.winnerID = self.selectedMatch.player1_id;
    self.scores_csv = self.selectedMatch.score;
    
    
    if (self.scores_csv.length > 1) {
    NSArray *scoresArray = [self.scores_csv componentsSeparatedByString:@"-"];
        p1score = [scoresArray[0] doubleValue];
        p2score = [scoresArray[1] doubleValue];
    }
    

    
    self.player1Stepper.value = p1score;
    self.player2Stepper.value = p2score;
    self.player1ScoreLabel.text = [NSString stringWithFormat:@"%.f",p1score];
    self.player2ScoreLabel.text = [NSString stringWithFormat:@"%.f",p2score];
    
    
    [self.whoWonPicker setTitle:self.selectedMatch.player1_name forSegmentAtIndex:0];
    [self.whoWonPicker setTitle:self.selectedMatch.player2_name forSegmentAtIndex:1];
}

- (IBAction)whoWonChanged:(id)sender {
    
    switch (self.whoWonPicker.selectedSegmentIndex)
    {
        case 0:
            self.winnerID = self.selectedMatch.player1_id;
            break;
        case 1:
            self.winnerID = self.selectedMatch.player2_id;
            break;
        default: 
            break; 
    }
}


-(void)layoutNavigationBar{
    self.navigationBar.frame = CGRectMake(0, self.tableView.contentOffset.y, self.tableView.frame.size.width, self.topLayoutGuide.length + 44);
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Close"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didClose)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(didHitDone)];
    
    self.navigationItem.leftBarButtonItem = closeButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    self.tableView.contentInset = UIEdgeInsetsMake(self.navigationBar.frame.size.height, 0, 0, 0);
}

-(void)didClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)didHitDone {
    //Save match info to challonge
    
    self.scores_csv = [NSString stringWithFormat:@"%.f-%.f", p1score,p2score];
    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc]init];
    [communicator updateMatchForTournament:self.currentTournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey forMatchID:self.selectedMatch.matchID withScores:self.scores_csv winnerID:self.winnerID block:^(NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        else {
            NSLog(@"ERRORRRRR");
            
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error creating tournament" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
        }
        

    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //no need to call super
    [self layoutNavigationBar];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutNavigationBar];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return [NSString stringWithFormat:@"%@ score", self.selectedMatch.player1_name];
    }
    
    if (section == 1) {
        
        return [NSString stringWithFormat:@"%@ score", self.selectedMatch.player2_name];
    }
    if (section == 2) {
        
        return @"Who Won?";
        
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (IBAction)player1StepperChanged:(id)sender {
    self.player1ScoreLabel.text = [NSString stringWithFormat:@"%.f",self.player1Stepper.value];
    p1score = self.player1Stepper.value;
    
    
    
}
- (IBAction)player2StepperChanged:(id)sender {
    self.player2ScoreLabel.text = [NSString stringWithFormat:@"%.f", self.player2Stepper.value];
    p2score = self.player2Stepper.value;
    
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
