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
        NSArray *participants = responseObject[@"tournament"][@"participants"];
        
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
            
            for (id eachParticipant in participants){
                
                NSDictionary *aParticipant = eachParticipant[@"participant"];
                if (aParticipant[@"id"] == match.player1_id){
                    match.player1_name = aParticipant[@"display_name"];
                }
                if (aParticipant[@"id"] == match.player2_id){
                    match.player2_name = aParticipant[@"display_name"];
                }
                
            }
            
        }


            
        
        //    NSError *error1 = nil;
        
        completionBlock(matchesArray, nil);
        NSLog(@"Success");
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP Request Failed");
        completionBlock(nil, error);
    }];

    
    
}

-(void)updateMatchForTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key forMatchID:(NSNumber *)matchID withScores:(NSString *)scores winnerID:(NSNumber *)winnerID block:(void (^)(NSError *error))completionBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/matches/%@.json", username, key, tournament, matchID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    NSDictionary *parameters = @{@"match[winner_id]": winnerID,@"match[scores_csv]": scores};
                                                                 
    
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SUCCEEEEEEDEDDDDD");
        
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
    
    
    
}

-(void)addNewTournament:(NSString *)tournamentName withUsername:(NSString *)username andAPIKey:(NSString *)key andTournamentURL:(NSString *)URL andTournamentType:(NSString *)type andTournamentDescription:(NSString *)description block:(void (^)(NSError *error))completionBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments.json", username, key];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    NSDictionary *parameters = @{@"tournament[name]": tournamentName, @"tournament[url]": URL, @"tournament[tournament_type]":type, @"tournament[description]":description};
    
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Succeed Goddamnit!");
        
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
    
    
    
}


-(void)updateMatch:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key andWinnerID:(NSNumber *)winnderID andMatchID:(NSNumber *)matchID andScore:(NSString *)score block:(void (^)(NSError *error))completionBlock{
    //https://api.challonge.com/v1/tournaments/{tournament}/matches/{match_id}.{json|xml}
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"winner_id":winnderID, @"match_id":matchID, @"scores_csv":score};
    
    [manager PUT:@"https://%@:%@@api.challonge.com/v1/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success PUT");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure POST");
    }];
    
    
    
    
    
    
//    NSURLS *client = [AFHTTPClient clientWithBaseURL:@"https://%@:%@@api.challonge.com/v1/",  username, key];
//    

//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"PUT"];
    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operation start];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
    
        
        
//        NSLog(@"THIS IS RESPONSE OBJECT %@ THIS IS RESPONSE OBJECT", responseObject);
//        
//        NSLog(@"Done setting PUT");
//        
//        
//        
//        
//        //    NSError *error1 = nil;
//        
//        completionBlock(nil);
//        
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"HTTP Request Failed");
//        completionBlock(error);
//    }];

    
    
    
}


@end
