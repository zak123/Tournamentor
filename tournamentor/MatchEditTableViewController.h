//
//  MatchEditTableViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/21/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
#import "ChallongeCommunicator.h"
#import "Tournament.h"
#import "User.h"

@interface MatchEditTableViewController : UITableViewController

@property (nonatomic) Match *selectedMatch;
@property (nonatomic) User *currentUser;
@property (nonatomic) Tournament *currentTournament;


@property (strong) UINavigationBar* navigationBar;

@property (weak, nonatomic) IBOutlet UILabel *player1ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2ScoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *whoWonPicker;
@property (weak, nonatomic) IBOutlet UIStepper *player1Stepper;
@property (weak, nonatomic) IBOutlet UIStepper *player2Stepper;

@end
