//
//  PlayerStatTableViewCell1.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerStatTableViewCell1.h"
#import "DataManager.h"

@implementation PlayerStatTableViewCell1

@synthesize statTitle;
@synthesize statCount;
@synthesize statPercentage;
@synthesize statSubtitle;
@synthesize barGraphBackground;
@synthesize barGraph;
@synthesize statCodeTmp;
@synthesize isLocked;
@synthesize lockIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 70);
        [self.contentView addSubview:background];
        
        
        self.statTitle = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 220, 18)];
        statTitle.backgroundColor = [UIColor clearColor];
        statTitle.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        statTitle.textAlignment = UITextAlignmentLeft;
        statTitle.adjustsFontSizeToFitWidth = YES;
        statTitle.minimumFontSize = 10;
        statTitle.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:statTitle];
        
        self.statSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(7, 20, 220, 13)];
        statSubtitle.backgroundColor = [UIColor clearColor];
        statSubtitle.textColor = [UIColor lightGrayColor];
        statSubtitle.textAlignment = UITextAlignmentLeft;
        statSubtitle.adjustsFontSizeToFitWidth = YES;
        statSubtitle.minimumFontSize = 10;
        statSubtitle.font = [UIFont boldSystemFontOfSize:11];
        [self.contentView addSubview:statSubtitle];
        
        self.statCount = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 285, 18)];
        statCount.backgroundColor = [UIColor clearColor];
        statCount.textColor = [UIColor whiteColor];
        statCount.textAlignment = UITextAlignmentRight;
        statCount.adjustsFontSizeToFitWidth = YES;
        statCount.minimumFontSize = 10;
        statCount.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statCount];
        
        int yOffset = 12;
        self.barGraphBackground = [[UIImageView alloc] initWithFrame:CGRectMake(7, 22+yOffset, 285, 30)];
        [barGraphBackground setImage:[UIImage imageNamed:@"bar_graph_background.png"]];
        barGraphBackground.alpha = 0.8;
        [self.contentView addSubview:barGraphBackground];
        
        self.barGraph = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [barGraph setImage:[UIImage imageNamed:@"bar_graph.png"]];
        [barGraphBackground addSubview:barGraph];
        
        self.statPercentage = [[UILabel alloc] initWithFrame:CGRectMake(7+5, 22+yOffset, 100, 30)];
        statPercentage.backgroundColor = [UIColor clearColor];
        statPercentage.textColor = [UIColor whiteColor];
        statPercentage.textAlignment = UITextAlignmentLeft;
        statPercentage.adjustsFontSizeToFitWidth = YES;
        statPercentage.minimumFontSize = 10;
        statPercentage.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statPercentage];
        
        self.lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(268, 4, 22, 25)];
        [lockIcon setImage:[UIImage imageNamed:@"lock.png"]];
        [self.contentView addSubview:lockIcon];
    }
    return self;
}

-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage{
    
    [self setPlayerStat:statCode percentage:percentage subtext:@""];
}


-(void)setPlayerStat:(NSString *)statCode percentage:(double)percentage subtext:(NSString*)subtext{
    self.statCodeTmp = statCode;
    barGraph.frame = CGRectMake(0, 0, 0, 30);
    statPercentage.frame = CGRectMake(7+5, 22+12, 100, 30);
    lockIcon.hidden = YES;
    statCount.hidden = NO;
    
    
    
    
    if(percentage >1){
        percentage = 1;
    }
    if(!statCode){
        statTitle.text = @"";
        statCount.text = @"";
        return;
    }
    NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",statCode];
    statTitle.text = NSLocalizedString(titleKey,nil); 
    statCount.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getCountForUserAchievement:statCode category:@"PROFILE"]];
    titleKey = [NSString stringWithFormat:@"profile.%@.subTitle",statCode];
    statSubtitle.text = NSLocalizedString(titleKey,nil); 
    if(isLocked){
        statCount.text = @"?";
        statPercentage.text = [NSString stringWithFormat:@"Unlock player stats to view"];
        statPercentage.textColor = [UIColor lightGrayColor];
        self.statPercentage.frame = CGRectMake(7+5, 22+12, 270, 30);
        statPercentage.textAlignment = UITextAlignmentCenter;
        lockIcon.hidden = NO;
        statCount.hidden = YES;
        return;
    }
    
    if(isnan(percentage)){
        statPercentage.text = [NSString stringWithFormat:@"No data available"];
        statPercentage.textColor = [UIColor lightGrayColor];
        percentage = 0;
    }else{
        statPercentage.text = [NSString stringWithFormat:@"%.0f%@ %@",percentage*100,@"%",subtext];
        statPercentage.textColor = [UIColor whiteColor];
    }
    
    if(!subtext || [subtext length]==0){
        statCount.hidden = YES;
    }else{
        statCount.hidden = NO;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(doneAnimating)];
    barGraph.frame = CGRectMake(0, 0, 285*percentage, 30);
    if(percentage < .70){
        statPercentage.frame = CGRectMake(7+285*percentage+5, 22+12, 100, 30);
        statPercentage.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage.frame = CGRectMake(7, 22+12, 285*percentage-5, 30);
        statPercentage.textAlignment = UITextAlignmentRight;
    }
    [UIView commitAnimations];
    
}

-(void)setPlayerStatValue:(NSString *)statCode value:(double)value subtext:(NSString*)subtext{
    self.statCodeTmp = statCode;
    barGraph.frame = CGRectMake(0, 0, 0, 30);
    statPercentage.frame = CGRectMake(7+5, 22+12, 100, 30);
    lockIcon.hidden = YES;
    statCount.hidden = NO;
    
    
    
    
    
    if(!statCode){
        statTitle.text = @"";
        statCount.text = @"";
        return;
    }
    NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",statCode];
    statTitle.text = NSLocalizedString(titleKey,nil); 
    statCount.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getCountForUserAchievement:statCode category:@"PROFILE"]];
    titleKey = [NSString stringWithFormat:@"profile.%@.subTitle",statCode];
    statSubtitle.text = NSLocalizedString(titleKey,nil);
    if(isLocked){
        statCount.text = @"?";
        statPercentage.text = [NSString stringWithFormat:@"Unlock player stats to view"];
        statPercentage.textColor = [UIColor lightGrayColor];
        self.statPercentage.frame = CGRectMake(7+5, 22+12, 270, 30);
        statPercentage.textAlignment = UITextAlignmentCenter;
        lockIcon.hidden = NO;
        statCount.hidden = YES;
        return;
    }
    
    if(isnan(value)){
        statPercentage.text = [NSString stringWithFormat:@"No data available"];
        statPercentage.textColor = [UIColor lightGrayColor];
        value = 0;
    }else{
        statPercentage.text = [NSString stringWithFormat:@"%.1f%@ %@",value,@"",subtext];
        statPercentage.textColor = [UIColor whiteColor];
    }
    
    if(!subtext || [subtext length]==0){
        statCount.hidden = YES;
    }else{
        statCount.hidden = NO;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(doneAnimating)];
    barGraph.frame = CGRectMake(0, 0, 285*1, 30);
    statPercentage.frame = CGRectMake(7, 22+12, 285*1-5, 30);
    statPercentage.textAlignment = UITextAlignmentRight;
    
    [UIView commitAnimations];
    
}

-(void)doneAnimating{
    
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
