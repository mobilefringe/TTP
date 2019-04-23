//
//  AchievementIcon.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementIcon.h"
#import "Datamanager.h"


@implementation AchievementIcon

@synthesize achivementImage;
@synthesize achievement;
@synthesize countLabel;
@synthesize button;
@synthesize codeLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.achivementImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:achivementImage];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 15)];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont boldSystemFontOfSize:12];
        countLabel.textAlignment = UITextAlignmentCenter;
        countLabel.textColor = [UIColor whiteColor];
        [self addSubview:countLabel];
        
        self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -10, frame.size.width, 10)];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.adjustsFontSizeToFitWidth = YES;
        codeLabel.minimumFontSize = 6;
        codeLabel.font = [UIFont boldSystemFontOfSize:8];
        codeLabel.textAlignment = UITextAlignmentCenter;
        codeLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self addSubview:codeLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.backgroundColor = [UIColor clearColor];
        //button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(pressAchievement) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        
    }
    return self;
}


-(void)loadAchievment:(NSMutableDictionary *)achievementParam{
    NSString *imageKey = [NSString stringWithFormat:@"achievement.%@.imageLocked",[achievementParam valueForKey:@"code"]];
    //NSLog(@"achievementParam:%@",achievementParam);
    if([[DataManager sharedInstance] getCountForUserAchievement:achievementParam] > 0){
        imageKey = [NSString stringWithFormat:@"achievement.%@.imageUnLocked",[achievementParam valueForKey:@"code"]];
    }else{
        imageKey = [NSString stringWithFormat:@"achievement.%@.imageLocked",[achievementParam valueForKey:@"code"]];
        
    }
    
    NSString *titleKey = [NSString stringWithFormat:@"achievement.%@.title",[achievementParam valueForKey:@"code"]];
    codeLabel.text = NSLocalizedString(titleKey,nil);
    NSString *imageName = NSLocalizedString(imageKey,nil);
    [achivementImage setImage:[UIImage imageNamed:imageName]];
    countLabel.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getCountForUserAchievement:achievementParam]];
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



@end
