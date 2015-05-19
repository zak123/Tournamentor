//
//  StandingsWebViewController.h
//  tournamentor
//
//  Created by Zachary Mallicoat on 5/17/15.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tournament.h"
#import "User.h"
#import <MBProgressHUD.h>


@interface StandingsWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) Tournament *selectedTournament;

@end
