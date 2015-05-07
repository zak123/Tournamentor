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
        tourn.progress = aTournament[@"progress_meter"];
        tourn.state = aTournament[@"state"];
        tourn.tournamentType = aTournament[@"tournament_type"];
        
        
        
        
       
        

        [tournamentArray addObject:tourn];
        
        
    }
//    NSError *error1 = nil;
    
    completionBlock(tournamentArray, nil);

    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"getTournaments HTTP Request Failed With Challong Error: %@", error);
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
               
                if (match.player1_id == nil || [match.player1_id isKindOfClass:[NSNull class]]) {
                    
                }else {
                
                if ([aParticipant[@"id"] isEqualToNumber:match.player1_id]){
                    match.player1_name = aParticipant[@"display_name"];
                }
                }
                if (match.player2_id == nil || [match.player2_id isKindOfClass:[NSNull class]]) {
                    
                }else {
            
                if ([aParticipant[@"id"] isEqualToNumber: match.player2_id]){
                    match.player2_name = aParticipant[@"display_name"];
                
                }
                }
                
            }
            
            

            
        }



        
        //    NSError *error1 = nil;
        
        completionBlock(matchesArray, nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Getting Matches Failed With Error: %@", error);
        completionBlock(nil, error);
    }];

    
    
}

-(void)updateMatchForTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key forMatchID:(NSNumber *)matchID withScores:(NSString *)scores winnerID:(NSNumber *)winnerID block:(void (^)(NSError *error))completionBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/matches/%@.json", username, key, tournament, matchID];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    NSDictionary *parameters = @{@"match[winner_id]": winnerID,@"match[scores_csv]": scores};
                                                                 
    
    [manager PUT:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Updating Match Failed With Error: %@", error);
    }];
   
}

-(void)updateParticipants:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key withParticipants:(NSArray *)participants block:(void (^)(NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/participants/bulk_add.json", username, key, tournament];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //
    BOOL valid = YES;
    
    NSMutableArray *participantsNames = [NSMutableArray array];
    for (Participant *participant in participants) {
        if (participant.name != nil) {
        [participantsNames addObject:participant.name];
        }
        else {
            valid = NO;
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Participant names cannot be empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [error show];
        }
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSSet setWithArray:participantsNames], @"participants[][name]", nil];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    
    [manager POST:urlString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (valid) {
        completionBlock(nil);
        }
        else {
            NSError *error;
            error = [NSError errorWithDomain:@"Communicator" code:123 userInfo:nil];
        completionBlock(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
}

-(void)deleteTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@.json", username, key, tournament];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
}

-(void)startTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock {
       NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/start.json", username, key, tournament];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
}
-(void)resetTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/reset.json", username, key, tournament];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
}
-(void)endTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/finalize.json", username, key, tournament];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(error);
    }];
    
}
-(void)getParticipants:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSArray *participants, NSError *error))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.challonge.com/v1/tournaments/%@/participants.json", username, key, tournament];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSMutableArray *participantsArray = [[NSMutableArray alloc]init];
            
//            NSArray *tournamentParticipants = responseObject[@"participant"];
            
            for (id eachParticipant in responseObject) {
                
                Participant *participant = [[Participant alloc]init];
                NSDictionary *aParticipant = eachParticipant[@"participant"];
                
                participant.name = aParticipant[@"display_name"];
                participant.finalRank = aParticipant[@"final_rank"];
                participant.participantID = aParticipant[@"id"];
                
                
                [participantsArray addObject:participant];
            }
            
            completionBlock(participantsArray, nil);
            

            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting participants: %@", error);
    }];
    
}


@end
