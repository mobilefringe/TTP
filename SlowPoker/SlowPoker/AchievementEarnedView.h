//
//  AchievementEarnedView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AchievementIcon;

@interface AchievementEarnedView : UIView{
    AchievementIcon *achievementIcon;
    UILabel *titleLabel;
    UITextView *descriptionLabel;
    UILabel *proChipsLabel;
    UILabel *proChipsLabel2;
    UILabel *proChipsValueLabel;
    UIView *grayBlock;
    UIImageView *proChipImageView;
    
    
}

@property (nonatomic,retain)AchievementIcon *achievementIcon;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UITextView *descriptionLabel;
@property (nonatomic,retain)UILabel *proChipsLabel;
@property (nonatomic,retain)UILabel *proChipsLabel2;
@property (nonatomic,retain)UILabel *proChipsValueLabel;
@property (nonatomic,retain)UIImageView *proChipImageView;

-(void)setAchievementData:(NSMutableDictionary *)achievementData;

@end
