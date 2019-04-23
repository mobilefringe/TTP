//
//  PlayerStatsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyNowCell;

@interface PlayerStatsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    UILabel *footerView;
    UIBarButtonItem *lockStatsButton;
    BOOL isStatsLocked;
    BuyNowCell *buyCell;
    UIAlertView *confirmBuy;

    
}

@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)UILabel *footerView;
@property(nonatomic,retain)UIBarButtonItem *lockStatsButton;
@property(nonatomic,retain)BuyNowCell *buyCell;
@property(nonatomic,retain)UIAlertView *confirmBuy;
-(double)statDouble:(NSString *)statCode;

@end
