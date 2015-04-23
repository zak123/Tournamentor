//
//  NewTournamentViewController.h
//  
//
//  Created by Zachary Mallicoat on 4/22/15.
//
//

#import <UIKit/UIKit.h>
#import "Tournament.h"
#import "User.h"

@interface NewTournamentViewController : UITableViewController

@property (strong) UINavigationBar* navigationBar;
@property (nonatomic) Tournament *tournament;
@property (nonatomic) User *currentUser;

@property (weak, nonatomic) IBOutlet UITextField *tournamentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *tournamentURLTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tournamentTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *gameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
