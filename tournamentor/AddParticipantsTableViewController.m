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
@property (nonatomic) NSMutableArray *participantCountArray;
@property (nonatomic) NSMutableArray *existingParticipantsArray;
@property (nonatomic) NSMutableArray *extraParticipantsArray;

@end

@implementation AddParticipantsTableViewController {
    int num;
}
-(void)viewDidLoad {
    
    self.participantsArray = [[NSMutableArray alloc]init];
    self.participantCountArray = [[NSMutableArray alloc]init];
    
    
    

    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = done;
    
    if ([self.tournament.state isEqualToString:@"pending"]){
        ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
        
        [communicator getParticipants:self.tournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey block:^(NSArray *participants, NSError *error) {
            if (!error){
                NSLog(@"Pending tournamanet participants loaded successfully");
                
                [self.existingParticipantsArray addObjectsFromArray:participants];
                [self.participantsArray addObjectsFromArray:participants];
                
                for (int i = 0; i < participants.count; i++){
                    num = i + 1;
//                    Participant *object = [[Participant alloc]init];
//                    [self.participantsArray addObject:object.name];
                }
                NSString *strFromInt = [NSString stringWithFormat:@"%d",num];
                self.counter.text = strFromInt;
                
                if (self.participantsArray.count > 0){
                    int i;
                    for (i=0;i<self.participantsArray.count; i++){
                        [self.participantCountArray addObject:[NSString stringWithFormat:@"#%d", i+1]];
                    }
                }
                self.extraParticipantsArray[0] = self.existingParticipantsArray[self.existingParticipantsArray.count];
                
                [self.tableView reloadData];
            }
            else {
                NSLog(@"Add participants error:%@", error);
            }
        }];
    }
}




-(void)done {
    
//    if ([self.tournament.state isEqualToString:@"pending"]){
//        
//        for (int i=(int)self.existingParticipantsArray.count; i < self.participantsArray.count; i++) {
//            
//            
//            NSIndexPath *curCell = [NSIndexPath indexPathForRow:i inSection:0];
//            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:curCell];
//            AddParticipantTableViewCell *myCell = (AddParticipantTableViewCell *)cell;
//            
//            [self.participantCountArray addObject:[NSString stringWithString:myCell.participantName.text]];
//            
//        }
//        
//        NSLog(@"%@", self.participantCountArray);
//        
//        ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
//        
//        [communicator updateParticipants:self.tournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey withParticipants:self.participantCountArray block:^(NSError *error) {
//            
//            if(!error){
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//            else{
//                NSLog(@"Error adding participants: %@", error);
//            }
//        }];
//        
//    }
    
    
    for (int i=0; i < self.participantsArray.count; i++) {
        
        
        NSIndexPath *curCell = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:curCell];
        AddParticipantTableViewCell *myCell = (AddParticipantTableViewCell *)cell;
        [self.participantCountArray addObject:[NSString stringWithString:myCell.participantName.text]];
        
    }

    
    NSLog(@"%@", self.participantCountArray);
    
    ChallongeCommunicator *communicator = [[ChallongeCommunicator alloc] init];
    
    [communicator updateParticipants:self.tournament.tournamentURL withUsername:self.currentUser.name andAPIKey:self.currentUser.apiKey withParticipants:self.participantCountArray block:^(NSError *error) {

        if(!error){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            NSLog(@"Error adding participants: %@", error);
        }
    }];

    }
     

     
- (IBAction)addRow:(id)sender {
    num++;
    self.counter.text = [NSString stringWithFormat:@"%i",num];
    Participant *newParticipant = [[Participant alloc]init];
    
    
    [self.participantsArray addObject:newParticipant];
    
    [self.extraParticipantsArray addObject:newParticipant];
    
    [self.participantCountArray addObject:[NSString stringWithFormat:@"#%d",num]];

//    [self.participantsArray addObject:self.participantCountArray[num]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.participantsArray.count-1 inSection:0];
    Participant *object = [self.participantsArray objectAtIndex:indexPath.row];
    AddParticipantTableViewCell *myCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    myCell.participantName.text = object.name;
    
    [self.tableView reloadData];
    NSLog(@"Extra Participant #1: %@", self.extraParticipantsArray[0]);
    NSLog(@"Participant Array Element 6: %@", newParticipant.name);
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.participantsArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddParticipantTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Participant *object = [self.participantsArray objectAtIndex:indexPath.row];
    
    
    myCell.textLabel.text = [self.participantCountArray objectAtIndex:indexPath.row];
    myCell.participantName.text = object.name;
//    myCell.textLabel.text = [self.participantsArray objectAtIndex:indexPath.row];
    
    return myCell;
    
}
     
@end