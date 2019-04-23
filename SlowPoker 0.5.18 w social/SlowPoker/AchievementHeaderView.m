//
//  AchievementHeaderView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementHeaderView.h"
#import "DataManager.h"

@implementation AchievementHeaderView

@synthesize achivementImage;
@synthesize achievement;
@synthesize countLabel;
@synthesize button;
@synthesize codeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        
        self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 170, 15)];
        codeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        codeLabel.adjustsFontSizeToFitWidth = YES;
        codeLabel.minimumFontSize = 6;
        codeLabel.font = [UIFont boldSystemFontOfSize:12];
        codeLabel.textAlignment = UITextAlignmentCenter;
        codeLabel.textColor = [UIColor whiteColor];
        [self addSubview:codeLabel];
        
        self.achivementImage = [[UIImageView alloc] initWithFrame:CGRectMake(75, 25, 170, 60)];
        achivementImage.userInteractionEnabled = YES;
        [self addSubview:achivementImage];

        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 70, 30, 15)];
        countLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        countLabel.font = [UIFont boldSystemFontOfSize:12];
        countLabel.adjustsFontSizeToFitWidth = YES;
        countLabel.minimumFontSize = 7;
        countLabel.textAlignment = UITextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        [self addSubview:countLabel];
        
                
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 170, 60);
        button.backgroundColor = [UIColor clearColor];
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(pressAchievement) forControlEvents:UIControlEventTouchUpInside];
        [achivementImage addSubview:button];

    }
    return self;
}


-(void)loadAchievment:(NSMutableDictionary *)achievementParam{
    NSString *imageKey = [NSString stringWithFormat:@"achievement.%@.imageLocked",[achievementParam valueForKey:@"code"]];
    //NSLog(@"code:%@",code);
    if([[DataManager sharedInstance] getCountForUserAchievement:achievementParam] > 0){
        imageKey = [NSString stringWithFormat:@"achievement.%@.imageUnLocked",[achievementParam valueForKey:@"code"]];
    }else{
        imageKey = [NSString stringWithFormat:@"achievement.%@.imageLocked",[achievementParam valueForKey:@"code"]];
        
    }
    
    NSString *titleKey = [NSString stringWithFormat:@"achievement.%@.title",[achievementParam valueForKey:@"code"]];
    codeLabel.text = NSLocalizedString(titleKey,nil);
    NSString *imageName = NSLocalizedString(imageKey,nil);
    [achivementImage setImage:[UIImage imageNamed:imageName]];
    int count = [[DataManager sharedInstance] getCountForUserAchievement:achievementParam];
    if(count > 0){
        countLabel.hidden = NO;
        countLabel.text = [NSString stringWithFormat:@"%dx",count];
    }else{
        countLabel.hidden = YES;
    }

    
}

-(void)setGameAchievement:(NSMutableDictionary *)achievementDict{
    self.achievement = achievementDict;
    [self loadAchievment:achievementDict];
}

-(void)pressAchievement{
    if(self.achievement){
        [DataManager sharedInstance].showAchievement = achievement;
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
