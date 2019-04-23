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

    AchievementHeaderView *achievementPlatinumHeaderView;
    AchievementHeaderView *achievementGoldView;
    AchievementHeaderView *achievementSilverHeaderView;
    AchievementHeaderView *achievementBronzeHeaderView;
    AchievementHeaderView *achievementBlackHeaderView;
}

@property(nonatomic,retain)UITableView *_tableView;
@property(readwrite)int scrollToSection;
@property(nonatomic,retain)AchievementHeaderView *achievementPlatinumHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementGoldView;
@property(nonatomic,retain)AchievementHeaderView *achievementSilverHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementBronzeHeaderView;
@property(nonatomic,retain)AchievementHeaderView *achievementBlackHeaderView;


@end
