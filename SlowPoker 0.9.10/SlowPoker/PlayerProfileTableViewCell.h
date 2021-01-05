//
//  PlayerProfileTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Avatar;
@class TTTTimeIntervalFormatter;

@interface PlayerProfileTableViewCell : UITableViewCell{
    Avatar *avatar;
    Avatar *avatarWithoutRadius;
    UILabel *userNameLabel;
    UILabel *locationLabel;
    UILabel *playerSinceLabel;
    UILabel *lastLoggedInLabel;
    UILabel *userIDLabel;
    NSDateFormatter *utcFormatter;
    NSDateFormatter *localFormatter;
    TTTTimeIntervalFormatter *timeIntervalFormatter;
    UILabel *addFriendsLabel;
    UIButton *addFriendButton;
    UIButton *removeButton;
    
    
    
    
    
}

@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)Avatar *avatarWithoutRadius;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *locationLabel;
@property (nonatomic,retain)UILabel *playerSinceLabel;
@property (nonatomic,retain)UILabel *lastLoggedInLabel;
@property (nonatomic,retain)UILabel *userIDLabel;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic,retain)NSDateFormatter *localFormatter;
@property (nonatomic, retain) TTTTimeIntervalFormatter *timeIntervalFormatter;
@property (nonatomic, retain) UILabel *addFriendsLabel;
@property (nonatomic, retain) UIButton *addFriendButton;
@property (nonatomic, retain) UIButton *removeButton;

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict isFriend:(BOOL)isFriend;

@end
