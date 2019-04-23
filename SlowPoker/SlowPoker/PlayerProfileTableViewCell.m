//
//  PlayerProfileTableViewCell.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerProfileTableViewCell.h"
#import "Avatar.h"
#import "TTTTimeIntervalFormatter.h"
#import "DataManager.h"

@implementation PlayerProfileTableViewCell

@synthesize avatar;
@synthesize userNameLabel;
@synthesize locationLabel;
@synthesize playerSinceLabel;
@synthesize lastLoggedInLabel;
@synthesize utcFormatter;
@synthesize localFormatter;
@synthesize timeIntervalFormatter;
@synthesize userIDLabel;
@synthesize addFriendsLabel;
@synthesize addFriendButton;
@synthesize removeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_cell_background.png"]];
        background.frame = CGRectMake(-10, -10, 320, 110);
        [self.contentView addSubview:background];
        
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(9, 9, 68, 71)];
        avatar.radius = 130;
        avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:avatar];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 8, 185, 23)];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 12;
        userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        userNameLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        [self.contentView addSubview:userNameLabel];
        
        self.userIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 3, 90, 15)];
        userIDLabel.backgroundColor = [UIColor clearColor];
        userIDLabel.adjustsFontSizeToFitWidth = YES;
        userIDLabel.minimumFontSize = 12;
        userIDLabel.textColor = [UIColor lightGrayColor];
        userIDLabel.textAlignment = UITextAlignmentRight;
        userIDLabel.font = [UIFont systemFontOfSize:13];
        //[self.contentView addSubview:userIDLabel];
        
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 28, 185, 18)];
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.adjustsFontSizeToFitWidth = YES;
        locationLabel.minimumFontSize = 12;
        locationLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:locationLabel];
        
        self.playerSinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 43, 185, 20)];
        playerSinceLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        playerSinceLabel.backgroundColor = [UIColor clearColor];
        playerSinceLabel.adjustsFontSizeToFitWidth = YES;
        playerSinceLabel.minimumFontSize = 12;
        playerSinceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:playerSinceLabel];
        
        self.lastLoggedInLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 63, 185, 20)];
        lastLoggedInLabel.textColor = [UIColor lightGrayColor];
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
        
        self.addFriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 66, 185, 18)];
        addFriendsLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        addFriendsLabel.backgroundColor = [UIColor clearColor];
        addFriendsLabel.adjustsFontSizeToFitWidth = YES;
        addFriendsLabel.minimumFontSize = 12;
        addFriendsLabel.textAlignment = UITextAlignmentCenter;
        addFriendsLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:addFriendsLabel];
        
        

        
    }
    return self;
}

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict isFriend:(BOOL)isFriend{
    [avatar loadAvatar:[playerProfieDict valueForKey:@"userID"]];
    userNameLabel.text = [playerProfieDict valueForKey:@"userName"];
    userIDLabel.text = [NSString stringWithFormat:@"User ID: %@",[playerProfieDict valueForKey:@"userID"]];
    
    NSLocale *locale = [NSLocale currentLocale];
    locationLabel.text = [locale displayNameForKey: NSLocaleCountryCode value: [playerProfieDict valueForKey:@"countryCode"]];
    
    NSDate *playerSince = [utcFormatter dateFromString:[playerProfieDict valueForKey:@"created_at"]];
    playerSinceLabel.text = [NSString stringWithFormat:@"Player Since: %@",[localFormatter stringFromDate:playerSince]];
    
    NSDate *lastLoggedInDate = [utcFormatter dateFromString:[playerProfieDict valueForKey:@"lastLoginDate"]];
    lastLoggedInLabel.text = [NSString stringWithFormat:@"Last Online: %@",[timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:lastLoggedInDate]];
    
    if([[playerProfieDict valueForKey:@"userID"] isEqualToString:[DataManager sharedInstance].myUserID]){
        addFriendsLabel.text = @"Upload Profile Image";
    }else{
        addFriendsLabel.text = @"";
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
        // Configure the view for the selected state
}

@end
