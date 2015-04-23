//
//  AddParticipantsTableViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/22/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "AddParticipantsTableViewController.h"

@interface AddParticipantsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *counter;

@property (nonatomic) NSMutableArray *participantsArray;

@end

@implementation AddParticipantsTableViewController {
    int num;
}
-(void)viewDidLoad {
    
    self.participantsArray = [[NSMutableArray alloc]init];
    
    

    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = done;
    
    
    
}
- (IBAction)edited:(id)sender {
    
    
}

-(void)done {
    
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