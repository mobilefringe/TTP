//
//  GameDetailsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvitePlayersViewController;

@interface GameDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *game;
    UITableView *_tableView;
    InvitePlayersViewController *invitePlayersViewController;
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,retain)NSMutableDictionary *game;
@property (nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)InvitePlayersViewController *invitePlayersViewController;
@property (nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;

@end
