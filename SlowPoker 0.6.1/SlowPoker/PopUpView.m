//
//  PopUpView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopUpView.h"

@implementation PopUpView

@synthesize popupBackgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 490)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.popupBackgroundImage = [[UIImageView alloc] initWithFrame:frame];
        [popupBackgroundImage setImage:[UIImage imageNamed:@"pop_up_background.png"]];
        [self addSubview:popupBackgroundImage];
    }
    [self hide];
    return self;
}

-(void)show{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    self.alpha = 1;
    [UIView commitAnimations];
}

-(void)hide{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    self.alpha = 0;
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
