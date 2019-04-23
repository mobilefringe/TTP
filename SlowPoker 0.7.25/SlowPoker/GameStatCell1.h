//
//  GameStatCell1.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;

@interface GameStatCell1 : UITableViewCell{
     Avatar *avatar;
    UILabel *rankLabel;
    UILabel *userNameLabel;
    UILabel *chipStackLabel;
    UILabel *netLabel;
    NSString *userID;
    UIImageView *chipImageView;
    UIImage *greenChip;
    UIImage *redChip;
    UIImage *yellowChip;
    UIImageView *background;
    
}

@property(nonatomic,retain)UILabel *rankLabel;
@property(nonatomic,retain)UILabel *userNameLabel;
@property(nonatomic,retain)UILabel *chipStackLabel;
@property(nonatomic,retain)UILabel *netLabel;
@property(nonatomic,retain)NSString *userID;
@property (nonatomic,retain)UIImageView *chipImageView;
@property (nonatomic,retain)UIImage *greenChip;
@property (nonatomic,retain)UIImage *redChip;
@property (nonatomic,retain)UIImage *yellowChip;

-(void)setCellData:(NSMutableDictionary *)data rank:(int)rank isTournament:(BOOL)isTournament;


@end
