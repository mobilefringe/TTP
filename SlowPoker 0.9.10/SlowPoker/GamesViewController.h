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
@class CellHeaderGeneral;


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
    UIActivityIndicatorView *loadingIndicator;
    
    
    CellHeaderGeneral *header1;
    CellHeaderGeneral *header2;
    CellHeaderGeneral *header3;
    UIActivityIndicatorView *headerActivityIndicatorView1;
    UIActivityIndicatorView *headerActivityIndicatorView2;
    UIActivityIndicatorView *headerActivityIndicatorView3;
    NSString *autoLoadGame;
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
@property(nonatomic,retain)UIActivityIndicatorView *headerActivityIndicatorView1;
@property(nonatomic,retain)UIActivityIndicatorView *headerActivityIndicatorView2;
@property(nonatomic,retain)UIActivityIndicatorView *headerActivityIndicatorView3;
@property(nonatomic,retain)CellHeaderGeneral *header1;
@property(nonatomic,retain)CellHeaderGeneral *header2;
@property(nonatomic,retain)CellHeaderGeneral *header3;
@property(nonatomic,retain)NSString *autoLoadGame;

-(void)updateGames;
-(void)loadGames;
-(void)loadGame:(NSString *)gameID;

@end
