//
//  AddParticipantTableViewCell.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/22/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant.h"

@interface AddParticipantTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *participantName;
@property (strong, nonatomic) Participant *participant;

- (void)setupParticipant:(Participant *)participant andTag:(NSInteger)tag andParticipantsCount:(NSMutableArray *)participantsCount;

@end
