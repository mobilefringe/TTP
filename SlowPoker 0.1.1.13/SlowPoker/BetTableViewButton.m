//
//  BetTableViewButton.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BetTableViewButton.h"

@implementation BetTableViewButton

@synthesize tableViewBackground;
@synthesize tableViewLabel;
@synthesize betViewBackground;
@synthesize betViewLabel;
@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.betViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"bet_view_button.png"]];
        betViewBackground.frame = self.bounds;
        betViewBackground.userInteractionEnabled = YES;
        self.betViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 90, 27)];
        betViewLabel.textAlignment = UITextAlignmentCenter;
        betViewLabel.userInteractionEnabled = YES;
        betViewLabel.textColor = [UIColor whiteColor];
        betViewLabel.font = [UIFont boldSystemFontOfSize:15];
        betViewLabel.minimumFontSize = 12;
        betViewLabel.adjustsFontSizeToFitWidth = YES;
        betViewLabel.backgroundColor = [UIColor clearColor];
        betViewLabel.text = @"Bet View";
        [betViewBackground addSubview:betViewLabel];
        [self addSubview:betViewBackground];
        betViewBackground.hidden = YES;
        
        
        self.tableViewBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"table_view_button.png"]];
        tableViewBackground.userInteractionEnabled = YES;
        tableViewBackground.frame = self.bounds;
        self.tableViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 90, 27)];
        tableViewLabel.textAlignment = UITextAlignmentCenter;
        tableViewLabel.userInteractionEnabled = YES;
        tableViewLabel.font = [UIFont boldSystemFontOfSize:15];
        tableViewLabel.minimumFontSize = 12;
        tableViewLabel.adjustsFontSizeToFitWidth = YES;
        tableViewLabel.textColor = [UIColor whiteColor];
        tableViewLabel.backgroundColor = [UIColor clearColor];
        tableViewLabel.text = @"Table View";
        [tableViewBackground addSubview:tableViewLabel];
        [self addSubview:tableViewBackground];
        tableViewBackground.hidden = YES;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.showsTouchWhenHighlighted = NO;
        button.frame = self.bounds;
        
        [self addSubview:button];
        
        
    }
    return self;
}

-(void)setAsBetView:(BOOL)animated{
    
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self
                                 cache:YES]; 
    }
    betViewBackground.hidden = NO;
    tableViewBackground.hidden = YES;
    if(animated){
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
    
   
}

-(void)setAsTableView:(BOOL)animated{
    if(animated){
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self
                                 cache:YES]; 
    }
    betViewBackground.hidden = YES;
    tableViewBackground.hidden = NO;
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
