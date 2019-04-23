//
//  GameStatCell2.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatCell2.h"
#import "DataManager.h"

@implementation GameStatCell2

@synthesize statTitle;
@synthesize statCount;
@synthesize statPercentage;
@synthesize statSubtitle;
@synthesize barGraphBackground;
@synthesize barGraph;
@synthesize statPercentage2;
@synthesize statSubtitle2;
@synthesize barGraphBackground2;
@synthesize barGraph2;
@synthesize statCodeTmp;
@synthesize isLocked;
@synthesize lockIcon;
@synthesize userID;

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
        
        self.barGraphBackground = [[UIImageView alloc] initWithFrame:CGRectMake(7, 22, 285, 40)];
        [barGraphBackground setImage:[UIImage imageNamed:@"bar_graph_background.png"]];
        barGraphBackground.alpha = 0.8;
        [self.contentView addSubview:barGraphBackground];
        
        self.barGraph = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        [barGraph setImage:[UIImage imageNamed:@"bar_graph.png"]];
        [barGraphBackground addSubview:barGraph];
        
        /*
        self.barGraphBackground2 = [[UIImageView alloc] initWithFrame:CGRectMake(7, 42, 285, 20)];
        [barGraphBackground2 setImage:[UIImage imageNamed:@"bar_graph_background.png"]];
        barGraphBackground2.alpha = 0.8;
        [self.contentView addSubview:barGraphBackground2];*/
        
        self.barGraph2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 0, 20)];
        [barGraph2 setImage:[UIImage imageNamed:@"bar_graph2.png"]];
        [barGraphBackground addSubview:barGraph2];
        
        self.statPercentage = [[UILabel alloc] initWithFrame:CGRectMake(7+5, 22, 100, 30)];
        statPercentage.backgroundColor = [UIColor clearColor];
        statPercentage.textColor = [UIColor whiteColor];
        statPercentage.textAlignment = UITextAlignmentLeft;
        statPercentage.adjustsFontSizeToFitWidth = YES;
        statPercentage.minimumFontSize = 10;
        statPercentage.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statPercentage];
        
        
        self.statPercentage2 = [[UILabel alloc] initWithFrame:CGRectMake(7+5, 42, 100, 30)];
        statPercentage2.backgroundColor = [UIColor clearColor];
        statPercentage2.textColor = [UIColor whiteColor];
        statPercentage2.textAlignment = UITextAlignmentLeft;
        statPercentage2.adjustsFontSizeToFitWidth = YES;
        statPercentage2.minimumFontSize = 10;
        statPercentage2.font = [UIFont boldSystemFontOfSize:13];
        [self.contentView addSubview:statPercentage2];
        
        self.lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(278, 4, 15, 15)];
        [lockIcon setImage:[UIImage imageNamed:@"lock_icon.png"]];
        [self.contentView addSubview:lockIcon];
    }
    return self;
}



-(void)setPlayerStat:(NSMutableDictionary *)playerStats statCode:(NSString *)statCode subtext:(NSString*)subtext{
    self.userID = [playerStats valueForKey:@"userID"];
    statTitle.text =[playerStats valueForKey:@"userName"];
    double thisGamePercentage = [[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_THIS_GAME",statCode]] doubleValue];
    double allTimePercentage = [[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_ALL_TIME",statCode]] doubleValue];
    
    self.statCodeTmp = statCode;
    barGraph.frame = CGRectMake(0, 0, 0, 20);
    barGraph2.frame = CGRectMake(0, 20, 0, 20);
    statPercentage.frame = CGRectMake(7+5, 22, 100, 20);
    statPercentage2.frame = CGRectMake(7+5, 42, 100, 20);
    lockIcon.hidden = YES;
    statCount.hidden = NO;
    
    
    
    
    if(thisGamePercentage > 1){
        thisGamePercentage = 1;
    }
    if(allTimePercentage > 1){
        allTimePercentage = 1;
    }
    if(!statCode){
        statTitle.text = @"";
        statCount.text = @"";
        return;
    }
    /*
    NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",statCode];
    statTitle.text = NSLocalizedString(titleKey,nil); 
    statCount.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getCountForUserAchievement:statCode category:@"PROFILE"]];
    */
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
    
    //all time
    if(isnan(allTimePercentage)){
        statPercentage.text = [NSString stringWithFormat:@"No data available"];
        statPercentage.textColor = [UIColor lightGrayColor];
        allTimePercentage = 0;
    }else{
        statPercentage.text = [NSString stringWithFormat:@"%.0f%@ %@",allTimePercentage*100,@"%",subtext];
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
    barGraph.frame = CGRectMake(0, 0, 285*allTimePercentage, 20);
    if(allTimePercentage < .70){
        statPercentage.frame = CGRectMake(7+285*allTimePercentage+5, 22, 100, 20);
        statPercentage.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage.frame = CGRectMake(7, 22, 285*allTimePercentage-5, 20);
        statPercentage.textAlignment = UITextAlignmentRight;
    }
    [UIView commitAnimations];
    
    
    //this game
    if(isnan(thisGamePercentage)){
        statPercentage2.text = [NSString stringWithFormat:@"No data available"];
        statPercentage2.textColor = [UIColor lightGrayColor];
        thisGamePercentage = 0;
    }else{
        statPercentage2.text = [NSString stringWithFormat:@"%.0f%@ %@",thisGamePercentage*100,@"%",subtext];
        statPercentage2.textColor = [UIColor whiteColor];
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
    barGraph2.frame = CGRectMake(0, 20, 285*thisGamePercentage, 20);
    if(thisGamePercentage < .70){
        statPercentage2.frame = CGRectMake(7+285*thisGamePercentage+5, 42, 100, 20);
        statPercentage2.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage2.frame = CGRectMake(7, 42, 285*thisGamePercentage-5, 20);
        statPercentage2.textAlignment = UITextAlignmentRight;
    }
    [UIView commitAnimations];
    
}



-(void)setPlayerStatWithMaxValue:(NSMutableDictionary *)playerStats statCode:(NSString *)statCode subtext:(NSString*)subtext maxValue:(double)maxValue{
    self.userID = [playerStats valueForKey:@"userID"];
    statTitle.text =[playerStats valueForKey:@"userName"];
    double thisGamePercentage = [[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_THIS_GAME",statCode]] doubleValue];
    double allTimePercentage = [[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_ALL_TIME",statCode]] doubleValue];
    
    thisGamePercentage = thisGamePercentage/maxValue;
    allTimePercentage = allTimePercentage/maxValue;
    
    self.statCodeTmp = statCode;
    barGraph.frame = CGRectMake(0, 0, 0, 20);
    barGraph2.frame = CGRectMake(0, 20, 0, 20);
    statPercentage.frame = CGRectMake(7+5, 22, 100, 20);
    statPercentage2.frame = CGRectMake(7+5, 42, 100, 20);
    lockIcon.hidden = YES;
    statCount.hidden = NO;
    
    
    
    
    
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
    
    //all time
    if(isnan(allTimePercentage)){
        statPercentage.text = [NSString stringWithFormat:@"No data available"];
        statPercentage.textColor = [UIColor lightGrayColor];
        allTimePercentage = 0;
    }else{
        statPercentage.text = [NSString stringWithFormat:@"%.1f%@ %@",[[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_ALL_TIME",statCode]] doubleValue],@"",subtext];
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
    barGraph.frame = CGRectMake(0, 0, 285*allTimePercentage, 20);
    if(allTimePercentage < .70){
        statPercentage.frame = CGRectMake(7+285*allTimePercentage+5, 22, 100, 20);
        statPercentage.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage.frame = CGRectMake(7, 22, 285*allTimePercentage-5, 20);
        statPercentage.textAlignment = UITextAlignmentRight;
    }
    [UIView commitAnimations];
    
    
    //this game
    if(isnan(thisGamePercentage)){
        statPercentage2.text = [NSString stringWithFormat:@"No data available"];
        statPercentage2.textColor = [UIColor lightGrayColor];
        thisGamePercentage = 0;
    }else{
        statPercentage2.text = [NSString stringWithFormat:@"%.1f%@ %@",[[playerStats valueForKey:[NSString stringWithFormat:@"%@_PERCENTAGE_THIS_GAME",statCode]] doubleValue],@"",subtext];
        statPercentage2.textColor = [UIColor whiteColor];
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
    barGraph2.frame = CGRectMake(0, 20, 285*thisGamePercentage, 20);
    if(thisGamePercentage < .70){
        statPercentage2.frame = CGRectMake(7+285*thisGamePercentage+5, 42, 100, 20);
        statPercentage2.textAlignment = UITextAlignmentLeft;
    }else{
        statPercentage2.frame = CGRectMake(7, 42, 285*thisGamePercentage-5, 20);
        statPercentage2.textAlignment = UITextAlignmentRight;
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
