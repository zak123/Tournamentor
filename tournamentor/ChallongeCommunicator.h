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
#import "Match.h"
#import "Participant.h"

@interface ChallongeCommunicator : NSObject

# pragma - getting data from challonge

-(void)getTournaments:(NSString *)username withKey:(NSString *)apiKey block:(void (^)(NSArray *tournamentsArray, NSError *error))completionBlock;

-(void)getMatchesForTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSArray *matchArray, NSError *error))completionBlock;

-(void)getParticipants:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSArray *participants, NSError *error))completionBlock;

# pragma - putting data to challonge

-(void)updateMatchForTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key forMatchID:(NSNumber *)matchID withScores:(NSString *)scores winnerID:(NSNumber *)winnerID block:(void (^)(NSError *error))completionBlock;

-(void)addNewTournament:(NSString *)tournamentName withUsername:(NSString *)username andAPIKey:(NSString *)key andTournamentURL:(NSString *)URL andTournamentType:(NSString *)type andTournamentDescription:(NSString *)description block:(void (^)(NSError *error))completionBlock;

-(void)updateParticipants:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key withParticipants:(NSArray *)participants block:(void (^)(NSError *error))completionBlock;

# pragma - updating tournament state

-(void)deleteTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock;

-(void)startTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock;

-(void)resetTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock;

-(void)endTournament:(NSString *)tournament withUsername:(NSString *)username andAPIKey:(NSString *)key block:(void (^)(NSError *error))completionBlock;



@end
