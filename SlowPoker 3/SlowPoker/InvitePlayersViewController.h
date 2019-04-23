//
//  InvitePlayersViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitePlayersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *_tableView;
    UISearchBar *searchBar;
    NSMutableDictionary *searchResult;
    NSMutableDictionary *game;
    BOOL isEditPlayers;
    UIBarButtonItem *barButton;
    UIAlertView *removeAlert;
    UIAlertView *addAlert;
    NSMutableDictionary *tmpPlayerData;
}

@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic,retain)NSMutableDictionary *searchResult;
@property (nonatomic,retain)NSMutableDictionary *game;
@property (nonatomic,retain)UIBarButtonItem *barButton;
@property (nonatomic,retain)UIAlertView *removeAlert;
@property (nonatomic,retain)UIAlertView *addAlert;
@property (nonatomic,retain)NSMutableDictionary *tmpPlayerData;
@property (readwrite)BOOL isEditPlayers;

-(void)addPlayerToGame:(NSMutableDictionary *)addPlayer;
-(void)removePlayerFromGame:(NSMutableDictionary *)removePlayer;
-(BOOL)hasPlayerBeenInvited:(NSMutableDictionary *)invitePlayer;

@end
