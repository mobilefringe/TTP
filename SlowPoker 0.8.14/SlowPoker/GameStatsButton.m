//
//  GameStatsButton.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStatsButton.h"

@implementation GameStatsButton

@synthesize buttonImage;
@synthesize regularImage;
@synthesize selectedImage;
@synthesize button;
@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonImage = [[UIImageView alloc] initWithFrame:self.bounds];
        buttonImage.userInteractionEnabled = YES;
        [self addSubview:buttonImage];
        self.regularImage = [UIImage imageNamed:@"stats_button_regular.png"];
        self.selectedImage = [UIImage imageNamed:@"stats_button_selected.png"];
    
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 85, 27)];
        label.textAlignment = UITextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.minimumFontSize = 12;
        label.adjustsFontSizeToFitWidth = YES;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"Game Stats";
        [buttonImage addSubview:label];
        
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.showsTouchWhenHighlighted = NO;
        button.frame = self.bounds;
        [self addSubview:button];
        
        [self unselectButton:NO];
    }
    return self;
}


-(void)selectButton:(BOOL)animated{
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.2];
        

    }
    [buttonImage setImage:selectedImage];
    if(animated){
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}

-(void)unselectButton:(BOOL)animated{
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.2];
        
    }
    [buttonImage setImage:regularImage];
    if(animated){
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
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
