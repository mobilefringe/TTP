//
//  UpdatingPopUp.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdatingPopUp.h"

@implementation UpdatingPopUp

@synthesize message;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-220)/2, ([UIScreen mainScreen].bounds.size.height-150)/2, 220, 150)];
        background.image = [UIImage imageNamed:@"updating_overlay.png"];
        [self addSubview:background];
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(80, 65, 40, 40);
        //[self.view addSubview:activityIndicatorView];
        activityIndicatorView.hidesWhenStopped = YES;
        [activityIndicatorView startAnimating];
        [background addSubview:activityIndicatorView];
        
        self.message = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 40)];
        message.backgroundColor = [UIColor clearColor];
        message.textColor = [UIColor whiteColor];
        message.numberOfLines = 2;
        message.font = [UIFont boldSystemFontOfSize:18];
        message.textAlignment = UITextAlignmentCenter;
        [background addSubview:message];
        
        self.alpha = 0;
        
    }
    return self;
}

-(void)showWithMessage:(NSString *)messageText{
    message.text = messageText;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.4];
    self.alpha = 1;
    [UIView commitAnimations];
}

-(void)hide{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.4];
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
