//
//  TurnSectionHeader.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TurnSectionHeader.h"
#import "DataManager.h"
#import "BetViewController.h"

@implementation TurnSectionHeader

@synthesize communityCardOne;
@synthesize communityCardTwo;
@synthesize communityCardThree;
@synthesize communityCardFour;
@synthesize communityCardFive;
@synthesize handNumberLabel;
@synthesize potLabel;
@synthesize betViewController;
@synthesize winnerLabel;
@synthesize winnerType;
@synthesize guiState;
@synthesize whiteBlock;
@synthesize handDetails;
@synthesize activityIndicatorView;

static BOOL showAllCards = NO;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.whiteBlock = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 320, 90)];
        whiteBlock.backgroundColor = [UIColor whiteColor];
       // [self addSubview:whiteBlock];
        
        UIView *blackBlock = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 320, 1)];
        blackBlock.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
       // [self addSubview:blackBlock];
        
        self.handDetails = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        handDetails.backgroundColor = [UIColor grayColor];
       // [self addSubview:handDetails];
    
        int xOffset = 40;
        self.communityCardOne = [[UIImageView alloc] initWithFrame:CGRectMake(90, 35, 35, 50)];
        [self addSubview:communityCardOne];
        
        self.communityCardTwo = [[UIImageView alloc] initWithFrame:CGRectMake(90+xOffset, 35, 35, 50)];
        [self addSubview:communityCardTwo];
        
        self.communityCardThree = [[UIImageView alloc] initWithFrame:CGRectMake(90+xOffset*2, 35, 35, 50)];
        [self addSubview:communityCardThree];
        
        self.communityCardFour = [[UIImageView alloc] initWithFrame:CGRectMake(90+xOffset*3, 35, 35, 50)];
        [self addSubview:communityCardFour];
        
        self.communityCardFive = [[UIImageView alloc] initWithFrame:CGRectMake(90+xOffset*4, 35, 35, 50)];
        [self addSubview:communityCardFive];
        
        //self.backgroundColor = [UIColor clearColor];
        
        
        self.handNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 150, 15)];
        handNumberLabel.font = [UIFont boldSystemFontOfSize:13];
        handNumberLabel.backgroundColor = [UIColor clearColor];
        handNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:handNumberLabel];
        
        self.potLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 4, 160, 15)];
        potLabel.textAlignment = UITextAlignmentRight;
        potLabel.font = [UIFont boldSystemFontOfSize:13];
        potLabel.backgroundColor = [UIColor clearColor];
        potLabel.textColor = [UIColor whiteColor];
        [self addSubview:potLabel];
        
        self.winnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 20)];
        winnerLabel.textAlignment = UITextAlignmentCenter;
        winnerLabel.font = [UIFont boldSystemFontOfSize:18];
        winnerLabel.backgroundColor = [UIColor clearColor];
        winnerLabel.textColor = [UIColor whiteColor];
        [self addSubview:winnerLabel];
        
        self.winnerType = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 12)];
        winnerType.textAlignment = UITextAlignmentCenter;
        winnerType.font = [UIFont boldSystemFontOfSize:10];
        winnerType.backgroundColor = [UIColor clearColor];
        winnerType.textColor = [UIColor whiteColor];
        [self addSubview:winnerType];
        
        self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(295, 2, 25, 25);
        activityIndicatorView.hidesWhenStopped = YES;
        [activityIndicatorView stopAnimating];
        [self addSubview:activityIndicatorView];

        
    }
    return self;
}


-(void)setHeaderData:(NSMutableDictionary *)data{
    NSMutableArray *communityCards = [data objectForKey:@"communityCards"];
    
        
    int state = [[data objectForKey:@"state"] intValue];
    
    if(showAllCards){
        state = 5;
    }
    if(state > 1){
        [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:0]]];
        [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:1]]];
        [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:2]]];
        
    }else{
        [self.communityCardOne setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.communityCardTwo setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self.communityCardThree setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    if(state > 2){
        [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:3]]];
    }else{
        [self.communityCardFour setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        
        
    }
    
    if(state > 3){
        [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:[communityCards objectAtIndex:4]]];
    }else{
        [self.communityCardFive setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
    }
    
    
    NSMutableArray *winners = [data valueForKey:@"winners"];
    handDetails.backgroundColor = [UIColor grayColor];
    //NSLog(@"Winners for Hand#%@ :%@",[data objectForKey:@"number"],winners);
    if(winners && [winners count] > 0){
        //handDetails.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:1];
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.1 blue:0.1 alpha:0.9];
        for (NSMutableDictionary *winnerPlayerData in winners) {
            double winAmount = [[winnerPlayerData objectForKey:@"amount"] doubleValue] - [[DataManager sharedInstance] getPotEntryForUser:[winnerPlayerData objectForKey:@"userID"] hand:data];
            if([[winnerPlayerData valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID] && winAmount > 0){
                winnerLabel.text = [NSString stringWithFormat:@"You won $%.2f!",winAmount];
                self.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:0.9];
                break;
            }else{
                winnerLabel.text = [NSString stringWithFormat:@"%@ won $%.2f",[winnerPlayerData objectForKey:@"userName"],winAmount];
            }
            winnerType.text = NSLocalizedString([winnerPlayerData objectForKey:@"type"], nil);
        }
        if([winners count] > 1){
            winnerLabel.text = [winnerLabel.text stringByAppendingString:@" *"];
        }
    }else{
        /*
        if([[DataManager sharedInstance] isCurrentGameMyTurn]){
            self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:1 alpha:0.9];
        }else{
            self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
        }*/
        self.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.9];
        
        winnerLabel.text = [NSString stringWithFormat:@"Pot $%@",[data objectForKey:@"potSize"]];
    }
    
    handNumberLabel.text = [NSString stringWithFormat:@"Hand #%@",[data objectForKey:@"number"]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1); 
    CGContextSetLineWidth(ctx,4);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint( ctx, 320,0);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 90-1);
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextSetLineWidth(ctx,1);
    CGContextAddLineToPoint( ctx, 320,90-1);
    
    CGContextStrokePath(ctx);
}


@end
