//
//  PlayerStatTableViewCell2.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerStatTableViewCell2.h"

@implementation PlayerStatTableViewCell2


@synthesize statTitle;
@synthesize winValue;
@synthesize lostVale;
@synthesize betVale;
@synthesize netTitle;
@synthesize netValue;
@synthesize isLocked;
@synthesize lockIcon1;
@synthesize lockIcon2;
@synthesize lockIcon3;
@synthesize lockIcon4;

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
        
        
        self.winValue = [[UILabel alloc] initWithFrame:CGRectMake(10, 25-4, 130, 15)];
        winValue.backgroundColor = [UIColor clearColor];
        winValue.textColor = [UIColor darkGrayColor];
        winValue.textAlignment = UITextAlignmentLeft;
        winValue.adjustsFontSizeToFitWidth = YES;
        winValue.minimumFontSize = 10;
        winValue.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:winValue];
        
        self.lostVale = [[UILabel alloc] initWithFrame:CGRectMake(10, 40-4, 130, 15)];
        lostVale.backgroundColor = [UIColor clearColor];
        lostVale.textColor = [UIColor darkGrayColor];
        lostVale.textAlignment = UITextAlignmentLeft;
        lostVale.adjustsFontSizeToFitWidth = YES;
        lostVale.minimumFontSize = 10;
        lostVale.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lostVale];
        
        self.betVale = [[UILabel alloc] initWithFrame:CGRectMake(10, 55-4, 130, 15)];
        betVale.backgroundColor = [UIColor clearColor];
        betVale.textColor = [UIColor darkGrayColor];
        betVale.textAlignment = UITextAlignmentLeft;
        betVale.adjustsFontSizeToFitWidth = YES;
        betVale.minimumFontSize = 10;
        betVale.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:betVale];
        
        self.netTitle = [[UILabel alloc] initWithFrame:CGRectMake(180, 18+2, 120, 19)];
        netTitle.backgroundColor = [UIColor clearColor];
        netTitle.textColor = [UIColor lightGrayColor];
        netTitle.textAlignment = UITextAlignmentCenter;
        netTitle.adjustsFontSizeToFitWidth = YES;
        netTitle.minimumFontSize = 10;
        netTitle.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:netTitle];
        
        self.netValue = [[UILabel alloc] initWithFrame:CGRectMake(175, 38+2, 120, 27)];
        netValue.backgroundColor = [UIColor clearColor];
        netValue.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        netValue.textAlignment = UITextAlignmentCenter;
        netValue.adjustsFontSizeToFitWidth = YES;
        netValue.minimumFontSize = 10;
        netValue.font = [UIFont boldSystemFontOfSize:22];
        [self.contentView addSubview:netValue];
        
        
        self.lockIcon1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 21, 12, 12)];
        [lockIcon1 setImage:[UIImage imageNamed:@"lock_icon.png"]];
        [self.contentView addSubview:lockIcon1];
        
        self.lockIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 36, 12, 12)];
        [lockIcon2 setImage:[UIImage imageNamed:@"lock_icon.png"]];
        [self.contentView addSubview:lockIcon2];
        
        self.lockIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 51, 12, 12)];
        [lockIcon3 setImage:[UIImage imageNamed:@"lock_icon.png"]];
        [self.contentView addSubview:lockIcon3];
        
        self.lockIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(230, 40, 20, 20)];
        [lockIcon4 setImage:[UIImage imageNamed:@"lock_icon.png"]];
        [self.contentView addSubview:lockIcon4];
    }
    return self;
}


-(void)setData:(NSString *)statCode winAmount:(double)winAmount loseAmount:(double)loseAmount betAmount:(double)betAmount{
    NSString *titleKey = [NSString stringWithFormat:@"profile.%@.title",statCode];
    statTitle.text = NSLocalizedString(titleKey,nil); 
    lockIcon1.hidden = YES;
    lockIcon2.hidden = YES;
    lockIcon3.hidden = YES;
    lockIcon4.hidden = YES;
    netValue.hidden = NO;
    
    winValue.text = [NSString stringWithFormat:@"Won: $%.2f",winAmount];
    lostVale.text = [NSString stringWithFormat:@"Lost: $%.2f",loseAmount];
    betVale.text = [NSString stringWithFormat:@"Bet:  $%.2f",betAmount];
    netTitle.text = @"Net";
    double net = winAmount + loseAmount;
    if(net > 0){
        netValue.textColor = [UIColor colorWithRed:0 green:0.6 blue:0.2 alpha:1];
        netValue.text = [NSString stringWithFormat:@"+$%.2f",net];
    }else if(net < 0){
        net = net*-1.0;
        netValue.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
        netValue.text = [NSString stringWithFormat:@"-$%.2f",net];
    }else{
        netValue.textColor = [UIColor darkGrayColor];
        netValue.text = [NSString stringWithFormat:@"$%.2f",net];
    }
    
    if(isLocked){
        winValue.text = [NSString stringWithFormat:@"Won:"];
        lostVale.text = [NSString stringWithFormat:@"Lost:"];
        betVale.text = [NSString stringWithFormat:@"Bet:"];
        netValue.hidden = YES;
        lockIcon1.hidden = NO;
        lockIcon2.hidden = NO;
        lockIcon3.hidden = NO;
        lockIcon4.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
