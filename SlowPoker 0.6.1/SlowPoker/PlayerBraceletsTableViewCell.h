//
//  PlayerBraceletsTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AchievementIcon;

@interface PlayerBraceletsTableViewCell : UITableViewCell{
    UILabel *categoryLabel;
    UILabel *topBraceletsLabel;
    AchievementIcon *primaryAchievement;
    AchievementIcon *secondaryAchievement1;
    AchievementIcon *secondaryAchievement2;
    AchievementIcon *secondaryAchievement3;
    UILabel *moreLabel;
}

@property (nonatomic,retain)UILabel *categoryLabel;
@property (nonatomic,retain)UILabel *topBraceletsLabel;
@property (nonatomic,retain)AchievementIcon *primaryAchievement;
@property (nonatomic,retain)AchievementIcon *secondaryAchievement1;
@property (nonatomic,retain)AchievementIcon *secondaryAchievement2;
@property (nonatomic,retain)AchievementIcon *secondaryAchievement3;
@property (nonatomic,retain)UILabel *moreLabel;
-(void)setBraceletData:(NSMutableDictionary *)playerProfieDict category:(NSString *)category;

@end
