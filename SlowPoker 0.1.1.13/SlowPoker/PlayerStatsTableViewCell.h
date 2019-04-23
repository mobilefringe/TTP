//
//  PlayerStatsTableViewCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerStatsTableViewCell : UITableViewCell{
    UILabel *gamesLabel;
    UILabel *handsLabel;
    UILabel *cashEarningsLabel;
    UILabel *tournamentsLabel;
    
    UILabel *gamesValueLabel;
    UILabel *handsValueLabel;
    UILabel *cashValueEarningsLabel;
    UILabel *tournamentsValueLabel;
    
    UILabel *subtextLabel;
    UIImageView *background;
}

@property(nonatomic,retain)UILabel *gamesLabel;
@property(nonatomic,retain)UILabel *handsLabel;
@property(nonatomic,retain)UILabel *cashEarningsLabel;
@property(nonatomic,retain)UILabel *tournamentsLabel;

@property(nonatomic,retain)UILabel *gamesValueLabel;
@property(nonatomic,retain)UILabel *handsValueLabel;
@property(nonatomic,retain)UILabel *cashValueEarningsLabel;
@property(nonatomic,retain)UILabel *tournamentsValueLabel;

@property(nonatomic,retain)UILabel *subtextLabel;

-(int)statDouble:(NSString *)statCode;
-(void)setStatData:(NSMutableDictionary *)playerProfieDict;


@end
