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
    UIView *gameDetailsView;
    UIImageView *cashImageView;
    UIImageView *tournamentImageView;
    UIImageView *cashImageView2;
    UIImageView *tournamentImageView2;
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}

@property (nonatomic,retain)UIButton *backButton;
@property (nonatomic,retain)UILabel *header;
@property (nonatomic,retain)UIImageView *slider;
@property (nonatomic,retain)NSString *navTitle;
@property (nonatomic,retain)ProChip *proChip;
@property (nonatomic,retain)UIImageView *backImageView;
@property (nonatomic,retain)UIButton *settingsButton;
@property (nonatomic,retain)UIImageView *settingsIcon;
@property (nonatomic,retain)UIImageView *cashImageView;
@property (nonatomic,retain)UIImageView *tournamentImageView;
@property (nonatomic,retain)UIImageView *cashImageView2;
@property (nonatomic,retain)UIImageView *tournamentImageView2;
@property (nonatomic,retain)UIView *gameDetailsView;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,retain)UILabel *subtitleLabel;
-(void)updateHeaderWithTitle:(NSString *)title;
-(void)showSettings;
-(void)showBackButton;
-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight;


@end
