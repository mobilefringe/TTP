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
@synthesize playerCardOne;
@synthesize playerCardTwo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(3, 3, 85, 85)];
        avatar.radius = 70;
        avatar.userInteractionEnabled = YES;
        [self addSubview:avatar];
        
        self.winnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 4, 150, 30)];
        winnerLabel.textAlignment = UITextAlignmentLeft;
        winnerLabel.font = [UIFont boldSystemFontOfSize:28];
        winnerLabel.text = @"Split Pot";
        winnerLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        winnerLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:winnerLabel];
        
        
        self.winnerName = [[UILabel alloc] initWithFrame:CGRectMake(95, 33, 180, 30)];
        winnerName.textAlignment = UITextAlignmentLeft;
        winnerName.font = [UIFont boldSystemFontOfSize:28];
        winnerName.backgroundColor = [UIColor clearColor];
        winnerName.adjustsFontSizeToFitWidth = YES;
        winnerName.minimumFontSize = 10;
        winnerName.textColor = [UIColor whiteColor];
        [self addSubview:winnerName];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 55, 150, 40)];
        amountLabel.textAlignment = UITextAlignmentLeft;
        amountLabel.font = [UIFont boldSystemFontOfSize:22];
        amountLabel.adjustsFontSizeToFitWidth = YES;
        amountLabel.minimumFontSize = 10;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.textColor = [UIColor whiteColor];
        [self addSubview:amountLabel];
        
        
        UIImage *greenChip = [UIImage imageNamed:@"green_chip.png"];
        UIImageView *chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(95, 65, 20, 20)];
        chipImageView.image = greenChip;
        [self addSubview:chipImageView];
        
        self.handTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 138, 107, 23)];
        handTypeLabel.textAlignment = UITextAlignmentCenter;
        handTypeLabel.font = [UIFont boldSystemFontOfSize:22];
        handTypeLabel.backgroundColor = [UIColor clearColor];
        handTypeLabel.adjustsFontSizeToFitWidth = YES;
        handTypeLabel.minimumFontSize = 10;
        handTypeLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self addSubview:handTypeLabel];
        
        self.handDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 161, 110, 15)];
        handDetailsLabel.textAlignment = UITextAlignmentCenter;
        handDetailsLabel.font = [UIFont boldSystemFontOfSize:13];
        handDetailsLabel.backgroundColor = [UIColor clearColor];
        handDetailsLabel.adjustsFontSizeToFitWidth = YES;
        handDetailsLabel.minimumFontSize = 8;
        handDetailsLabel.textColor = [UIColor whiteColor];
        [self addSubview:handDetailsLabel];
        
        int xOffset = 47;
        int yOffSet = 188;
        int xStart = 23;
        self.cardOne = [[UIImageView alloc] initWithFrame:CGRectMake(xStart, yOffSet, 43, 60)];
        [self addSubview:cardOne];
        
        self.cardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(xStart+xOffset, yOffSet, 43, 60)];
        [self addSubview:cardTwo];
        
        self.cardThree = [[UIImageView alloc] initWithFrame:CGRectMake(xStart+xOffset*2, yOffSet, 43, 60)];
        [self addSubview:cardThree];
        
        self.cardFour = [[UIImageView alloc] initWithFrame:CGRectMake(xStart+xOffset*3, yOffSet, 43, 60)];
        [self addSubview:cardFour];
        
        self.cardFive = [[UIImageView alloc] initWithFrame:CGRectMake(xStart+xOffset*4, yOffSet, 43, 60)];
        [self addSubview:cardFive];
        
        self.playerCardOne = [[UIImageView alloc] initWithFrame:CGRectMake(185, 124, 40, 55)];
        [self addSubview:playerCardOne];
        
        self.playerCardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(227, 124, 40, 55)];
        [self addSubview:playerCardTwo];
    }
    return self;
}


-(void)setWinnerData:(NSMutableDictionary *)winner hand:(NSMutableDictionary *)hand isSplit:(BOOL)isSplit delay:(double)delay{
    
    
    int xOffset = 47;
    int yOffSet = 188;
    int xStart = 23;
    self.cardOne.frame = CGRectMake(xStart, yOffSet, 43, 60);
    self.cardTwo.frame = CGRectMake(xStart+xOffset, yOffSet, 43, 60);
    self.cardThree.frame = CGRectMake(xStart+xOffset*2, yOffSet, 43, 60);
    self.cardFour.frame = CGRectMake(xStart+xOffset*3, yOffSet, 43, 60);
    self.cardFive.frame = CGRectMake(xStart+xOffset*4, yOffSet, 43, 60);


    
    
    [avatar loadAvatar:[winner valueForKey:@"userID"]];
    //NSLog(@"winner:%@",winner);
    //NSLog(@"hand:%@",hand);
    if([[winner valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
       winnerName.text = @"You Won!!";
    }else{
        winnerName.text = [NSString stringWithFormat:@"%@ won",[winner valueForKey:@"userName"]];
    }
    double winAmount = [[winner objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winner objectForKey:@"userID"] hand:hand];
    
    amountLabel.text = [NSString stringWithFormat:@"%.2f",winAmount];
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
    NSMutableArray *communityCards = [winner valueForKey:@"communityCards"];
    //NSLog(@"winner:%@",winner);
    //NSLog(@"hand:%@",hand);
    playerCardOne.alpha = 1;
    playerCardTwo.alpha = 1;
    BOOL isFold = [[winner objectForKey:@"type"] hasSuffix:@"USER_FOLD"];
    if(isFold && ![[winner valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        [self.playerCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.playerCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }else{
        
        [self.playerCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[winner valueForKey:@"cardOne"]]];
        [self.playerCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[winner valueForKey:@"cardTwo"]]];
        
        if(![self isCardInWinningHand:cards  card:[winner valueForKey:@"cardOne"]]){
            playerCardOne.alpha = 0.7;
        }
        if(![self isCardInWinningHand:cards  card:[winner valueForKey:@"cardTwo"]]){
            playerCardTwo.alpha = 0.7;
        }
    }
    
    int state = [[hand objectForKey:@"state"] intValue];
    if(state > 1 || isFold){
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:0]]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:1]]];
        [self.cardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:2]]];
        
    }else{
        [self.cardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.cardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(state > 2){
        if([cards count] > 3 || isFold){
            [self.cardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:3]]];
        }
    }else{
        [self.cardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        
        
    }
    
    if(state > 3){
        if([communityCards count] > 4 || isFold){
            [self.cardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:4]]];
        }
    }else{
        [self.cardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(isSplit){
        winnerLabel.hidden = NO;
    }else{
        winnerLabel.hidden = YES;
    }
    
    
    if(!isFold){
        int xOffset = 47;
        int yOffSet = 193;
        int xStart = 23;
        self.cardOne.frame = CGRectMake(xStart, yOffSet, 43, 60);
        self.cardTwo.frame = CGRectMake(xStart+xOffset, yOffSet, 43, 60);
        self.cardThree.frame = CGRectMake(xStart+xOffset*2, yOffSet, 43, 60);
        self.cardFour.frame = CGRectMake(xStart+xOffset*3, yOffSet, 43, 60);
        self.cardFive.frame = CGRectMake(xStart+xOffset*4, yOffSet, 43, 60);
    }else{
        playerCardOne.alpha = 1;
        playerCardTwo.alpha = 2;
        self.cardOne.alpha = 1;
        self.cardTwo.alpha = 1;
        self.cardThree.alpha = 1;
        self.cardFour.alpha = 1;
        self.cardFive.alpha = 1;
        return;
    }
    
    self.cardOne.alpha = 1;
    self.cardTwo.alpha = 1;
    self.cardThree.alpha = 1;
    self.cardFour.alpha = 1;
    self.cardFive.alpha = 1;

    if([self isCardInWinningHand:cards  card:[communityCards objectAtIndex:0]]){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.5+delay];
        self.cardOne.frame = CGRectMake(xStart, yOffSet-7, 43, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        self.cardOne.alpha = 0.7;
        [UIView commitAnimations];
    }
   
    if([self isCardInWinningHand:cards  card:[communityCards objectAtIndex:1]]){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.5+delay];
        self.cardTwo.frame = CGRectMake(xStart+xOffset, yOffSet-7, 43, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        self.cardTwo.alpha = 0.7;
        [UIView commitAnimations];
    }
    
    
    if([self isCardInWinningHand:cards  card:[communityCards objectAtIndex:2]]){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.5+delay];
        self.cardThree.frame = CGRectMake(xStart+xOffset*2, yOffSet-7, 43, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        self.cardThree.alpha = 0.7;
        [UIView commitAnimations];
    }
    
    
    if([self isCardInWinningHand:cards  card:[communityCards objectAtIndex:3]]){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.5+delay];
        self.cardFour.frame = CGRectMake(xStart+xOffset*3, yOffSet-7, 43, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        self.cardFour.alpha = 0.7;
        [UIView commitAnimations];
    }
    
    
    if([self isCardInWinningHand:cards  card:[communityCards objectAtIndex:4]]){
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0.5+delay];
        self.cardFive.frame = CGRectMake(xStart+xOffset*4, yOffSet-7, 43, 60);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:@"" context:NULL];
        [UIView setAnimationDuration:0.3];
        self.cardFive.alpha = 0.7;
        [UIView commitAnimations];
    }
    
}

-(BOOL)isCardInWinningHand:(NSMutableArray *)winningHand card:(NSString *)card{
    for (NSString *winningCard in winningHand) {
        if([winningCard isEqualToString:card]){
            return YES;
        }
    }
    return NO;
    
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
