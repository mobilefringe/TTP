//
//  ChatButton.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatButton.h"

@implementation ChatButton

@synthesize balloonNoNewMessages;
@synthesize balloonNewMessages;
@synthesize sendMessages;
@synthesize buttonImage;
@synthesize button;
@synthesize buttonLabel;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.balloonNoNewMessages = [[UIImage imageNamed:@"chat_icon_blue.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        self.balloonNewMessages = [[UIImage imageNamed:@"chat_icon_purple.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        
        self.balloonNewMessages = [UIImage imageWithCGImage: balloonNewMessages.CGImage scale:1.0 orientation:(UIImageOrientationUpMirrored)];
        //self.balloonNewMessages = [balloonNewMessages stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        
        self.sendMessages = [UIImage imageNamed:@"aqua_button.png"];
        self.buttonImage = [[UIImageView alloc] initWithImage:balloonNoNewMessages];
        buttonImage.frame = self.bounds;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.showsTouchWhenHighlighted = YES;
        button.frame = self.bounds;
        [self addSubview:buttonImage];
        
        self.buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 4, 35, 18)];
        buttonLabel.textColor = [UIColor whiteColor];
        buttonLabel.font = [UIFont boldSystemFontOfSize:12];
        buttonLabel.adjustsFontSizeToFitWidth = YES;
        buttonLabel.minimumFontSize = 8;
        buttonLabel.backgroundColor = [UIColor clearColor];
        buttonLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:buttonLabel];
        [self addSubview:button];
    }
    //self.backgroundColor = [UIColor redColor];
    return self;
}


-(void)setChatState:(int)newMessages{
    [buttonImage setUserInteractionEnabled:YES];
    
    
    
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:0.25];
    //buttonLabel.alpha = 1;
    if(newMessages == 0){
        buttonLabel.textColor = [UIColor whiteColor];
        buttonLabel.font = [UIFont boldSystemFontOfSize:12];
        self.buttonLabel.frame = CGRectMake(3, 4, 35, 18);
        buttonLabel.text = @"";
        [buttonImage setImage:balloonNoNewMessages];
    }else if(newMessages > 0){
        buttonLabel.textColor = [UIColor whiteColor];
        buttonLabel.font = [UIFont boldSystemFontOfSize:18];
        self.buttonLabel.frame = CGRectMake(5, 4, 35, 18);
        buttonLabel.text = [NSString stringWithFormat:@"%d",newMessages];
        [buttonImage setImage:balloonNewMessages];
    }else{
        [buttonImage setImage:sendMessages];
    }
    [UIView commitAnimations];
    
    if(newMessages > 1 && newMessages > previousNewMessages){
        previousNewMessages = newMessages;
       
    }else if(previousNewMessages > newMessages){
        previousNewMessages = 0;
        
    }
    
    
}

-(void)wobbleUp{
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
