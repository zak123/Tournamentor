//
//  DataHolder.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//


#import "DataHolder.h"

NSString * const kAPIKey = @"kKey";
NSString * const kUsername = @"kName";


@implementation DataHolder

- (id) init
{
    self = [super init];
    if (self)
    {
        _apiKey = 0;
        _username = 0;
    }
    return self;
}

+ (DataHolder *)sharedInstance
{
    static DataHolder *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                      
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      
                      [defaults registerDefaults:@{ kAPIKey : @"", kUsername : @"" }];
                      
                      [defaults synchronize];
                      
                      [_sharedInstance loadData];
                  });
    
    return _sharedInstance;
}

//in this example you are saving data to NSUserDefault's
//you could save it also to a file or to some more complex
//data structure: depends on what you need, really

-(void)saveData
{
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSString stringWithString:self.apiKey] forKey:kAPIKey];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSString stringWithString:self.username] forKey:kUsername];
    

    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadData
{
    
    self.apiKey = (NSString *)[[NSUserDefaults standardUserDefaults]
                                    objectForKey:kAPIKey];
    
    self.username = (NSString *)[[NSUserDefaults standardUserDefaults]
                                        objectForKey:kUsername];
    
}

@end