//
//  WebViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 4/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHolder.h"
#import "TournamentListTableViewController.h"
#import "User.h"

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
