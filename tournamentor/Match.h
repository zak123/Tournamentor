//
//  Match.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/21/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic) NSString *state;
@property (nonatomic) NSNumber *player1_id;
@property (nonatomic) NSNumber *player2_id;
@property (nonatomic) NSString *player1_name;
@property (nonatomic) NSString *player2_name;
@property (nonatomic) NSString *round;
@property (nonatomic) NSString *matchID;
@property (nonatomic) NSString *bracketID;
@property (nonatomic) NSString *score;
@property (nonatomic) NSString *winner_id;

@end
