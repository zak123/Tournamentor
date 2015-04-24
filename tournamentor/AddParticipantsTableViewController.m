//
//  AddParticipantsTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/22/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "AddParticipantsTableViewController.h"

@interface AddParticipantsTableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *counter;

@property (nonatomic) NSMutableArray *participantsArray;
@property (nonatomic) NSMutableArray *participantNames;


@end

@implementation AddParticipantsTableViewController {
    int num;
}
-(void)viewDidLoad {
    
    self.participantsArray = [[NSMutableArray alloc]init];
    self.participantNames = [[NSMutableArray alloc]init];
    
    
    

    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = done;
    
    
}

- (IBAction)edited:(UITextField *)sender {
    NSLog(@"%@", sender.text);
    
    
}


-(void)done {
    
    
    for (int i=0; i < self.participantsArray.count; i++) {
        
        
        NSIndexPath *curCell = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:curCell];
        AddParticipantTableViewCell *myCell = (AddParticipantTableViewCell *)cell;
        NSLog(@"log %@", myCell.participantName.text);
        
        [self.participantNames addObject:[NSString stringWithString:myCell.participantName.text]];

    }
    
    NSLog(@"%@", self.participantNames);
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
    [communicator updateParticipants:self.tournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey withParticipants:self.participantNames block:^(NSError *error) {
        if(!error){
            NSLog(@"Succeed participant array load");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            NSLog(@"Error Message: %@", error);
        }
    }];

    
    
}
    
- (IBAction)addRow:(id)sender {
    num++;
    self.counter.text = [NSString stringWithFormat:@"%i",num];
    [self.participantsArray addObject:[NSString stringWithFormat:@"#%d",num]];
    [self.tableView reloadData];
}

-(void)addRow {
    num++;
    [self.participantsArray addObject:[NSString stringWithFormat:@"#%d",num]];
    [self.tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return num;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
 
    
    cell.textLabel.text = [self.participantsArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

@end