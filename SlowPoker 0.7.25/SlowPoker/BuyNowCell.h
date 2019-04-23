//
//  BuyNowCell.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyNowCell : UITableViewCell{
    UIImage *buyNowImage;
    UIImage *thankYouImage;
    UIImageView *chipImageView;
    UIImageView *chipImageView2;
    UIImageView *proChip;
    UILabel *chipLabel;
    UILabel *proChipsTitle;
    UILabel *buyDescription;
    UIImage *lockedImage;
    UIImage *unlockedImage;
    UIImageView *isLockedImageView;
    UILabel *isLockedLabel;
    UIView *flipView;
    BOOL isPurchasedBOOL;
    NSMutableDictionary *cellData;
}

@property(nonatomic,retain)UIImage *buyNowImage;
@property(nonatomic,retain)UIImage *thankYouImage;
@property(nonatomic,retain)UIImageView *chipImageView;
@property(nonatomic,retain)UIImageView *chipImageView2;
@property(nonatomic,retain)UIImageView *proChip;
@property(nonatomic,retain)UILabel *chipLabel;
@property(nonatomic,retain)UILabel *proChipsTitle;
@property(nonatomic,retain)UILabel *buyDescription;
@property(nonatomic,retain)UIImage *lockedImage;
@property(nonatomic,retain)UIImage *unlockedImage;
@property(nonatomic,retain)UIImageView *isLockedImageView;
@property(nonatomic,retain)UILabel *isLockedLabel;
@property(nonatomic,retain)UIView *flipView;
@property(nonatomic,retain)NSMutableDictionary *cellData;
@property(readwrite)BOOL isPurchasedBOOL;

-(void)setCellData:(NSMutableDictionary *)data isPurchased:(BOOL)isPurchased;
-(void)updateData:(BOOL)animated;

@end
