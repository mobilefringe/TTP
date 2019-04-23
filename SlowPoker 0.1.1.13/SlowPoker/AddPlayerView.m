//
//  AddPlayerView.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-04-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddPlayerView.h"
#import "DataManager.h"
#import "Button.h"
#import "TurnsViewController.h"
#import "Avatar.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation AddPlayerView
@synthesize backgroundImageView;
@synthesize backgroundBlue;
@synthesize grayBar;
@synthesize userNameLabel;
@synthesize userStackLabel;
@synthesize actionLabel;
@synthesize player;
@synthesize avatar;
@synthesize refreshTimer;
@synthesize dealerButton;
@synthesize cardOne;
@synthesize cardTwo;
@synthesize playerView;
@synthesize isMe;
@synthesize delegate;
@synthesize button;
@synthesize dateFormatter;
@synthesize chipImageView;
@synthesize greenChip;
@synthesize redChip;
@synthesize yellowChip;
@synthesize giftButton;
@synthesize giftUserID;
@synthesize giftIcon;
@synthesize giftFlipView;
@synthesize giftActiveBackground;
@synthesize giftActiveImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    
    
    
    
    
    self.playerView = [[UIView alloc] initWithFrame:self.bounds];
    playerView.backgroundColor = [UIColor clearColor];
    [self addSubview:playerView];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"player_view_player_background.png"];
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = backgroundImage;
    [playerView addSubview:backgroundImageView];
    
    self.backgroundBlue = [UIImage imageNamed:@"player_view_player_background_blue.png"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    
    
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, 61, 15)];
    userNameLabel.text = @"Invite";
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.numberOfLines = 2;
    userNameLabel.font = [UIFont boldSystemFontOfSize:11];
    userNameLabel.textAlignment = UITextAlignmentCenter;
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.minimumFontSize = 8;
    userNameLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:userNameLabel];
    
    
    self.actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 61, 15)];
    actionLabel.backgroundColor = [UIColor clearColor];
    actionLabel.font = [UIFont boldSystemFontOfSize:11];
    actionLabel.textAlignment = UITextAlignmentCenter;
    actionLabel.adjustsFontSizeToFitWidth = YES;
    actionLabel.text = @"Player";
    actionLabel.minimumFontSize = 8;
    actionLabel.textColor = [UIColor whiteColor];
    [playerView addSubview:actionLabel];
    
    self.avatar = [[Avatar alloc] initWithFrame:CGRectMake(10.7, 35, 64.2, 64.2)];
    [avatar loadAvatar:nil];
    [playerView addSubview:avatar];
    
    
    UIImage *grayBarImage = [UIImage imageNamed:@"player_view_gray_bar.png"];
    self.grayBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, grayBarImage.size.width/2+9, grayBarImage.size.height/2)];
    grayBar.center = CGPointMake(42.4, 103.4);
    grayBar.image = grayBarImage;
    [playerView addSubview:grayBar];
    
    self.userStackLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 57, 50, 50)];
    userStackLabel.backgroundColor = [UIColor clearColor];
    userStackLabel.font = [UIFont boldSystemFontOfSize:37];
    userStackLabel.textColor = [UIColor blackColor];
    userStackLabel.textAlignment = UITextAlignmentCenter;
    userStackLabel.adjustsFontSizeToFitWidth = YES;
    userStackLabel.minimumFontSize = 8;
    userStackLabel.text = @"+";
    [playerView addSubview:userStackLabel];
    
    
    
    
       
      
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = self.bounds;
    button.showsTouchWhenHighlighted = YES;
    [self addSubview:button];
    
    
    
    
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*
     CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetLineWidth(context, 2);
     if([[player valueForKey:@"action"] isEqualToString:@"fold"] || ![[player valueForKey:@"status"] isEqualToString:@"playing"]){
     CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
     CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5].CGColor);
     }else{
     CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
     CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.85].CGColor);
     }
     if([[[DataManager sharedInstance].currentGame valueForKey:@"nextActionForUserID"] isEqualToString:[player valueForKey:@"userID"]] && [[DataManager sharedInstance] isCurrentGameActive] && isCurrentHandTmp){
     CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.6 blue:0.9 alpha:0.95].CGColor);
     }else if(isWinner){
     CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.1 green:0.5 blue:0.1 alpha:0.9].CGColor);
     }
     
     CGRect rrect = self.bounds;
     
     CGFloat radius = 8;
     CGFloat width = CGRectGetWidth(rrect);
     CGFloat height = CGRectGetHeight(rrect);
     
     // Make sure corner radius isn't larger than half the shorter side
     if (radius > width/2.0)
     radius = width/2.0;
     if (radius > height/2.0)
     radius = height/2.0;
     
     CGFloat minx = CGRectGetMinX(rrect);
     CGFloat midx = CGRectGetMidX(rrect);
     CGFloat maxx = CGRectGetMaxX(rrect);
     CGFloat miny = CGRectGetMinY(rrect);
     CGFloat midy = CGRectGetMidY(rrect);
     CGFloat maxy = CGRectGetMaxY(rrect);
     CGContextMoveToPoint(context, minx, midy);
     CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
     CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
     CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
     CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
     CGContextClosePath(context);
     CGContextDrawPath(context, kCGPathFillStroke);
     
     if(isMe){
     CGContextSetRGBFillColor(context, 1.0,1.0,1.0,0.6);
     CGContextFillRect(context, CGRectMake(1, 34, self.frame.size.width-2, 60));
     }
     CGContextDrawPath(context, kCGPathFillStroke);
     
     */
    
}




@end
