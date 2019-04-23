//
//  AchievementsTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AchievementsTableViewCell.h"
#import "AchievementIcon.h"

@implementation AchievementsTableViewCell

@synthesize achievement1;
@synthesize achievement2;
@synthesize achievement3;
@synthesize achievement4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    int xOffset = 72;
    int yOffset = 5;
    if (self) {
        self.achievement1 = [[AchievementIcon alloc] initWithFrame:CGRectMake(10, 10+yOffset, 65, 65)];
        [self.contentView addSubview:achievement1];
        
        self.achievement2 = [[AchievementIcon alloc] initWithFrame:CGRectMake(10+xOffset, 10+yOffset, 65, 65)];
        [self.contentView addSubview:achievement2];
        
        self.achievement3 = [[AchievementIcon alloc] initWithFrame:CGRectMake(10+2*xOffset, 10+yOffset, 65, 65)];
        [self.contentView addSubview:achievement3];
        
        self.achievement4 = [[AchievementIcon alloc] initWithFrame:CGRectMake(10+3*xOffset, 10+yOffset, 65, 65)];
        [self.contentView addSubview:achievement4];
    }
    return self;
}


-(void)setAchievementData:(NSMutableArray *)achievements{
    achievement1.hidden = YES;
    achievement2.hidden = YES;
    achievement3.hidden = YES;
    achievement4.hidden = YES;
    
    for(int i = 0; i < [achievements count]; i++){
        if(i==0){
            achievement1.hidden = NO;
            [achievement1 setGameAchievement:[achievements objectAtIndex:i]];
        }else if(i==1){
            achievement2.hidden = NO;
            [achievement2 setGameAchievement:[achievements objectAtIndex:i]];
        }else if(i==2){
            achievement3.hidden = NO;
            [achievement3 setGameAchievement:[achievements objectAtIndex:i]];
        }else if(i==3){
            achievement4.hidden = NO;
            [achievement4 setGameAchievement:[achievements objectAtIndex:i]];
        }
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
