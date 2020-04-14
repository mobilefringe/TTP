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
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float achieventWidth = 65;
    float achieventSpace = 20;
    int xOffset = screenWidth-(achieventWidth*4+achieventSpace*3);
    float marginHorizontal = xOffset/2;
    int yOffset = 5;
    if (self) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(0, 0, screenWidth, 97);
        [self.contentView addSubview:background];
        
        self.achievement1 = [[AchievementIcon alloc] initWithFrame:CGRectMake(marginHorizontal, 10+yOffset, achieventWidth, 65)];
        [self.contentView addSubview:achievement1];
        
        self.achievement2 = [[AchievementIcon alloc] initWithFrame:CGRectMake(achieventSpace+marginHorizontal+achieventWidth, 10+yOffset, achieventWidth, 65)];
        [self.contentView addSubview:achievement2];
        
        self.achievement3 = [[AchievementIcon alloc] initWithFrame:CGRectMake(2*achieventSpace+marginHorizontal+2*achieventWidth, 10+yOffset, achieventWidth, 65)];
        [self.contentView addSubview:achievement3];
        
        self.achievement4 = [[AchievementIcon alloc] initWithFrame:CGRectMake(3*achieventSpace+marginHorizontal+3*achieventWidth, 10+yOffset, achieventWidth, 65)];
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		background.image = [UIImage imageNamed:@"cell_body_general_selected.png"];
	}else{
		background.image = [UIImage imageNamed:@"cell_body_general.png"];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
