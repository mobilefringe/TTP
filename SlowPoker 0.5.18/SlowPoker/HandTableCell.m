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
        
        
        
        self.handType = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 160, 30)];
        handType.adjustsFontSizeToFitWidth = YES;
        handType.minimumFontSize = 10;
        handType.font = [UIFont boldSystemFontOfSize:18];
        handType.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        [self.contentView addSubview:handType];
        handType.backgroundColor = [UIColor clearColor];
        
        self.handValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 170, 30)];
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
    }else{
        handValue.text = @"";
        handType.text = @"";
    }
}

@end
