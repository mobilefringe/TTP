//
//  SettingsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandEvaluatorViewController;

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    HandEvaluatorViewController *handEvaluatorViewController;
}

@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)HandEvaluatorViewController *handEvaluatorViewController;

@end