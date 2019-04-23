//
//  AchievementsTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AchievementIcon;

@interface AchievementsTableViewCell : UITableViewCell{
    
    AchievementIcon *achievement1;
    AchievementIcon *achievement2;
    AchievementIcon *achievement3;
    AchievementIcon *achievement4;
    UIImageView *background;
}

-(void)setAchievementData:(NSMutableArray *)achievements;
@property (nonatomic,retain)AchievementIcon *achievement1;
@property (nonatomic,retain)AchievementIcon *achievement2;
@property (nonatomic,retain)AchievementIcon *achievement3;
@property (nonatomic,retain)AchievementIcon *achievement4;

@end
