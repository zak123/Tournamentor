//
//  AddParticipantsTableViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/22/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddParticipantTableViewCell.h"
#import "User.h"
#import "Tournament.h"
#import "ChallongeCommunicator.h"

@interface AddParticipantsTableViewController : UITableViewController

@property (nonatomic) User *currentUser;
@property (nonatomic) Tournament *tournament;

@end
