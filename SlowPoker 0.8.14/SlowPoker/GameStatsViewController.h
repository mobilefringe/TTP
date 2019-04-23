//
//  GameStatsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyNowCell;

@interface GameStatsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *activePlayers;
    double maxPFA;
    UIAlertView *confirmBuy;
    BuyNowCell *buyCell;
    UIActivityIndicatorView *loadingIndicator;
    
}

@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)NSMutableArray *activePlayers;
@property(nonatomic,retain)UIAlertView *confirmBuy;
@property(nonatomic,retain)BuyNowCell *buyCell;
-(void)loadGameStats;
-(void)loadProGameStats;
-(void)incrementPlayerStat:(NSMutableDictionary *)playerStats code:(NSString *)code value:(double)value;
-(NSNumber *)getCountForPlayer:(NSString *)userID code:(NSString *)code;
-(void)scrollToTop;
@end
