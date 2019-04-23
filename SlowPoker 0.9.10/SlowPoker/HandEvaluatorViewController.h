//
//  HandEvaluatorViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardsSelectorViewController;

@interface HandEvaluatorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *communityCards;
    NSMutableArray *hands;
    CardsSelectorViewController *cardsSelectorViewController;
    NSMutableArray *fullHands;
    int highHandValue;
}

@property(nonatomic,retain)UITableView *_tableView;
@property(nonatomic,retain)NSMutableArray *communityCards;
@property(nonatomic,retain)NSMutableArray *hands;
@property(nonatomic,retain)CardsSelectorViewController *cardsSelectorViewController;
@property(nonatomic,retain)NSMutableArray *fullHands;
-(void)resetHands;

@end
