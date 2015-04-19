//
//  WebViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "WebViewController.h"
#import <MBProgressHUD.h>

@interface WebViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@end

@implementation WebViewController{
    MBProgressHUD *_hud;
    User *user;
}

-(void)viewDidLoad {

    [super viewDidLoad];
    


    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";


    NSString* url = @"https://challonge.com/settings/developer";

    NSURL* nsUrl = [NSURL URLWithString:url];
    self.webView.delegate = self;
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.webView loadRequest:request];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma - Web View

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_hud show:YES];
    NSLog(@"Loadin Again");
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    

    
    NSString *plainHTML = [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    NSLog(@"%@", plainHTML);
    NSString *APIKEY = [self getAPIKey:plainHTML];
    NSString *USERNAME = [self getUsername:plainHTML];
    
 
    NSLog(@"API KEY: %@", APIKEY);
    NSLog(@"done");
    
    
    if (APIKEY.length > 1) {
        [DataHolder sharedInstance].apiKey = APIKEY;
        
        [[DataHolder sharedInstance] saveData];
        
        User *newUser = [[User alloc]init];
        newUser.apiKey = APIKEY;
        newUser.name = USERNAME;
        
        user = newUser;
        
        NSString *completedDialog = [NSString stringWithFormat:@"%@, you are now signed into your Challonge account. hit OK to use Tournamentor.", newUser.name];
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Signed In"
                                                         message:completedDialog
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        

        
    }
    
    
    [_hud hide:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self showTournamentListView];
}

# pragma helper methods

-(void)showTournamentListView {
    TournamentListTableViewController *VC = [[TournamentListTableViewController alloc] init];
    
    VC.user = user;
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(NSString *)getAPIKey:(NSString *)plainHTML
{
    NSString *key = @"";
    @try{
        NSScanner *scanner = [[NSScanner alloc] initWithString:plainHTML];
        [scanner scanUpToString:@"<code>" intoString:nil];
        [scanner scanString:@"<code>" intoString:nil];
        [scanner scanUpToString:@"</code>" intoString:&key];
    }
    @catch(NSException *ex)
    {}
    return key;
}

-(NSString *)getUsername:(NSString *)plainHTML {
    NSString *username = @"";
    
    @try {
        NSScanner *scanner = [[NSScanner alloc]initWithString:plainHTML];
        [scanner scanUpToString:@"<a class=\"dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">" intoString:nil];
        [scanner scanString:@"<a class=\"dropdown-toggle\" data-toggle=\"dropdown\" href=\"#\">" intoString:nil];
        [scanner scanUpToString:@"<b class=\"caret\">" intoString:&username];
        NSLog(@"%@", username);
    }
    @catch (NSException *exception) {}
    
    username = [username stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    
    return username;
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
