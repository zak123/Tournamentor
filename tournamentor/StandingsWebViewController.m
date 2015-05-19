//
//  StandingsWebViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 5/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "StandingsWebViewController.h"


@interface StandingsWebViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@end

@implementation StandingsWebViewController {
        MBProgressHUD *_hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.scalesPageToFit = YES;

    [self setTitle:@"Standings"];
   }

- (void)viewDidAppear:(BOOL)animated {
    
  [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }

    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    [_hud show:YES];
    
    NSString* url = [NSString stringWithFormat:@"http://images.challonge.com/%@.png", self.selectedTournament.tournamentURL];
    
    NSURL* nsUrl = [NSURL URLWithString:url];
    self.webView.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.webView loadRequest:request];

}



-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
