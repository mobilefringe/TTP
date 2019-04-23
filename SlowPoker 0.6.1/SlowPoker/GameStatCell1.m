//
//  GameStatCell1.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatCell1.h"

@implementation GameStatCell1

@synthesize rankLabel;
@synthesize userNameLabel;
@synthesize chipStackLabel;
@synthesize netLabel;
@synthesize userID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, 20, 20)];
        rankLabel.textColor = [UIColor blackColor];
        rankLabel.textAlignment = UITextAlignmentLeft;
        rankLabel.font = [UIFont boldSystemFontOfSize:14];
        rankLabel.adjustsFontSizeToFitWidth = YES;
        rankLabel.minimumFontSize = 9;
        rankLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rankLabel];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 2, 135, 20)];
        userNameLabel.textColor = [UIColor blackColor];
        userNameLabel.textAlignment = UITextAlignmentLeft;
        userNameLabel.font = [UIFont boldSystemFontOfSize:14];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 9;
        userNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:userNameLabel];
        
        self.chipStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(27+125, 2, 60, 20)];
        chipStackLabel.textColor = [UIColor lightGrayColor];
        chipStackLabel.textAlignment = UITextAlignmentRight;
        chipStackLabel.font = [UIFont boldSystemFontOfSize:16];
        chipStackLabel.adjustsFontSizeToFitWidth = YES;
        chipStackLabel.minimumFontSize = 9;
        chipStackLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:chipStackLabel];
        
        self.netLabel = [[UILabel alloc] initWithFrame:CGRectMake(27+150+50, 2, 60, 20)];
        netLabel.textColor = [UIColor darkGrayColor];
        netLabel.textAlignment = UITextAlignmentRight;
        netLabel.font = [UIFont boldSystemFontOfSize:16];
        netLabel.adjustsFontSizeToFitWidth = YES;
        netLabel.minimumFontSize = 9;
        netLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:netLabel];

    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)data rank:(int)rank isTournament:(BOOL)isTournament{
    self.userID = [data valueForKey:@"userID"];
    rankLabel.text = [NSString stringWithFormat:@"%d",rank];
    userNameLabel.textColor = [UIColor blackColor];
    rankLabel.textColor = [UIColor blackColor];
    netLabel.alpha = 1;
    //NSLog(@"player data:%@",data);
    
    
    userNameLabel.text = [data valueForKey:@"userName"];
    if(isTournament){
        if([[data valueForKey:@"HANDS_PLAYED_THIS_GAME"] intValue] > 0){
            chipStackLabel.text = [NSString stringWithFormat:@"Hand %d",[[data valueForKey:@"HANDS_PLAYED_THIS_GAME"] intValue]];
        }else{
            chipStackLabel.text = @"";
        }
       
    }else{
        chipStackLabel.text = [NSString stringWithFormat:@"$ %.2f",[[data valueForKey:@"userStack"] doubleValue]];
    }
    if([[data valueForKey:@"net"] doubleValue] > 0){
        netLabel.textColor = [UIColor colorWithRed:0 green:0.6 blue:0.2 alpha:1];
    }else if([[data valueForKey:@"net"] doubleValue] < 0 || [[data valueForKey:@"status"] isEqualToString:@"out"]){
        netLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
    }
    netLabel.text = [NSString stringWithFormat:@"$ %.2f",[[data valueForKey:@"net"] doubleValue]];
    if([[data valueForKey:@"status"] isEqualToString:@"out"] || !isTournament){
        if([[data valueForKey:@"status"] isEqualToString:@"out"]){
            netLabel.text = @"Out";
            netLabel.alpha = 0.9;
            userNameLabel.textColor = [UIColor lightGrayColor];
            rankLabel.textColor = [UIColor lightGrayColor];
        }
        chipStackLabel.hidden = NO;
    }else{
        chipStackLabel.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
