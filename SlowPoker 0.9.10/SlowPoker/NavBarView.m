//
//  NavBarView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavBarView.h"
#import "ProChip.h"

@implementation NavBarView

@synthesize backButton;
@synthesize header;
@synthesize slider;
@synthesize navTitle;
@synthesize proChip;
@synthesize backImageView;
@synthesize settingsButton;
@synthesize settingsIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        UIView *backColor = [[UIView alloc] initWithFrame:self.bounds];
        backColor.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
        [self addSubview:backColor];
        
        self.header = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 170, 30)];
        header.backgroundColor = [UIColor clearColor];
        header.font = [UIFont boldSystemFontOfSize:19];
        header.textAlignment = UITextAlignmentCenter;
        header.text = @"TTP";
        header.textColor = [UIColor whiteColor];
        [self addSubview:header];
        
        sliderImage = [UIImage imageNamed:@"slider.png"];
        self.slider = [[UIImageView alloc] initWithFrame:CGRectMake(63, 10, sliderImage.size.width/2, sliderImage.size.height/2)];
        slider.userInteractionEnabled = YES;
        slider.image = sliderImage;
        [self addSubview:slider];
        
        
        UIImage *backgroundImage = [UIImage imageNamed:@"header_background.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        backgroundImageView.userInteractionEnabled = YES;
        backgroundImageView.image = backgroundImage;
        [self addSubview:backgroundImageView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backButtonImage = [UIImage imageNamed:@"back_button.png"];
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 35, 35)];
        backButton.showsTouchWhenHighlighted = YES;
        backImageView.image = backButtonImage;
        backImageView.userInteractionEnabled = YES;
        backButton.frame = CGRectMake(0, 0, 68, 43);
        backButton.backgroundColor = [UIColor clearColor];
        [self addSubview:backImageView];
        //[backButton setImage:backButtonImage forState:UIControlStateNormal];
        [self addSubview:backButton];
        
        self.settingsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 35, 35)];
        settingsIcon.image = [UIImage imageNamed:@"settings-icon2.png"];
        settingsIcon.userInteractionEnabled = YES;
        [self addSubview:settingsIcon];
        settingsIcon.alpha = 0;
        
        self.settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.showsTouchWhenHighlighted = YES;
        settingsButton.frame = CGRectMake(0, 0, 68, 43);
        settingsButton.backgroundColor = [UIColor clearColor];
        [self addSubview:settingsButton];
        settingsButton.alpha = 0;
        
        self.proChip = [[ProChip alloc] initWithFrame:CGRectMake(263, 3, 42, 42)];
        [self addSubview:proChip];
        
        
    }
    return self;
}



-(void)updateHeaderWithTitle:(NSString *)title showLeft:(BOOL)showLeft showRight:(BOOL)showRight{
    backButton.hidden = !showLeft;
    backImageView.hidden = !showLeft;
    proChip.hidden = !showRight;
    if([self.navTitle isEqualToString:title]){
        return;
    }
    self.navTitle = title;
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.4];
    
    slider.frame = CGRectMake(63, 10, sliderImage.size.width/2, sliderImage.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(openSlider)];
    [UIView commitAnimations];
}

-(void)openSlider{
    header.text = navTitle;
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:.4];
    
    slider.frame = CGRectMake(-163, 10, sliderImage.size.width/2, sliderImage.size.height/2);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)showSettings{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    backButton.alpha = 0;
    backImageView.alpha = 0;
    settingsButton.alpha = 1;
    settingsIcon.alpha = 1;
    
    [UIView commitAnimations];
}

-(void)showBackButton{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.2];
    backButton.alpha = 1;
    backImageView.alpha = 1;
    settingsButton.alpha = 0;
    settingsIcon.alpha = 0;
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
