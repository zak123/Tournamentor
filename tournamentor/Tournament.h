//
//  Tournament.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/20/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tournament : NSObject

@property (nonatomic) NSString *state;
@property (nonatomic) NSString *tournamentName;
@property (nonatomic) NSString *numberParticipants;
@property (nonatomic) NSString *tournamentURL;
@property (nonatomic) NSString *tournamentDescription;
@property (nonatomic) NSString *tournamentType;
@property (nonatomic) NSNumber *progress;


@end
