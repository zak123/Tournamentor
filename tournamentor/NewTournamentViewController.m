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
    
    
//    Save match info to challonge
//    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
//    [communicator addNewTournament:self.tournamentNameTextField.text withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey andTournamentURL:self.tournamentURLTextField.text andTournamentType:self.tournamentType andTournamentDescription:self.descriptionTextView.text block:^(NSError *error) {
//        if (!error) {
//            [self performSegueWithIdentifier:@"addParticipants" sender:self];
//            
//        }
//        else {
//            NSLog(@"Error Goddamnit!");
//        }
//    }];
    
    
    
    [self performSegueWithIdentifier:@"addParticipants" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
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
