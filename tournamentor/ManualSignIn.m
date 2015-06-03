//
//  ManualSignIn.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 6/2/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "ManualSignIn.h"
#import <RETableViewManager.h>
#import "TournamentListTableViewController.h"
#import <SSKeychain/SSKeychain.h>
#import <SSKeychain/SSKeychainQuery.h>

@interface ManualSignIn ()

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, readwrite, nonatomic) RETextItem *usernameField;
@property (strong, readwrite, nonatomic) RETextItem *apiKeyField;


@end

@implementation ManualSignIn


-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlStr = @"http://challonge.com/settings/developer";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.webView loadRequest:request];
    
    self.manager = [[RETableViewManager alloc]initWithTableView:self.tableView];
    
    RETableViewSection *loginInfo = [RETableViewSection sectionWithHeaderTitle:@"Login Info"];
    [self.manager addSection:loginInfo];
    
    self.usernameField = [RETextItem itemWithTitle:@"Username" value:@"" placeholder:@"Required"];
    self.apiKeyField = [RETextItem itemWithTitle:@"API Key" value:@"" placeholder:@"challonge.com/settings/developer"];
    
    [loginInfo addItem:self.usernameField];
    [loginInfo addItem:self.apiKeyField];
    
    RETableViewSection *button = [RETableViewSection section];
    [self.manager addSection:button];
    
    RETableViewItem *buttonItem = [RETableViewItem itemWithTitle:@"Done" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [SSKeychain setPassword:self.apiKeyField.value forService:@"Challonge" account:self.usernameField.value];
        
        [self performSegueWithIdentifier:@"showTournaments" sender:self];
    }];
    
    [button addItem:buttonItem];
    
    
    
    
}


@end
