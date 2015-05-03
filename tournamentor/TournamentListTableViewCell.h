//
//  TournamentListTableViewCell.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/20/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TournamentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tournamentNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tournamentImage;
@property (weak, nonatomic) IBOutlet UILabel *numPeopleLabel;

@end
