//
//  InviteFacebookFriendCell
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteFacebookFriendCell.h"
#import "Avatar.h"
#import "DataManager.h"
#import "SocialManager.h"

@implementation InviteFacebookFriendCell

@synthesize userName;
@synthesize avatar;
@synthesize checkMark;
@synthesize betButton;
@synthesize betButtonLabel;
@synthesize friendDict;
@synthesize inviteFriendAlert;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 50);
        [self.contentView addSubview:background];
        
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 25)];
        userName.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        userName.font = [UIFont boldSystemFontOfSize:22];
        userName.tag = 10;
        userName.adjustsFontSizeToFitWidth = YES;
        userName.minimumFontSize = 10;
        userName.backgroundColor = [UIColor clearColor];
        userName.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:userName];
        
        self.betButton = [UIButton buttonWithType:UIButtonTypeCustom];
        betButton.frame = CGRectMake(230, 12, 70, 30);
        [betButton addTarget:self action:@selector(showInviteFriendAlert) forControlEvents:UIControlEventTouchUpInside];
        [betButton setImage:[UIImage imageNamed:@"blue_wide.png"] forState:UIControlStateNormal];
        [self addSubview:betButton];
        
        self.betButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 60, 28)];
        betButtonLabel.font = [UIFont boldSystemFontOfSize:16];
        betButtonLabel.textAlignment = UITextAlignmentCenter;
        betButtonLabel.textColor = [UIColor whiteColor];
        betButtonLabel.adjustsFontSizeToFitWidth = YES;
        betButtonLabel.minimumFontSize = 8;
        betButtonLabel.text = @"Invite";
        betButtonLabel.backgroundColor = [UIColor clearColor];
        [betButton addSubview:betButtonLabel];

        
    }
    return self;
}

-(void)loadPlayerData:(NSMutableDictionary *)player showInvite:(BOOL)showInvite{
    userName.text = [player objectForKey:@"name"];
    self.friendDict = player;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
	[super setHighlighted:highlighted animated:animated];
	if(highlighted){
		background.image = [UIImage imageNamed:@"cell_body_general_selected.png"];
	}else{
		background.image = [UIImage imageNamed:@"cell_body_general.png"];
	}
}

-(void)showInviteFriendAlert{
    if(!inviteFriendAlert){
        self.inviteFriendAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Facebook friends who recieve the invite and join TTP will automatically be joined to your frineds list" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite", nil];
    }
    inviteFriendAlert.title = [NSString stringWithFormat:@"Invite %@ via Facebook?",[self.friendDict valueForKey:@"name"]];
    [inviteFriendAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == inviteFriendAlert && buttonIndex == 1){
        [[SocialManager sharedInstance] inviteFacebookFriends:[self.friendDict valueForKey:@"id"]];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
