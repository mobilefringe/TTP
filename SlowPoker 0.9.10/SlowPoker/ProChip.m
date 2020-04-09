//
//  ProChip.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-06-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProChip.h"
#import "DataManager.h"
#import "AppDelegate.h"

@implementation ProChip

@synthesize imageViewFront;
@synthesize imageViewBack;
@synthesize front;
@synthesize back;
@synthesize amountLabel;
@synthesize incrementLabel;
@synthesize button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.front = [UIImage imageNamed:@"pro_chip_front.png"];
        self.back = [UIImage imageNamed:@"pro_chip_back.png"];
        
        self.imageViewFront = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageViewFront.userInteractionEnabled = YES;
        imageViewFront.image = front;
        
        self.imageViewBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageViewBack.userInteractionEnabled = YES;
        imageViewBack.image = back;
        
        [self addSubview:imageViewFront];
        
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 14, 21, 12)];
        amountLabel.textColor = [UIColor blackColor];
        amountLabel.userInteractionEnabled = YES;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont boldSystemFontOfSize:13];
        amountLabel.textAlignment = UITextAlignmentCenter;
        amountLabel.adjustsFontSizeToFitWidth = YES;
        amountLabel.minimumFontSize = 6;
        //amountLabel.text = @"123";
        [imageViewFront addSubview:amountLabel];
        
        self.incrementLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 14, 21, 12)];
        incrementLabel.textColor = [UIColor blackColor];
        incrementLabel.userInteractionEnabled = YES;
        incrementLabel.backgroundColor = [UIColor clearColor];
        incrementLabel.font = [UIFont boldSystemFontOfSize:17];
        incrementLabel.textAlignment = UITextAlignmentCenter;
        incrementLabel.adjustsFontSizeToFitWidth = YES;
        incrementLabel.minimumFontSize = 6;
        //incrementLabel.text = @"123";
        [imageViewBack addSubview:incrementLabel];
        
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"proChipsTotal" options:NSKeyValueObservingOptionOld context:nil];
        
        [[DataManager sharedInstance] addObserver:self forKeyPath:@"proChipsIncrement" options:NSKeyValueObservingOptionOld context:nil];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        button.frame = self.bounds;
        [button addTarget:self action:@selector(pressProChip) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"proChipsTotal"]){
        amountLabel.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getMyProChips]];
    }else if([keyPath isEqualToString:@"proChipsIncrement"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([DataManager sharedInstance].proChipsIncrement > 0){
                incrementLabel.text = [NSString stringWithFormat:@"+%d",[DataManager sharedInstance].proChipsIncrement];
                //incrementLabel.textColor = [UIColor colorWithRed:0.3 green:0.7 blue:.3 alpha:1];
            }else{
                incrementLabel.text = [NSString stringWithFormat:@"%d",[DataManager sharedInstance].proChipsIncrement];
                //incrementLabel.textColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1];
            }
            if([DataManager sharedInstance].proChipsIncrement != 0){
                [self animateToIncrement];
            }
        });
    }
}


-(void)animateToIncrement{
    if ([imageViewFront superview]) {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self
                                 cache:YES]; 
        [imageViewFront removeFromSuperview];
        [self insertSubview:imageViewBack belowSubview:button];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animateToTotal)];
        [UIView commitAnimations];
        
    }
    
}

-(void)animateToTotal{
    
    if ([imageViewBack superview]) {
        amountLabel.text = [NSString stringWithFormat:@"%d",[[DataManager sharedInstance] getMyProChips]];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:2];
        [UIView setAnimationDuration:.5];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self
                                 cache:YES]; 
        [imageViewBack removeFromSuperview];
        [self insertSubview:imageViewFront belowSubview:button];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
        
    }
}

-(void)pressProChip{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showStore];
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
