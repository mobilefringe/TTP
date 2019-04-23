//
//  GameStatCell1.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatCell1.h"
#import "DataManager.h"

@implementation GameStatCell1

@synthesize rankLabel;
@synthesize userNameLabel;
@synthesize chipStackLabel;
@synthesize netLabel;
@synthesize userID;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 25);
        [self.contentView addSubview:background];

        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 2, 20, 20)];
        rankLabel.textColor = [UIColor blackColor];
        rankLabel.textAlignment = UITextAlignmentLeft;
        rankLabel.font = [UIFont boldSystemFontOfSize:14];
        rankLabel.adjustsFontSizeToFitWidth = YES;
        rankLabel.minimumFontSize = 9;
        rankLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:rankLabel];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, 2, 135, 20)];
        userNameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        userNameLabel.textAlignment = UITextAlignmentLeft;
        userNameLabel.font = [UIFont boldSystemFontOfSize:14];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 9;
        userNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:userNameLabel];
        
        
        
        self.netLabel = [[UILabel alloc] initWithFrame:CGRectMake(27+115, 4, 60, 20)];
        netLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        netLabel.textAlignment = UITextAlignmentRight;
        netLabel.font = [UIFont boldSystemFontOfSize:13];
        netLabel.adjustsFontSizeToFitWidth = YES;
        netLabel.minimumFontSize = 9;
        netLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:netLabel];
        
        self.chipStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(27+150+40, 4, 60, 20)];
        chipStackLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        chipStackLabel.textAlignment = UITextAlignmentRight;
        chipStackLabel.font = [UIFont boldSystemFontOfSize:16];
        chipStackLabel.adjustsFontSizeToFitWidth = YES;
        chipStackLabel.minimumFontSize = 9;
        chipStackLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:chipStackLabel];
        
        self.greenChip = [UIImage imageNamed:@"green_chip.png"];
        self.yellowChip = [UIImage imageNamed:@"yellow_chip.png"];
        self.redChip = [UIImage imageNamed:@"red_chip.png"];
        self.chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 5, 18, 18)];
        chipImageView.image = yellowChip;
        [self addSubview:chipImageView];

    }
    return self;
}

-(void)setCellData:(NSMutableDictionary *)data rank:(int)rank isTournament:(BOOL)isTournament{
    self.userID = [data valueForKey:@"userID"];
    rankLabel.text = [NSString stringWithFormat:@"%d",rank];
    userNameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    rankLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
    netLabel.text = @"";
    chipImageView.hidden = NO;
    
    
    userNameLabel.text = [data valueForKey:@"userName"];
    chipStackLabel.text = [NSString stringWithFormat:@"%.2f",[[data valueForKey:@"userStack"] doubleValue]];
    
    int chipState = [[DataManager sharedInstance] getChipStackState:userID];
    if(chipState == 1){
        chipImageView.image = greenChip;
    }else if(chipState == 2){
        chipImageView.image = yellowChip;
    }else if(chipState == 3){
        chipImageView.image = redChip;
    }
    
    if(isTournament){
        if([[data valueForKey:@"HANDS_PLAYED_THIS_GAME"] intValue] > 0 && [[data valueForKey:@"status"] isEqualToString:@"out"]){
            netLabel.text = [NSString stringWithFormat:@"Hand %d",[[data valueForKey:@"HANDS_PLAYED_THIS_GAME"] intValue]];
        }
    }else{
        if([[data valueForKey:@"net"] doubleValue] > 0){
            //netLabel.textColor = [UIColor colorWithRed:.65 green:1 blue:.65 alpha:1];
        }else if([[data valueForKey:@"net"] doubleValue] < 0 || [[data valueForKey:@"status"] isEqualToString:@"out"]){
            // netLabel.textColor = [UIColor colorWithRed:1 green:0.65 blue:.65 alpha:1];
        }
        netLabel.text = [NSString stringWithFormat:@"$%.2f",[[data valueForKey:@"net"] doubleValue]];
    }
    
    if([[data valueForKey:@"status"] isEqualToString:@"out"] || !isTournament){
        if([[data valueForKey:@"status"] isEqualToString:@"out"]){
            chipStackLabel.text = @"Out";
            chipImageView.hidden = YES;
            userNameLabel.textColor = [UIColor lightGrayColor];
            rankLabel.textColor = [UIColor lightGrayColor];
        }
        
    }else{
        
    }
    
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
