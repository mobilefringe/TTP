//
//  PlayerBraceletsTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerBraceletsTableViewCell.h"
#import "AchievementIcon.h"
#import "DataManager.h"

@implementation PlayerBraceletsTableViewCell

@synthesize categoryLabel;
@synthesize primaryAchievement;
@synthesize secondaryAchievement1;
@synthesize secondaryAchievement2;
@synthesize secondaryAchievement3;
@synthesize topBraceletsLabel;
@synthesize moreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 85);
        [self.contentView addSubview:background];
        
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 18)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        categoryLabel.textAlignment = UITextAlignmentLeft;
        categoryLabel.adjustsFontSizeToFitWidth = YES;
        categoryLabel.minimumFontSize = 10;
        categoryLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:categoryLabel];
        
        self.topBraceletsLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 185, 12)];
        topBraceletsLabel.backgroundColor = [UIColor clearColor];
        topBraceletsLabel.textColor = [UIColor whiteColor];
        topBraceletsLabel.textAlignment = UITextAlignmentLeft;
        topBraceletsLabel.adjustsFontSizeToFitWidth = YES;
        topBraceletsLabel.minimumFontSize = 10;
        topBraceletsLabel.font = [UIFont systemFontOfSize:11];
        topBraceletsLabel.text = @"Recent Cards";
        [self.contentView addSubview:topBraceletsLabel];
        
        self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 60, 60, 21)];
        moreLabel.backgroundColor = [UIColor clearColor];
        moreLabel.textColor = [UIColor whiteColor];
        moreLabel.textAlignment = UITextAlignmentLeft;
        moreLabel.adjustsFontSizeToFitWidth = YES;
        moreLabel.minimumFontSize = 10;
        moreLabel.font = [UIFont boldSystemFontOfSize:20];
        moreLabel.text = @"...";
        [self.contentView addSubview:moreLabel];
        
        self.primaryAchievement = [[AchievementIcon alloc] initWithFrame:CGRectMake(0, 15, 140*.80, 100*.80)];
        primaryAchievement.countLabel.hidden = YES;
        primaryAchievement.codeLabel.hidden = YES;
        primaryAchievement.button.enabled = NO;
        [self.contentView addSubview:primaryAchievement];
        
        self.secondaryAchievement1 = [[AchievementIcon alloc] initWithFrame:CGRectMake(90+20, 33, 45, 45)];
        secondaryAchievement1.countLabel.hidden = YES;
        secondaryAchievement1.button.enabled = NO;
        secondaryAchievement1.codeLabel.hidden = YES;
        [self.contentView addSubview:secondaryAchievement1];
        
        self.secondaryAchievement2 = [[AchievementIcon alloc] initWithFrame:CGRectMake(145+20, 33, 45, 45)];
        secondaryAchievement2.countLabel.hidden = YES;
        secondaryAchievement2.button.enabled = NO;
        secondaryAchievement2.codeLabel.hidden = YES;
        [self.contentView addSubview:secondaryAchievement2];
        
        self.secondaryAchievement3 = [[AchievementIcon alloc] initWithFrame:CGRectMake(200+20, 33, 45, 45)];
        secondaryAchievement3.countLabel.hidden = YES;
        secondaryAchievement3.button.enabled = NO;
        secondaryAchievement3.codeLabel.hidden = YES;
        [self.contentView addSubview:secondaryAchievement3];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		background.image = [UIImage imageNamed:@"cell_body_general_selected.png"];
	}else{
		background.image = [UIImage imageNamed:@"cell_body_general.png"];
	}
}


-(void)setBraceletData:(NSMutableDictionary *)playerProfieDict category:(NSString *)category{
    categoryLabel.text = [NSString stringWithFormat:@"%@",   NSLocalizedString(category,nil)];
    
    NSMutableArray *gameAchievements = [[DataManager sharedInstance].gameAchievements valueForKey:category];
    [primaryAchievement loadAchievment:[gameAchievements objectAtIndex:0]];
    
    
    NSMutableArray *userAchievements = [[DataManager sharedInstance] getProfileAchievements:category];
    
    if(userAchievements && [userAchievements count] > 0){
        [secondaryAchievement1 loadAchievment:[userAchievements objectAtIndex:0]];
    }else{
        [secondaryAchievement1 loadAchievment:[gameAchievements objectAtIndex:1]];
    }
    
    if(userAchievements && [userAchievements count] > 1){
        [secondaryAchievement2 loadAchievment:[userAchievements objectAtIndex:1]];
    }else{
        [secondaryAchievement2 loadAchievment:[gameAchievements objectAtIndex:2]];
    }
    
    if(userAchievements && [userAchievements count] > 2){
        [secondaryAchievement3 loadAchievment:[userAchievements objectAtIndex:2]];
    }else{
        [secondaryAchievement3 loadAchievment:[gameAchievements objectAtIndex:3]];
    }
}



@end
