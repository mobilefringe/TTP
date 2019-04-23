//
//  GameSettingsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@class  MFButton;
@class InvitePlayersViewController;

@interface GameSettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSString *gameType;
    UITableView *_tableView;
    NSMutableDictionary *game;
    InvitePlayersViewController *invitePlayersViewController;
    double handsMax;
    

    
}

@property (nonatomic,retain)NSString *gameType;
@property (nonatomic,retain)UITableView *_tableView;
@property (nonatomic,retain)NSMutableDictionary *game;
@property (nonatomic,retain)InvitePlayersViewController *invitePlayersViewController;


@end
