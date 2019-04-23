//
//  StoreTableCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreFront.h"

@interface StoreTableCell : UITableViewCell{
    UILabel *itemName;
    UILabel *itemDesc;
    UIImageView *itemIcon;
    UILabel *itemValue;
    UIButton *buyButton;
    UILabel *price;
    NSMutableDictionary *thisProduct;
    UIImageView *proChip;
    UILabel *value;
}

@property(nonatomic,retain)UILabel *itemName;
@property(nonatomic,retain)UILabel *itemDesc;
@property(nonatomic,retain)UIImageView *itemIcon;
@property(nonatomic,retain)UILabel *itemValue;
@property(nonatomic,retain)UIButton *buyButton;
@property(nonatomic,retain)UILabel *price;
@property(nonatomic,retain)NSMutableDictionary *thisProduct;
@property(nonatomic,retain)UIImageView *proChip;
@property(nonatomic,retain)UILabel *value;
-(void)setProduct:(NSMutableDictionary *)product;
-(double)calculateSavings;

@end
