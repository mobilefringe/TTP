//
//  BetTableViewButton.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetTableViewButton : UIView{
    UIImageView *tableViewBackground;
    UILabel *tableViewLabel;
    UIImageView *betViewBackground;
    UILabel *betViewLabel;
    UIButton *button;
}

@property (nonatomic,retain)UIImageView *tableViewBackground;
@property (nonatomic,retain)UILabel *tableViewLabel;
@property (nonatomic,retain)UIImageView *betViewBackground;
@property (nonatomic,retain)UILabel *betViewLabel;
@property (nonatomic,retain)UIButton *button;

-(void)setAsTableView:(BOOL)animated;
-(void)setAsBetView:(BOOL)animated;
@end
