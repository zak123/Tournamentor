//
//  DataHolder.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DataHolder : NSObject

+ (DataHolder *)sharedInstance;

@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *username;

-(void) saveData;
-(void) loadData;

@end