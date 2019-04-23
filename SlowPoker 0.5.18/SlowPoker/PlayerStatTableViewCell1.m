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
        self.statTitle = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 220, 18)];
        statTitle.backgroundColor = [UIColor clearColor];
        statTitle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        statTitle.textAlignment = UITextAlignmentLeft;
        statTitle.adjustsFontSizeToFitWidth = YES;
        statTitle.minimumFontSize = 10;
        statTitle.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statTitle];
        
        self.statCount = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 285, 18)];
        statCount.backgroundColor = [UIColor clearColor];
        statCount.textColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.8 alpha:1];
        statCount.textAlignment = UITextAlignmentRight;
        statCount.adjustsFontSizeToFitWidth = YES;
        statCount.minimumFontSize = 10;
        statCount.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statCount];
        
        self.barGraphBackground = [[UIImageView alloc] initWithFrame:CGRectMake(7, 22, 285, 30)];
        [barGraphBackground setImage:[UIImage imageNamed:@"bar_graph_background.png"]];
        barGraphBackground.alpha = 0.8;
        [self.contentView addSubview:barGraphBackground];
        
        self.barGraph = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [barGraph setImage:[UIImage imageNamed:@"bar_graph.png"]];
        [barGraphBackground addSubview:barGraph];
        
        self.statPercentage = [[UILabel alloc] initWithFrame:CGRectMake(7+5, 22, 100, 30)];
        statPercentage.backgroundColor = [UIColor clearColor];
        statPercentage.textColor = [UIColor whiteColor];
        statPercentage.textAlignment = UITextAlignmentLeft;
        statPercentage.adjustsFontSizeToFitWidth = YES;
        statPercentage.minimumFontSize = 10;
        statPercentage.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statPercentage];
        
        self.lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(278, 4, 15, 15)];
        [lockIcon setImage:[UIImage imageNamed:@"lock_icon.png"]];
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
    statPercentage.frame = CGRectMake(7+5, 22, 100, 30);
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
    
    if(isLocked){
        statCount.text = @"?";
        statPercentage.text = [NSString stringWithFormat:@"Unlock player stats to view"];
        statPercentage.textColor = [UIColor lightGrayColor];
        self.statPercentage.frame = CGRectMake(7+5, 22, 270, 30);
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
        statPercentage.frame = CGRectMake(7+285*percentage+5, 22, 100, 30);
        statPercentage.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage.frame = CGRectMake(7, 22, 285*percentage-5, 30);
        statPercentage.textAlignment = UITextAlignmentRight;
    }
    [UIView commitAnimations];
    
}

-(void)doneAnimating{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
