//
//  HandSummaryView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandSummaryView.h"
#import "Avatar.h"
#import "DataManager.h"

@implementation HandSummaryView

@synthesize avatar;
@synthesize winnerLabel;
@synthesize winnerName;
@synthesize amountLabel;
@synthesize handTypeLabel;
@synthesize handDetailsLabel;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize cardThree;
@synthesize cardFour;
@synthesize cardFive;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        avatar.userInteractionEnabled = YES;
        [self addSubview:avatar];
        
        self.winnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 5, 150, 20)];
        winnerLabel.textAlignment = UITextAlignmentCenter;
        winnerLabel.font = [UIFont systemFontOfSize:18];
        winnerLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        winnerLabel.textColor = [UIColor whiteColor];
        [self addSubview:winnerLabel];
        
        self.winnerName = [[UILabel alloc] initWithFrame:CGRectMake(95, 25, 150, 30)];
        winnerName.textAlignment = UITextAlignmentCenter;
        winnerName.font = [UIFont boldSystemFontOfSize:28];
        winnerName.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        winnerName.adjustsFontSizeToFitWidth = YES;
        winnerName.minimumFontSize = 10;
        winnerName.textColor = [UIColor whiteColor];
        [self addSubview:winnerName];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 55, 150, 40)];
        amountLabel.textAlignment = UITextAlignmentCenter;
        amountLabel.font = [UIFont boldSystemFontOfSize:22];
        amountLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        amountLabel.textColor = [UIColor whiteColor];
        [self addSubview:amountLabel];
        
        self.handTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 100, 210, 23)];
        handTypeLabel.textAlignment = UITextAlignmentCenter;
        handTypeLabel.font = [UIFont boldSystemFontOfSize:22];
        handTypeLabel.backgroundColor = [UIColor clearColor];
        handTypeLabel.textColor = [UIColor whiteColor];
        [self addSubview:handTypeLabel];
        
        self.handDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 123, 210, 16)];
        handDetailsLabel.textAlignment = UITextAlignmentCenter;
        handDetailsLabel.font = [UIFont boldSystemFontOfSize:15];
        handDetailsLabel.backgroundColor = [UIColor clearColor];
        handDetailsLabel.textColor = [UIColor whiteColor];
        [self addSubview:handDetailsLabel];
        
        int xOffset = 47;
        int yOffSet = 140;
        self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(9, yOffSet, 43, 60)];
        [self addSubview:cardOne];
        
        self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(9+xOffset, yOffSet, 43, 60)];
        [self addSubview:cardTwo];
        
        self.cardThree = [[UIImageView alloc] initWithFrame:CGRectMake(9+xOffset*2, yOffSet, 43, 60)];
        [self addSubview:cardThree];
        
        self.cardFour = [[UIImageView alloc] initWithFrame:CGRectMake(9+xOffset*3, yOffSet, 43, 60)];
        [self addSubview:cardFour];
        
        self.cardFive = [[UIImageView alloc] initWithFrame:CGRectMake(9+xOffset*4, yOffSet, 43, 60)];
        [self addSubview:cardFive];
    }
    return self;
}


-(void)setWinnerData:(NSMutableDictionary *)winner hand:(NSMutableDictionary *)hand{
    [avatar loadAvatar:[winner valueForKey:@"userID"]];
    winnerLabel.text = @"Winner";
    if([[winner valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
       winnerName.text = @"You!!";
    }else{
        winnerName.text = [NSString stringWithFormat:@"%@",[winner valueForKey:@"userName"]];
    }
    double winAmount = [[winner objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winner objectForKey:@"userID"] hand:hand];
    
    amountLabel.text = [NSString stringWithFormat:@"$%.2f",winAmount];
    handTypeLabel.text = NSLocalizedString([winner objectForKey:@"type"], nil);
    
    NSString *detailsKey = [NSString stringWithFormat:@"handDetails.%@",[winner objectForKey:@"type"]];
    NSMutableArray *rankings = [[winner valueForKey:@"handDetails"] valueForKey:@"rankings"];
    
    
    NSString *ranking1 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:0]];
    NSString *ranking2 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:1]];
    NSString *ranking3 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:2]];
    NSString *ranking4 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:3]];
    NSString *ranking5 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:4]];
    if([[winner objectForKey:@"type"] hasSuffix:@"FLUSH"]){
        NSString *suitKey = [NSString stringWithFormat:@"suit.%@",[[winner valueForKey:@"handDetails"] valueForKey:@"flushSuit"]];
        handDetailsLabel.text = [NSString stringWithFormat:NSLocalizedString(detailsKey, nil),NSLocalizedString(suitKey, nil), NSLocalizedString(ranking1,nil)];
    }else{
        handDetailsLabel.text = [NSString stringWithFormat:NSLocalizedString(detailsKey, nil), NSLocalizedString(ranking1,nil), NSLocalizedString(ranking2,nil), NSLocalizedString(ranking3,nil), NSLocalizedString(ranking4,nil), NSLocalizedString(ranking5,nil)];
    }

    
    NSMutableArray *cards = [winner valueForKey:@"hand"];
    int state = [[hand objectForKey:@"state"] intValue];
    if(state > 1){
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[cards objectAtIndex:0]]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[cards objectAtIndex:1]]];
        [self.cardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:[cards objectAtIndex:2]]];
        
    }else{
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(state > 2){
        [self.cardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:[cards objectAtIndex:3]]];
    }else{
        [self.cardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        
        
    }
    
    if(state > 3){
        [self.cardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:[cards objectAtIndex:4]]];
    }else{
        [self.cardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
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
