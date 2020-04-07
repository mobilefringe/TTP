//
//  InvitePlayerCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InvitePlayerCell.h"
#import "Avatar.h"
#import "DataManager.h"

@implementation InvitePlayerCell

@synthesize userName;
@synthesize avatar;
@synthesize checkMark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, [UIScreen mainScreen].bounds.size.width, 50);
        [self.contentView addSubview:background];
        
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(57, 15, 210, 25)];
        userName.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        userName.font = [UIFont boldSystemFontOfSize:22];
        userName.tag = 10;
        userName.adjustsFontSizeToFitWidth = YES;
        userName.minimumFontSize = 10;
        userName.backgroundColor = [UIColor clearColor];
        userName.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:userName];
        
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(10, 5, 40, 40 )];
        avatar.radius = 70;
        
        [self.contentView addSubview:avatar];
        
        self.checkMark = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 12.5, 25, 25)];
        checkMark.image = [UIImage imageNamed:@"yellow_checkmark.png"];
        [self.contentView addSubview:checkMark];
        checkMark.hidden = YES;
    }
    return self;
}

-(void)loadPlayerData:(NSMutableDictionary *)player showCheckMark:(BOOL)showCheckMark{
    if([[player objectForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        userName.text = @"You";
    }else{
        userName.text = [player objectForKey:@"userName"];
    }
    [avatar loadAvatar:[player valueForKey:@"userID"]];
    checkMark.hidden = !showCheckMark;
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
