//
//  MatchListTableViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/21/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChallongeCommunicator.h"
#import "Match.h"
#import "DataHolder.h"
#import "MatchListTableViewCell.h"
#import "Tournament.h"
#import "User.h"
#import "MatchEditTableViewController.h"


@interface MatchListTableViewController : UITableViewController

@property (nonatomic) Tournament *selectedTournament;
@property (nonatomic) User *currentUser;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *apiKey;




@property (nonatomic, strong) UIView *centralView;



@end
