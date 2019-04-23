//
//  MyFriendsTableCellCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;
@class TTTTimeIntervalFormatter;

@interface MyFriendsTableCellCell : UITableViewCell{
    Avatar *avatar;
    UILabel *userNameLabel;
    UILabel *activeGamesLabel;
    UILabel *activeGamesValue;
    UILabel *lastLoggedInLabel;
    NSDateFormatter *utcFormatter;
    NSDateFormatter *localFormatter;
    TTTTimeIntervalFormatter *timeIntervalFormatter;
}

@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *activeGamesLabel;
@property (nonatomic,retain)UILabel *activeGamesValue;
@property (nonatomic,retain)UILabel *lastLoggedInLabel;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic,retain)NSDateFormatter *localFormatter;
@property (nonatomic, retain) TTTTimeIntervalFormatter *timeIntervalFormatter;

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict;

@end
