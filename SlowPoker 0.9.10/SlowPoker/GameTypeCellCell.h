//
//  GameTypeCellCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTypeCellCell : UITableViewCell{
    UILabel *title;
    UILabel *description;
    UIImage *cashImage;
    UIImage *tournamentImage;
    UIImageView *imageView;
    UIImageView *background;
}

@property(nonatomic,retain) UILabel *title;
@property(nonatomic,retain) UILabel *description;
@property(nonatomic,retain) UIImage *cashImage;
@property(nonatomic,retain) UIImage *tournamentImage;
@property(nonatomic,retain) UIImageView *imageView;

-(void)setData:(BOOL)isCash;

@end
