//
//  AchievementIcon.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchievementIcon : UIView{
    UIImageView *achivementImage;
    NSMutableDictionary *achievement;
    UILabel *countLabel;
    UIButton *button;
    UILabel *codeLabel;
    
}

@property(nonatomic,retain)UIImageView *achivementImage;
@property(nonatomic,retain)NSMutableDictionary *achievement;
@property(nonatomic,retain)UILabel *countLabel;
@property(nonatomic,retain)UIButton *button;
@property(nonatomic,retain)UILabel *codeLabel;
-(void)loadAchievment:(NSMutableDictionary *)achievementParam;
-(void)setGameAchievement:(NSMutableDictionary *)achievementDict;


@end
