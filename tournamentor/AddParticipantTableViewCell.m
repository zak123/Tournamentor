//
//  AddParticipantTableViewCell.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/22/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "AddParticipantTableViewCell.h"

@implementation AddParticipantTableViewCell 

- (void)awakeFromNib {
    // Initialization code
    
    self.participant = [[Participant alloc] init];
    self.participantName.delegate = self;
    
    [self.participantName addTarget:self action:@selector(changedName:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changedName:(UITextField *)textField {
    
    self.participant.name = textField.text;
}

- (void)setupParticipant:(Participant *)participant andTag:(NSInteger)tag andParticipantsCount:(NSMutableArray *)participantsCount {
    self.participant = participant;
    self.participantName.tag = tag;
    self.participantName.text = participant.name;
    self.textLabel.text = [participantsCount objectAtIndex:tag];
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.participantName.textColor = [UIColor whiteColor];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
