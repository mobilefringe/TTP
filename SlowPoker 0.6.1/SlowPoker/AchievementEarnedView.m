//
//  AchievementEarnedView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementEarnedView.h"
#import "AchievementIcon.h"
#import "DataManager.h"

@implementation AchievementEarnedView

@synthesize achievementIcon;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize proChipsLabel;
@synthesize proChipsValueLabel;
@synthesize proChipsLabel2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
        
        self.achievementIcon = [[AchievementIcon alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        achievementIcon.countLabel.hidden = YES;
        achievementIcon.button.enabled = NO;
        achievementIcon.codeLabel.hidden = YES;
        [self addSubview:achievementIcon];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 160, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumFontSize = 10;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:titleLabel];
        
        self.descriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(80, 18, 160, 50)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:descriptionLabel];
        
        grayBlock = [[UIView alloc] initWithFrame:CGRectMake(245, 5, 70, 70)];
        grayBlock.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:grayBlock];
        
        self.proChipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(1,1, 68, 20)];
        proChipsLabel.backgroundColor = [UIColor blackColor];
        proChipsLabel.textAlignment = UITextAlignmentCenter;
        proChipsLabel.textColor = [UIColor whiteColor];
        proChipsLabel.font = [UIFont boldSystemFontOfSize:13];
        proChipsLabel.text = @"Pro Chips";
        [grayBlock addSubview:proChipsLabel];
        
        self.proChipsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(1,19, 68, 9)];
        proChipsLabel2.backgroundColor = [UIColor blackColor];
        proChipsLabel2.textAlignment = UITextAlignmentCenter;
        proChipsLabel2.textColor = [UIColor lightGrayColor];
        proChipsLabel2.font = [UIFont boldSystemFontOfSize:7];
        proChipsLabel2.text = @"Earned";
        [grayBlock addSubview:proChipsLabel2];
        
        self.proChipsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,23, 68, 47)];
        proChipsValueLabel.backgroundColor = [UIColor clearColor];
        proChipsValueLabel.textAlignment = UITextAlignmentCenter;
        proChipsValueLabel.textColor = [UIColor whiteColor];
        proChipsValueLabel.font = [UIFont boldSystemFontOfSize:30];
        [grayBlock addSubview:proChipsValueLabel];
        
    }
    return self;
}

-(void)setAchievementData:(NSMutableDictionary *)achievementData{
    
    [achievementIcon loadAchievment:achievementData];
    NSString *titleKey = [NSString stringWithFormat:@"achievement.%@.title",[achievementData valueForKey:@"code"]];
    titleLabel.text = NSLocalizedString(titleKey,nil);
    if([[achievementData valueForKey:@"code"] isEqualToString:@"LOGIN_DAILY"]){
        titleLabel.text = [titleLabel.text stringByAppendingFormat:@" %@",[DataManager sharedInstance].myUserName];
    }
    
    NSString *messageKey = [NSString stringWithFormat:@"achievement.%@.description",[achievementData valueForKey:@"code"]];
    descriptionLabel.text = NSLocalizedString(messageKey,nil);
    
    proChipsValueLabel.text = [achievementData valueForKey:@"earnedValue"];
    NSMutableDictionary *gamesAchievement = [[DataManager sharedInstance] getGameAchievementForCode:[achievementData valueForKey:@"code"] category:[achievementData valueForKey:@"category"]];
    //NSLog(@"achievementData:%@",achievementData);
    if([[gamesAchievement valueForKey:@"isPrimary"] isEqualToString:@"YES"]){
        grayBlock.hidden = YES;
        proChipsLabel.hidden = YES;
        proChipsLabel2.hidden = YES;
        proChipsValueLabel.hidden = YES;
        achievementIcon.frame = CGRectMake(5, 5, 140, 70);
        achievementIcon.achivementImage.frame = achievementIcon.bounds;
        titleLabel.frame = CGRectMake(150, 5, 160, 20);
        descriptionLabel.frame = CGRectMake(150, 22, 160, 50);
    }else{
        grayBlock.hidden = NO;
        proChipsLabel.hidden = NO;
        proChipsLabel2.hidden = NO;
        proChipsValueLabel.hidden = NO;
        achievementIcon.frame = CGRectMake(5, 5, 70, 70);
        achievementIcon.achivementImage.frame = achievementIcon.bounds;
        titleLabel.frame = CGRectMake(80, 5, 160, 20);
        descriptionLabel.frame = CGRectMake(80, 22, 160, 50);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
