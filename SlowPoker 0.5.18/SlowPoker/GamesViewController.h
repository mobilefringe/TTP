//
//  GamesViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@class TurnsViewController;
@class NewGameSelectionViewController;
@class GameDetailsViewController;


@interface GamesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    UIActivityIndicatorView *activityIndicatorView;
    UILabel *updatingMessage;
    TurnsViewController *turnsViewController;
    NewGameSelectionViewController *theNewGameSelectionViewController;
    UINavigationController *navController;
    GameDetailsViewController *gameDetailsViewController;
    NSTimer *refreshTimer;
    NSMutableDictionary *deleteGame;
    UIAlertView *deleteGameAlert;
    UIAlertView *joinGameAlert;
    
}


@property(nonatomic,retain)UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic,retain)UILabel *updatingMessage;
@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)TurnsViewController *turnsViewController;
@property(nonatomic,retain)NewGameSelectionViewController *theNewGameSelectionViewController;
@property(nonatomic,retain)UINavigationController *navController;
@property(nonatomic,retain)GameDetailsViewController *gameDetailsViewController;
@property(nonatomic,retain)NSTimer *refreshTimer;
@property(nonatomic,retain)NSMutableDictionary *deleteGame;
@property(nonatomic,retain)UIAlertView *deleteGameAlert;
@property(nonatomic,retain)UIAlertView *joinGameAlert;
-(void)updateGames;

@end
