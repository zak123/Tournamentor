//
//  ChallongeCommunicator.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/18/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "ChallongeCommunicator.h"

@implementation ChallongeCommunicator

-(void)getTournaments:(NSString *)username withKey:(NSString *)apiKey block:(void (^)(NSArray *tournamentsArray, NSError *error))completionBlock {

    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments.json", username, apiKey];
    
    
NSURL *url = [NSURL URLWithString:urlString];
NSURLRequest *request = [NSURLRequest requestWithURL:url];

AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
operation.responseSerializer = [AFJSONResponseSerializer serializer];
[operation start];
[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
    
    
    
    NSMutableArray *tournamentArray = [[NSMutableArray alloc]init];
    
    
    for (id eachTournament in responseObject) {
        
        Tournament *tourn = [[Tournament alloc]init];
        NSDictionary *aTournament = eachTournament[@"tournament"];
        
        tourn.tournamentName = aTournament[@"name"];
        tourn.numberParticipants = aTournament[@"participants_count"];
        tourn.tournamentURL = aTournament[@"url"];
        
        
        
        NSLog(@"%@", tourn.tournamentName);
        

        [tournamentArray addObject:tourn];
        
        
    }
//    NSError *error1 = nil;
    
    completionBlock(tournamentArray, nil);
    NSLog(@"Success");

    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"HTTP Request Failed");
    completionBlock(nil, error);
}];
}


-(void)getMatchesForTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSArray *matchArray, NSError *error))completionBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@.json?include_matches=1&include_participants=1",  username, key, tournament];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        
        NSMutableArray *matchesArray = [[NSMutableArray alloc]init];
        
        NSArray *tournamentMatches = responseObject[@"tournament"][@"matches"];
        
        
        for (id eachMatch in tournamentMatches) {
            
            Match *match = [[Match alloc]init];
            NSDictionary *aMatch = eachMatch[@"match"];
            
            match.player1_id = aMatch[@"player1_id"];
            match.player2_id = aMatch[@"player2_id"];
            match.round = aMatch[@"round"];
            match.state = aMatch[@"state"];
            match.score = aMatch[@"scores_csv"];
            match.winner_id = aMatch[@"winner_id"];
            match.matchID = aMatch[@"id"];
            match.bracketID = aMatch[@"identifier"];
            
            [matchesArray addObject:match];
            
        }
        //    NSError *error1 = nil;
        
        completionBlock(matchesArray, nil);
        NSLog(@"Success");
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP Request Failed");
        completionBlock(nil, error);
    }];

    
    
}



@end
