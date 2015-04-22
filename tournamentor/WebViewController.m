//
//  WebViewController.m
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "WebViewController.h"
#import <MBProgressHUD.h>
#import <SSKeychain/SSKeychain.h>
#import <SSKeychain/SSKeychainQuery.h>

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

        
        [SSKeychain setPassword:APIKEY forService:@"Challonge" account:USERNAME];


        
        NSString *completedDialog = [NSString stringWithFormat:@"%@, you are now signed into your Challonge account. hit OK to use Tournamentor.", USERNAME];
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Signed In"
                                                         message:completedDialog
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        

        
    }
    else {
        NSString *error = [self getError:plainHTML];
        
        if ([self.webView.request.URL.absoluteString isEqualToString:@"https://challonge.com/settings/developer"] && [error isEqualToString:@"API keys can only be issued to users with a verified email. Please verify your email address by following the link that was emailed to you. "]) {
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Email Verification Error"
                                                         message:@"Make sure you have verified your email address with Challonge.com, you can resend the verification e-mail by going to http://challonge.com/settings/developer and hitting \"send new link.\" Once you have done this, hit OK."
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles: nil];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        }
        else {
            //maybe programatically click button?
        }
        
        
    }

    
    
    [_hud hide:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self showTournamentListView];
}

# pragma helper methods

-(void)showTournamentListView {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

-(NSString *)getError:(NSString *)plainHTML {
    NSString *error = @"";
// <a data-method="post" href="/settings/resend_activation_key" rel="nofollow">Send a new link.</a>
    @try {
        NSScanner *scanner = [[NSScanner alloc]initWithString:plainHTML];
        [scanner scanUpToString:@"<div class=\"alert alert-danger\">" intoString:nil];
        [scanner scanString:@"<div class=\"alert alert-danger\">" intoString:nil];
        [scanner scanUpToString:@"<a data-method=\"post\" href=\"/settings/resend_activation_key\"" intoString:&error];
        NSLog(@"%@", error);
    }
    @catch (NSException *exception) {}
    
    error = [error stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    
    
    
    return error;
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
