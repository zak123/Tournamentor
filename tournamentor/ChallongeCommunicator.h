//
//  ChallongeCommunicator.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/18/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Tournament.h"

@interface ChallongeCommunicator : NSObject

-(void)getTournaments:(NSString *)username withKey:(NSString *)apiKey block:(void (^)(NSArray *tournamentsArray, NSError *error))completionBlock;

@end
