//
//  ChatButton.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatButton : UIView{
    UIImage *balloonNoNewMessages;
    UIImage *balloonNewMessages;
    UIImage *sendMessages;
    UIImageView *buttonImage;
    UIButton *button;
    UILabel *buttonLabel;
    int previousNewMessages;
}

@property (nonatomic,retain)UIImage *balloonNoNewMessages;
@property (nonatomic,retain)UIImage *balloonNewMessages;
@property (nonatomic,retain)UIImage *sendMessages;
@property (nonatomic,retain)UIImageView *buttonImage;
@property (nonatomic,retain)UIButton *button;
@property (nonatomic,retain)UILabel *buttonLabel;

-(void)setChatState:(int)newMessages;

@end
