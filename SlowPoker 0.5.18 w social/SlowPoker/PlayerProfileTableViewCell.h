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
    UILabel *userNameLabel;
    UILabel *locationLabel;
    UILabel *playerSinceLabel;
    UILabel *lastLoggedInLabel;
    UILabel *userIDLabel;
    NSDateFormatter *utcFormatter;
    NSDateFormatter *localFormatter;
    TTTTimeIntervalFormatter *timeIntervalFormatter;
    
    
    
    
}

@property (nonatomic,retain)Avatar *avatar;
@property (nonatomic,retain)UILabel *userNameLabel;
@property (nonatomic,retain)UILabel *locationLabel;
@property (nonatomic,retain)UILabel *playerSinceLabel;
@property (nonatomic,retain)UILabel *lastLoggedInLabel;
@property (nonatomic,retain)UILabel *userIDLabel;
@property (nonatomic, retain) NSDateFormatter *utcFormatter;
@property (nonatomic,retain)NSDateFormatter *localFormatter;
@property (nonatomic, retain) TTTTimeIntervalFormatter *timeIntervalFormatter;

-(void)setProfileData:(NSMutableDictionary *)playerProfieDict;

@end
