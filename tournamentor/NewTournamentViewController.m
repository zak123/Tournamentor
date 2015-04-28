//
//  NewTournamentViewController.m
//  
//
//  Created by Zachary Mallicoat on 4/22/15.
//
//

#import "NewTournamentViewController.h"
#import "ChallongeCommunicator.h"
#import "AddParticipantTableViewCell.h"

@interface NewTournamentViewController ()

@property (nonatomic) NSString *tournamentType;

@end

@implementation NewTournamentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self layoutNavigationBar];
    
    
    self.tournamentType = @"single elimination";
    
    //    @property (weak, nonatomic) IBOutlet UITextField *tournamentNameTextField;
    //    @property (weak, nonatomic) IBOutlet UITextField *tournamentURLTextField;
    //    @property (weak, nonatomic) IBOutlet UITextField *gameTextField;
    //    @property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
    
    self.tournamentNameTextField.delegate = self;
    self.tournamentURLTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    self.gameTextField.delegate = self;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGR.delegate = self;
    tapGR.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapGR];
    
    
    
}


- (IBAction)tournamentTypeChanged:(id)sender {
    
    switch (self.tournamentTypePicker.selectedSegmentIndex)
    {
        case 0:
            self.tournamentType = @"single elimination";
            break;
        case 1:
            self.tournamentType = @"double elimination";
            break;
        default:
            break;
    }
}


-(void)layoutNavigationBar{


    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(didHitDone)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}


-(void)didHitDone {
    self.tournament = [[Tournament alloc]init];
    
    self.tournament.tournamentURL = self.tournamentURLTextField.text;
    self.tournament.tournamentName = self.tournamentNameTextField.text;
    self.tournament.tournamentType = self.tournamentType;
    self.tournament.tournamentDescription = self.descriptionTextView.text;
    
    [self.tournamentNameTextField endEditing:YES];
    [self.tournamentURLTextField endEditing:YES];
    [self.descriptionTextView endEditing:YES];
    [self.gameTextField endEditing:YES];
    
    
//    Save match info to challonge
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
    [communicator addNewTournament:self.tournamentNameTextField.text withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey andTournamentURL:self.tournamentURLTextField.text andTournamentType:self.tournamentType andTournamentDescription:self.descriptionTextView.text block:^(NSError *error) {
        if (!error) {
            
            
            [self performSegueWithIdentifier:@"addParticipants" sender:self];
            
        }
        else {
            NSLog(@"Error adding new tournament: %@", error);
            
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not create tournament hosted at Challonge.com. Make sure your tournament URL only contains characters and numbers, and that everything else is filled out." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
        }
    }];
    
    
    
//    [self performSegueWithIdentifier:@"addParticipants" sender:self];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tap gesture recognizer & keyboard dismiss

- (void)handleTap:(UITapGestureRecognizer *)sender {
    NSLog(@"it works, Mass");
    
    [self.tournamentNameTextField endEditing:YES];
    [self.tournamentURLTextField endEditing:YES];
    [self.descriptionTextView endEditing:YES];
    [self.gameTextField endEditing:YES];
    

}


#pragma mark - tournamentURL validation for acceptable characters

- (BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)characters {
    NSCharacterSet *TournamentURLcharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789_"];
    
    NSCharacterSet *blockedCharactersURL = [TournamentURLcharacterSet invertedSet];
    
    NSCharacterSet *TournamentNameCharacterSet = [NSCharacterSet alphanumericCharacterSet];
    
    NSMutableCharacterSet *space = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
    [space formUnionWithCharacterSet:TournamentNameCharacterSet];
    
    NSCharacterSet *blockedCharacterName = [TournamentNameCharacterSet invertedSet];
    
    
    if (field == self.tournamentURLTextField) {
        
        //NSMutableCharacterSet *_alnum = [NSMutableCharacterSet characterSetWithCharactersInString:@"_"];
        //[_alnum formUnionWithCharacterSet:TournamentURLcharacterSet];
        
        return ([characters rangeOfCharacterFromSet:blockedCharactersURL].location == NSNotFound);
        
    } else if (field == self.tournamentNameTextField) {
        
        return ([characters rangeOfCharacterFromSet:blockedCharacterName].location == NSNotFound);
        
    } else {
        return characters;
    }
    
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addParticipants"]) {

        
        AddParticipantsTableViewController *aVC = (AddParticipantsTableViewController *)segue.destinationViewController;
        
        aVC.currentUser = self.currentUser;
        aVC.tournament = self.tournament;
        
        
    }
}


@end
