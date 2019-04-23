//
//  GiftButton.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftButton : UIView{
    UIImageView *backgroundImageView;
    UIImage *regularImage;
    UIImage *selectedImage;
    
    UIButton *giftButton;
    NSMutableDictionary *giftData;
    BOOL pressed;
    UIImageView *giftImage;
    BOOL selected;
    
}
@property(nonatomic,retain)UIImageView *backgroundImageView;
@property(nonatomic,retain)UIImage *regularImage;
@property(nonatomic,retain)UIImage *selectedImage;

@property(nonatomic,retain)UIButton *giftButton;
@property(nonatomic,retain)NSMutableDictionary *giftData;
@property(nonatomic,retain)UIImageView *giftImage;
@property(readwrite)BOOL pressed;
@property(readwrite)BOOL selected;
- (id)initWithFrame:(CGRect)frame data:(NSMutableDictionary *)data;
-(void)unselectGift;
-(void)selectGift;

@end
