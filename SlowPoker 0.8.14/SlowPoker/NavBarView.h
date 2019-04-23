//
//  NavBarView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProChip;

@interface NavBarView : UIView{
    UIButton *backButton;
    UILabel *header;
    UIImageView *slider;
    UIImage *sliderImage;
    NSString *navTitle;
    ProChip *proChip;
    UIImageView *backImageView;
    UIButton *settingsButton;
    UIImageView *settingsIcon;
}

@property (nonatomic,retain)UIButton *backButton;
@property (nonatomic,retain)UILabel *header;
@property (nonatomic,retain)UIImageView *slider;
@property (nonatomic,retain)NSString *navTitle;
@property (nonatomic,retain)ProChip *proChip;
@property (nonatomic,retain)UIImageView *backImageView;
@property (nonatomic,retain)UIButton *settingsButton;
@property (nonatomic,retain)UIImageView *settingsIcon;
-(void)updateHeaderWithTitle:(NSString *)title;
-(void)showSettings;
-(void)showBackButton;
-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight;


@end
