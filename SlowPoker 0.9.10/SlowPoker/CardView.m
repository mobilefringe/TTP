//
//  CardView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-08-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"
#import "DataManager.h"

@implementation CardView

@synthesize frontImageView;
@synthesize backImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:frontImageView];
        backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [backImageView setImage:[[DataManager sharedInstance].cardImages objectForKey:@"?"]];
        [self addSubview:backImageView];
    }
    return self;
}

-(void)loadCard:(NSString *)cardValue animated:(BOOL)animated delay:(double)delay{
    [frontImageView removeFromSuperview];
    [self addSubview:backImageView];
    if(![cardValue isEqualToString:@"?"]){
        [frontImageView setImage:[[DataManager sharedInstance].cardImages objectForKey:cardValue]];
        if(animated){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:delay];
            
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self
                                     cache:YES]; 
            [backImageView removeFromSuperview];
            [self addSubview:frontImageView];
            [UIView commitAnimations];

        }else{
            [backImageView removeFromSuperview];
            [self addSubview:frontImageView];
        }
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
