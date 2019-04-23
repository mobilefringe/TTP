//
//  InvitePlayerCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Avatar;

@interface InvitePlayerCell : UITableViewCell{
    UILabel *userName;
    UILabel *emailAddress;
    Avatar *avatar;
    UIImageView *checkMark;
    UIImageView *background;
}

@property(nonatomic,retain)UILabel *userName;
@property(nonatomic,retain)UILabel *emailAddress;
@property(nonatomic,retain)Avatar *avatar;
@property(nonatomic,retain)UIImageView *checkMark;
-(void)loadPlayerData:(NSMutableDictionary *)player showCheckMark:(BOOL)showCheckMark;
@end
