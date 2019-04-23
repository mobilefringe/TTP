//
//  MyFriendsTableCellCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyFriendsTableCellCell.h"
#import "Avatar.h"
#import "TTTTimeIntervalFormatter.h"
#import "AchievementIcon.h"
#import "DataManager.h"

@implementation MyFriendsTableCellCell

@synthesize avatar;
@synthesize userNameLabel;
@synthesize activeGamesLabel;
@synthesize activeGamesValue;
@synthesize lastLoggedInLabel;
@synthesize utcFormatter;
@synthesize localFormatter;
@synthesize timeIntervalFormatter;
@synthesize isFacebookInstructions;
@synthesize isContactsInstructions;
@synthesize isEmailInstructions;
@synthesize instructions;
@synthesize bestPrimaryAchievement;
@synthesize friendTypeImageView;
@synthesize addFriendTypeImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_body_general.png"]];
        background.frame = CGRectMake(-10, 0, 320, 70);
        [self.contentView addSubview:background];
        
        
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(9, 7, 55, 55)];
        avatar.userInteractionEnabled = YES;
        avatar.radius = 70;
        [self.contentView addSubview:avatar];
        
        self.friendTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 20, 20)];
        [avatar addSubview:friendTypeImageView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 140, 23)];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 12;
        userNameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:userNameLabel];
        
        
        self.bestPrimaryAchievement = [[UIImageView alloc] initWithFrame:CGRectMake(65, 15, 140*.60, 100*.60)];
        [self.contentView addSubview:bestPrimaryAchievement];
        
        
        
        self.activeGamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 8, 60, 30)];
        activeGamesLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        activeGamesLabel.backgroundColor = [UIColor clearColor];
        //activeGamesLabel.adjustsFontSizeToFitWidth = YES;
        activeGamesLabel.numberOfLines = 2;
        //activeGamesLabel.minimumFontSize = 12;
        activeGamesLabel.textAlignment = UITextAlignmentCenter;
        activeGamesLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:activeGamesLabel];
        
        self.activeGamesValue = [[UILabel alloc] initWithFrame:CGRectMake(215, 37, 60, 30)];
        activeGamesValue.textColor = [UIColor whiteColor];
        activeGamesValue.backgroundColor = [UIColor clearColor];
        activeGamesValue.adjustsFontSizeToFitWidth = YES;
        activeGamesValue.textAlignment = UITextAlignmentCenter;
        activeGamesValue.minimumFontSize = 12;
        activeGamesValue.font = [UIFont boldSystemFontOfSize:26];
        [self.contentView addSubview:activeGamesValue];
        
        self.lastLoggedInLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 46, 185, 20)];
        lastLoggedInLabel.textColor = [UIColor whiteColor];
        lastLoggedInLabel.backgroundColor = [UIColor clearColor];
        lastLoggedInLabel.adjustsFontSizeToFitWidth = YES;
        lastLoggedInLabel.minimumFontSize = 12;
        lastLoggedInLabel.font = [UIFont systemFontOfSize:13];
        //[self.contentView addSubview:lastLoggedInLabel];
        
        self.utcFormatter = [[NSDateFormatter alloc] init];
        [utcFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSTimeZone *UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [utcFormatter setTimeZone:UTCTimeZone];
        
        self.localFormatter = [[NSDateFormatter alloc] init];
        [localFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        
        
        self.addFriendTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 55, 55)];
        [self.contentView addSubview:addFriendTypeImageView];

        
        self.instructions = [[UILabel alloc] initWithFrame:CGRectMake(70, 19, 200, 50)];
        instructions.textColor = [UIColor whiteColor];
        instructions.backgroundColor = [UIColor clearColor];
        //activeGamesLabel.adjustsFontSizeToFitWidth = YES;
        instructions.numberOfLines = 3;
        //activeGamesLabel.minimumFontSize = 12;
        instructions.textAlignment = UITextAlignmentLeft;
        instructions.text = @"See which of your Facebook friends are playing TTP! Add your friends and challenge them to a game.";
        instructions.font = [UIFont boldSystemFontOfSize:10];
        [self.contentView addSubview:instructions];
        
        
    }
    return self;
}

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict{
    //NSLog(@"myFriend:%@",playerProfieDict);
    if(isFacebookInstructions || isContactsInstructions || isEmailInstructions){
        avatar.hidden = YES;
        bestPrimaryAchievement.hidden = YES;
        activeGamesLabel.hidden = YES;
        activeGamesValue.hidden = YES;
        lastLoggedInLabel.hidden = YES;
        instructions.hidden = NO;
        addFriendTypeImageView.hidden = NO;
        if(isFacebookInstructions){
            [addFriendTypeImageView setImage:[UIImage imageNamed:@"facebookicon.png"]];
            userNameLabel.text = @"Add Facebook Friends";
            instructions.text = @"See which of your Facebook friends are playing TTP! Add your friends and challenge them to a game.";
        }else if(isContactsInstructions){
            [addFriendTypeImageView setImage:[UIImage imageNamed:@"iphone-contacts.png"]];
            userNameLabel.text = @"Add Contact Friends";
            instructions.text = @"See which of your contacts are playing TTP! Add your friends and challenge them to a game.";
        }else if(isEmailInstructions){
            [addFriendTypeImageView setImage:[UIImage imageNamed:@"emailicon.png"]];
            userNameLabel.text = @"Add Friends by Email";
            instructions.text = @"Search for your friends by email and challenge them to a game!";
        }
        return;
    }
    bestPrimaryAchievement.hidden = NO;
    addFriendTypeImageView.hidden = YES;
    instructions.hidden = YES;
    avatar.hidden = NO;
    userNameLabel.hidden = NO;
    activeGamesLabel.hidden = NO;
    activeGamesValue.hidden = NO;
    lastLoggedInLabel.hidden = NO;
    
    
    NSMutableArray *playerAchievements = [playerProfieDict valueForKey:@"achievements"];
    //NSLog(@"playerAchievements:%@",playerAchievements);
    NSString *imageKey = @"achievement.BLACK_BRACELET.imageLocked";
    if([self hasAchievement:@"PLATINUM_BRACELET" achievements:playerAchievements]){
        imageKey = @"achievement.PLATINUM_BRACELET.imageUnLocked";
    }else if([self hasAchievement:@"GOLD_BRACELET" achievements:playerAchievements]){
        imageKey = @"achievement.GOLD_BRACELET.imageUnLocked";
    }else if([self hasAchievement:@"SILVER_BRACELET" achievements:playerAchievements]){
        imageKey = @"achievement.SILVER_BRACELET.imageUnLocked";
    }else if([self hasAchievement:@"BRONZE_BRACELET" achievements:playerAchievements]){
        imageKey = @"achievement.BRONZE_BRACELET.imageUnLocked";
    }else if([self hasAchievement:@"BLACK_BRACELET" achievements:playerAchievements]){
        imageKey = @"achievement.BLACK_BRACELET.imageUnLocked";
    }
    
    friendTypeImageView.hidden = NO;
    if([[playerProfieDict valueForKey:@"type"] isEqualToString:@"Facebook"]){
        [friendTypeImageView setImage:[UIImage imageNamed:@"facebookicon.png"]];
    }else if([[playerProfieDict valueForKey:@"type"] isEqualToString:@"Twitter"]){
        [friendTypeImageView setImage:[UIImage imageNamed:@"facebook-logo"]];
    }else{
        friendTypeImageView.hidden = YES;
    }
    
    NSString *imageName = NSLocalizedString(imageKey,nil);
    [bestPrimaryAchievement setImage:[UIImage imageNamed:imageName]];
    
    
    
    
    //NSLog(@"playerProfieDict:%@",playerProfieDict);
    [avatar loadAvatar:[playerProfieDict valueForKey:@"userID"]];
    userNameLabel.text = [playerProfieDict valueForKey:@"userName"];
    
    activeGamesLabel.text = @"Active Games";
    activeGamesValue.text = [playerProfieDict valueForKey:@"numberOfActiveGames"];
    NSDate *lastLoggedInDate = [utcFormatter dateFromString:[playerProfieDict valueForKey:@"lastLoginDate"]];
    lastLoggedInLabel.text = [NSString stringWithFormat:@"Online: %@",[timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:lastLoggedInDate]];
    
}


-(BOOL)hasAchievement:(NSString *)code achievements:(NSMutableArray *)achievements{
    for (NSMutableDictionary *achievement in achievements) {
        if([code isEqualToString:[achievement valueForKey:@"code"]]){
            return YES;
        }
    }
    return NO;
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
