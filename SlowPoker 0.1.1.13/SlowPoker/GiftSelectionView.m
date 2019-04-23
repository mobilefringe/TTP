//
//  HandSummaryPopUp.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GiftSelectionView.h"
#import "PopUpView.h"
#import "Button.h"
#import "DataManager.h"
#import "GiftButton.h"
#import "MFButton.h"

@implementation GiftSelectionView

@synthesize buyGiftButton;
@synthesize buyForTableButton;
@synthesize closeButton;
@synthesize scroll;
@synthesize pageControl;
@synthesize popupBackgroundImage;
@synthesize buttons;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:CGRectMake(0, 66, 320, 490)];
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.popupBackgroundImage = [[UIImageView alloc] initWithFrame:frame];
        [popupBackgroundImage setImage:[UIImage imageNamed:@"gifts_background.png"]];
        [self addSubview:popupBackgroundImage];
        
        
        UIImage *buyNowImage = [UIImage imageNamed:@"button_buy-now.png"];
        UIImageView *chipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,30,85,85)];
        chipImageView.image = buyNowImage;
        [self addSubview:chipImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 180, 28)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:26];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:.3 alpha:1];
        titleLabel.text = @"Gift Shop";
        [self addSubview:titleLabel];
        //[self addSubview:winnerLabel];
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, 180, 45)];
        subTitle.textAlignment = UITextAlignmentLeft;
        subTitle.font = [UIFont boldSystemFontOfSize:12];
        subTitle.backgroundColor = [UIColor clearColor];
        subTitle.adjustsFontSizeToFitWidth = YES;
        subTitle.minimumFontSize = 10;
        subTitle.numberOfLines = 3;
        subTitle.text = @"Buy a gift for players to let'em know how you really feel!";
        subTitle.textColor = [UIColor whiteColor];
        [self addSubview:subTitle];

        
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(19, 139,282,215 )];
        scroll.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:scroll];
        
        
        int x = 0;
        int y = 0;
        int count = 0;
        int width = 94;
        int height = 80;
        self.buttons = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *gift in [DataManager sharedInstance].gifts) {
            
            GiftButton *giftButton = [[GiftButton alloc] initWithFrame:CGRectMake(0+(width*x), 0+(height*y), width-1, height-1) data:gift];
            [buttons addObject:giftButton];
            [giftButton addObserver:self forKeyPath:@"pressed" options:NSKeyValueObservingOptionOld context:nil];
            if(count == 0){
                [giftButton selectGift];
            }
            count++;
            if(y==1){
                x++;
            }
            y++;
            if(y==2){
                y=0;
            }
            
            
            
            [scroll addSubview:giftButton];
        }
        
                
        MFButton *buyGiftMFButton = [MFButton buttonWithType:UIButtonTypeCustom];
        buyGiftMFButton.frame = CGRectMake(25, 275+30, 130, 40);
        [buyGiftMFButton setImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [buyGiftMFButton addTarget:self action:@selector(buyGiftForUser) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buyGiftMFButton];
        
        UILabel *buyGiftLabel = [[UILabel alloc] initWithFrame:buyGiftMFButton.bounds];
        buyGiftLabel.font = [UIFont boldSystemFontOfSize:18];
        buyGiftLabel.textAlignment = UITextAlignmentCenter;
        buyGiftLabel.backgroundColor = [UIColor clearColor];
        buyGiftLabel.textColor = [UIColor whiteColor];
        buyGiftLabel.adjustsFontSizeToFitWidth = YES;
        buyGiftLabel.minimumFontSize = 12;
        buyGiftLabel.text = @"Buy Gift";
        [buyGiftMFButton addSubview:buyGiftLabel];
        
        
        MFButton *buyForTableMFButton = [MFButton buttonWithType:UIButtonTypeCustom];
        buyForTableMFButton.frame = CGRectMake(165, 275+30, 130, 40);
        [buyForTableMFButton setImage:[UIImage imageNamed:@"big_blue_button.png"] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [buyForTableMFButton addTarget:self action:@selector(buyGiftForTable) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buyForTableMFButton];
        
        UILabel *buyForTableLabel = [[UILabel alloc] initWithFrame:buyForTableMFButton.bounds];
        buyForTableLabel.font = [UIFont boldSystemFontOfSize:18];
        buyForTableLabel.textAlignment = UITextAlignmentCenter;
        buyForTableLabel.backgroundColor = [UIColor clearColor];
        buyForTableLabel.textColor = [UIColor whiteColor];
        buyForTableLabel.adjustsFontSizeToFitWidth = YES;
        buyForTableLabel.minimumFontSize = 12;
        buyForTableLabel.text = @"Buy For Table";
        [buyForTableMFButton addSubview:buyForTableLabel];
        
        
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(45, 255, 230, 20)];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        self.alpha = 0;
        
        self.closeButton = [MFButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(270, 20, 40, 40);
        [closeButton setImage:[UIImage imageNamed:@"close_button_x.png"] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
    
        
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    for (GiftButton *giftButton in buttons) {
        [giftButton unselectGift];
    }
    
}


-(void)buyGiftForTable{
    [DataManager sharedInstance].giftUserID = @"-1";
    for (GiftButton *giftButton in buttons) {
        if(giftButton.selected){
            [[DataManager sharedInstance] buyGift:giftButton.giftData forUser:[DataManager sharedInstance].giftUserID];
        }
    }
    [self hide];    
}

-(void)buyGiftForUser{
    for (GiftButton *giftButton in buttons) {
        if(giftButton.selected){
            [[DataManager sharedInstance] buyGift:giftButton.giftData forUser:[DataManager sharedInstance].giftUserID];
        }
    }
    [self hide];    
}

-(void)show{
    [FlurryAnalytics endTimedEvent:@"SHOW_GIFTS" withParameters:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    self.alpha = 1;
    [UIView commitAnimations];
}

-(void)hide{
    [FlurryAnalytics endTimedEvent:@"SHOW_GIFTS" withParameters:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationDelegate:self];
    self.alpha = 0;
    [UIView commitAnimations];
}


-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand{
    /*
    pageControl.currentPage = 0;
    if(showNewHand){
        viewHandButton.hidden = NO;
        dealNewHandButton.hidden = NO;
        closeButton.hidden = YES;
    }else{
        viewHandButton.hidden = YES;
        dealNewHandButton.hidden = YES;
        closeButton.hidden = NO;
    }
    
    NSMutableArray *winners = [hand valueForKey:@"winners"];
    
    if(handsScroll){
        [handsScroll removeFromSuperview]; 
    }
    handsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 40,270,250 )];
    handsScroll.backgroundColor = [UIColor clearColor];
    handsScroll.delegate = self;
    [self addSubview:handsScroll];
    handsScroll.contentSize = CGSizeMake(250*[winners count], 210);
    pageControl.numberOfPages = [winners count];
    int scrollViewOffset = 0;
    for (NSMutableDictionary *winner in winners) {
        HandSummaryView *handSummaryView = [[HandSummaryView alloc] initWithFrame:CGRectMake(250*scrollViewOffset, 0, 250, 210)];
        //handSummaryView.backgroundColor = [UIColor blueColor];
        [handSummaryView setWinnerData:winner hand:hand];
        [handsScroll addSubview:handSummaryView];
        scrollViewOffset++;
        
    }
    */
    [self show];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat pageWidth = scroll.frame.size.width;
    int page = floor((scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    
    
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
