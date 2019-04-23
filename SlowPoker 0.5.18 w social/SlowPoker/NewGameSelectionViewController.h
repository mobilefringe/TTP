//
//  NewGameSelectionViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameSettingsViewController;

@interface NewGameSelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UINavigationController *navController;
    GameSettingsViewController *gameSettingsViewController;
     UITableView *_tableView;
}

@property(nonatomic,retain)UINavigationController *navController;
@property(nonatomic,retain)GameSettingsViewController *gameSettingsViewController;
@property(nonatomic,retain)UITableView *_tableView;

@end
