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

@implementation MyFriendsTableCellCell

@synthesize avatar;
@synthesize userNameLabel;
@synthesize activeGamesLabel;
@synthesize activeGamesValue;
@synthesize lastLoggedInLabel;
@synthesize utcFormatter;
@synthesize localFormatter;
@synthesize timeIntervalFormatter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(9, 7, 55, 55)];
        avatar.userInteractionEnabled = YES;
        [self.contentView addSubview:avatar];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 27, 185, 23)];
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        userNameLabel.minimumFontSize = 12;
        userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:userNameLabel];
        
        self.activeGamesLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 8, 60, 27)];
        activeGamesLabel.textColor = [UIColor lightGrayColor];
        activeGamesLabel.backgroundColor = [UIColor clearColor];
        //activeGamesLabel.adjustsFontSizeToFitWidth = YES;
        activeGamesLabel.numberOfLines = 2;
        //activeGamesLabel.minimumFontSize = 12;
        activeGamesLabel.textAlignment = UITextAlignmentCenter;
        activeGamesLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:activeGamesLabel];
        
        self.activeGamesValue = [[UILabel alloc] initWithFrame:CGRectMake(215, 37, 60, 30)];
        activeGamesValue.textColor = [UIColor darkGrayColor];
        activeGamesValue.backgroundColor = [UIColor clearColor];
        activeGamesValue.adjustsFontSizeToFitWidth = YES;
        activeGamesValue.textAlignment = UITextAlignmentCenter;
        activeGamesValue.minimumFontSize = 12;
        activeGamesValue.font = [UIFont boldSystemFontOfSize:26];
        [self.contentView addSubview:activeGamesValue];
        
        self.lastLoggedInLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 46, 185, 20)];
        lastLoggedInLabel.textColor = [UIColor darkGrayColor];
        lastLoggedInLabel.backgroundColor = [UIColor clearColor];
        lastLoggedInLabel.adjustsFontSizeToFitWidth = YES;
        lastLoggedInLabel.minimumFontSize = 12;
        lastLoggedInLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lastLoggedInLabel];
        
        self.utcFormatter = [[NSDateFormatter alloc] init];
        [utcFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSTimeZone *UTCTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [utcFormatter setTimeZone:UTCTimeZone];
        
        self.localFormatter = [[NSDateFormatter alloc] init];
        [localFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        self.timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        
        
        
        
    }
    return self;
}

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict{
    //NSLog(@"playerProfieDict:%@",playerProfieDict);
    [avatar loadAvatar:[playerProfieDict valueForKey:@"userID"]];
    userNameLabel.text = [playerProfieDict valueForKey:@"userName"];
    
    activeGamesLabel.text = @"Active Games";
    activeGamesValue.text = [playerProfieDict valueForKey:@"numberOfActiveGames"];
    NSDate *lastLoggedInDate = [utcFormatter dateFromString:[playerProfieDict valueForKey:@"lastLoginDate"]];
    lastLoggedInLabel.text = [NSString stringWithFormat:@"Online: %@",[timeIntervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:lastLoggedInDate]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        userNameLabel.textColor = [UIColor whiteColor];
    }else{
        userNameLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

@end
