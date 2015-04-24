//
//  BracketCollectionViewController.h
//  tournamentor
//
//  Created by Brian Khoshbakht on 2015-04-23.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@class Match;
@class Tournament;


@interface BracketCollectionView : UICollectionView

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) Match *match;
@property (nonatomic) NSArray *matches;
@property (nonatomic, strong) Tournament *selectedTournament;


@end
