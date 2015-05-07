//
//  ResultsTableViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 5/6/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tournament.h"


@interface ResultsTableViewController : UITableViewController

@property (nonatomic) User *currentUser;
@property (nonatomic) Tournament *currentTournament;


@end
