//
//  ProChipsTableCellCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProChipsTableCellCell : UITableViewCell{
    UIImageView *background;
    UIImageView *proChipImage;
    UILabel *title;
    UILabel *description;
    UILabel *proChipValue;
}

@property(nonatomic,retain)UIImageView *proChipImage;
@property(nonatomic,retain)UILabel *title;
@property(nonatomic,retain)UILabel *description;
@property(nonatomic,retain)UILabel *proChipValue;

-(void)setData:(int)type;

@end
