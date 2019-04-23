//
//  HandTableCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandTableCell.h"
#import "DataManager.h"
#import "Hand.h"

@implementation HandTableCell

@synthesize card1;
@synthesize card2;
@synthesize card3;
@synthesize card4;
@synthesize card5;
@synthesize handValue;
@synthesize handDetails;
@synthesize handType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.card1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 41, 58)];
        [self.contentView addSubview:card1];
        
        self.card2 = [[UIImageView alloc] initWithFrame:CGRectMake(10+55, 13, 41, 58)];
        [self.contentView addSubview:card2];
        
        self.card3 = [[UIImageView alloc] initWithFrame:CGRectMake(10+55*2, 13, 41, 58)];
        [self.contentView addSubview:card3];
        
        self.card4 = [[UIImageView alloc] initWithFrame:CGRectMake(10+55*3, 13, 41, 58)];
        [self.contentView addSubview:card4];
        
        self.card5 = [[UIImageView alloc] initWithFrame:CGRectMake(10+55*4, 13,41, 58)];
        [self.contentView addSubview:card5];
        
        
        
        self.handType = [[UILabel alloc] initWithFrame:CGRectMake(120, 10, 160, 20)];
        handType.adjustsFontSizeToFitWidth = YES;
        handType.minimumFontSize = 10;
        handType.font = [UIFont boldSystemFontOfSize:18];
        handType.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        [self.contentView addSubview:handType];
        handType.backgroundColor = [UIColor clearColor];
        
        self.handDetails = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 170, 20)];
        handDetails.backgroundColor = [UIColor clearColor];
        handDetails.adjustsFontSizeToFitWidth = YES;
        handDetails.font = [UIFont systemFontOfSize:15];
        handDetails.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        handDetails.minimumFontSize = 10;
        [self.contentView addSubview:handDetails];
        
        self.handValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 170, 20)];
        handValue.backgroundColor = [UIColor clearColor];
        handValue.adjustsFontSizeToFitWidth = YES;
        handValue.font = [UIFont systemFontOfSize:15];
        handValue.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        handValue.minimumFontSize = 10;
        [self.contentView addSubview:handValue];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCards:(NSMutableArray *)cards hand:(Hand *)hand{
    [self.card1 setImage:nil];
    [self.card2 setImage:nil];
    [self.card3 setImage:nil];
    [self.card4 setImage:nil];
    [self.card5 setImage:nil];
    for(int i = 0; i < cards.count;i++){
        if(i==0){
            [self.card1 setImage:[[DataManager sharedInstance].cardImages valueForKey:[cards objectAtIndex:i] ]];
        }else if(i==1){
            [self.card2 setImage:[[DataManager sharedInstance].cardImages valueForKey:[cards objectAtIndex:i] ]];
        }else if(i==2){
            [self.card3 setImage:[[DataManager sharedInstance].cardImages valueForKey:[cards objectAtIndex:i] ]];
        }else if(i==3){
            [self.card4 setImage:[[DataManager sharedInstance].cardImages valueForKey:[cards objectAtIndex:i] ]];
        }else if(i==4){
            [self.card5 setImage:[[DataManager sharedInstance].cardImages valueForKey:[cards objectAtIndex:i] ]];
        }
    }
    
    if(hand){
        handValue.text = [NSString stringWithFormat:@"Value: %d",hand.value];
        handType.text = NSLocalizedString(hand.type,nil);
        NSString *detailsKey = [NSString stringWithFormat:@"handDetails.%@",hand.type];
        NSMutableArray *rankings = [[hand getHandDetails] valueForKey:@"rankings"];
        
        
        NSString *ranking1 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:0]];
        NSString *ranking2 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:1]];
        NSString *ranking3 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:2]];
        NSString *ranking4 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:3]];
        NSString *ranking5 = [NSString stringWithFormat:@"rank.%@",[rankings objectAtIndex:4]];
        if([hand.type hasSuffix:@"FLUSH"]){
            NSString *suitKey = [NSString stringWithFormat:@"suit.%@",[[hand getHandDetails] valueForKey:@"flushSuit"]];
            handDetails.text = [NSString stringWithFormat:NSLocalizedString(detailsKey, nil),NSLocalizedString(suitKey, nil), NSLocalizedString(ranking1,nil)];
        }else{
            handDetails.text = [NSString stringWithFormat:NSLocalizedString(detailsKey, nil), NSLocalizedString(ranking1,nil), NSLocalizedString(ranking2,nil), NSLocalizedString(ranking3,nil), NSLocalizedString(ranking4,nil), NSLocalizedString(ranking5,nil)];
        }
    }else{
        handValue.text = @"";
        handType.text = @"";
        handDetails.text = @"";
    }
    
   
    
    
}

@end
