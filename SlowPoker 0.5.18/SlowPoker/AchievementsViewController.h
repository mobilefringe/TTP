//
//  AchievementsViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AchievementHeaderView;

@interface AchievementsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    int scrollToSection;
    UILabel *footerView1;
    UILabel *footerView2;
    UILabel *footerView3;
    UILabel *footerView4;
    UILabel *footerView5;
    AchievementHeaderView *achievementPlatinumHeaderView;
    AchievementHeaderView *achievementGoldView;
    AchievementHeaderView *achievementSilverHeaderView;
    AchievementHeaderView *achievementBronzeHeaderView;
    AchievementHeaderView *achievementBlackHeaderView;
}

@property(nonatomic,retain)UITableView *_tableView;
@property(readwrite)int scrollToSection;
@property(nonatomic,retain)UILabel *footerView1;
@property(nonatomic,retain)UILabel *footerView2;
@property(nonatomic,retain)UILabel *footerView3;
@property(nonatomic,retain)UILabel *footerView4;
@property(nonatomic,retain)UILabel *footerView5;
@property(nonatomic,retain)AchievementHeaderView *achievementPlatinumHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementGoldView;
@property(nonatomic,retain)AchievementHeaderView *achievementSilverHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementBronzeHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementBlackHeaderView;


@end
