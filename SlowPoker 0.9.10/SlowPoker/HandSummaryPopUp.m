//
//  HandSummaryPopUp.m
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HandSummaryPopUp.h"
#import "HandSummaryView.h"
#import "Button.h"
#import "MFButton.h"

@implementation HandSummaryPopUp

@synthesize viewHandButton;
@synthesize dealNewHandButton;
@synthesize showYourHandButton;
@synthesize closeButton;
@synthesize handsScroll;
@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        self.viewHandButton = [[Button alloc] initWithFrame:CGRectMake(45, 275+35, 110, 40) title:@"View Hand" red:0.5 green:0.5 blue:0.5 alpha:1];
        [viewHandButton.button addTarget:delegate action:@selector(pressViewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewHandButton];*/
        float heightView = 500;
        float topPaddingView = (self.bounds.size.height-heightView)/2;
        float buttonHeight = 40;
        float yButtonOffset = topPaddingView + heightView - buttonHeight*2;
        
        float xViewHandButton = (self.bounds.size.width-3*80-20)/3;
        
        self.viewHandButton = [MFButton buttonWithType:UIButtonTypeCustom];
        viewHandButton.frame = CGRectMake(xViewHandButton+10, yButtonOffset+15, 90, 40);
        [viewHandButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [viewHandButton addTarget:delegate action:@selector(pressViewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewHandButton];
        
        
        self.showYourHandButton = [MFButton buttonWithType:UIButtonTypeCustom];
        showYourHandButton.frame = CGRectMake(xViewHandButton+100, yButtonOffset+15, 100, 40);
        [showYourHandButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [showYourHandButton addTarget:delegate action:@selector(pressShowYourHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showYourHandButton];
        
        UILabel *viewHandLabel = [[UILabel alloc] initWithFrame:viewHandButton.bounds];
        viewHandLabel.font = [UIFont boldSystemFontOfSize:18];
        viewHandLabel.textAlignment = UITextAlignmentCenter;
        viewHandLabel.backgroundColor = [UIColor clearColor];
        viewHandLabel.textColor = [UIColor whiteColor];
        viewHandLabel.adjustsFontSizeToFitWidth = YES;
        viewHandLabel.font = [UIFont boldSystemFontOfSize: 12];
        viewHandLabel.text = @"View Hand";
        [viewHandButton addSubview:viewHandLabel];
        
        UILabel *yourHandLabel = [[UILabel alloc] initWithFrame:showYourHandButton.bounds];
        yourHandLabel.font = [UIFont boldSystemFontOfSize:18];
        yourHandLabel.textAlignment = UITextAlignmentCenter;
        yourHandLabel.backgroundColor = [UIColor clearColor];
        yourHandLabel.textColor = [UIColor whiteColor];
        yourHandLabel.adjustsFontSizeToFitWidth = YES;
        yourHandLabel.font = [UIFont boldSystemFontOfSize: 11];

        yourHandLabel.text = @"Show Your Hand";
        [showYourHandButton addSubview:yourHandLabel];
        
        self.dealNewHandButton = [MFButton buttonWithType:UIButtonTypeCustom];
        dealNewHandButton.frame = CGRectMake(xViewHandButton+200, yButtonOffset+15, 90, 40);
        [dealNewHandButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [dealNewHandButton addTarget:delegate action:@selector(pressNewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dealNewHandButton];
        
        UILabel *newHandLabel = [[UILabel alloc] initWithFrame:dealNewHandButton.bounds];
        newHandLabel.font = [UIFont boldSystemFontOfSize:18];
        newHandLabel.textAlignment = UITextAlignmentCenter;
        newHandLabel.backgroundColor = [UIColor clearColor];
        newHandLabel.textColor = [UIColor whiteColor];
        newHandLabel.adjustsFontSizeToFitWidth = YES;
        newHandLabel.minimumFontSize = 12;
        newHandLabel.text = @"New Hand";
        newHandLabel.font = [UIFont boldSystemFontOfSize: 12];
        [dealNewHandButton addSubview:newHandLabel];

        
        /*
        self.closeButton = [[Button alloc] initWithFrame:CGRectMake(45, 275+35, 230, 40) title:@"Close Hand Summary" red:0.5 green:0.5 blue:0.5 alpha:1];
        [closeButton.button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];*/
        float buttonWidth = 170;
        float xButtonOffset = (self.bounds.size.width-buttonWidth)/2;
        
        self.closeButton = [MFButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(xButtonOffset, yButtonOffset+15, 170, buttonHeight);
        [closeButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        UILabel *closeLabel = [[UILabel alloc] initWithFrame:closeButton.bounds];
        closeLabel.font = [UIFont boldSystemFontOfSize:18];
        closeLabel.textAlignment = UITextAlignmentCenter;
        closeLabel.backgroundColor = [UIColor clearColor];
        closeLabel.textColor = [UIColor whiteColor];
        closeLabel.adjustsFontSizeToFitWidth = YES;
        closeLabel.minimumFontSize = 12;
        closeLabel.text = @"Done";
        [closeButton addSubview:closeLabel];

        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(40, 126, 230, 20)];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        
        
    }
    return self;
}


-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand delay:(double)delay{
    
    pageControl.currentPage = 0;
    if(showNewHand){
        viewHandButton.hidden = NO;
        dealNewHandButton.hidden = NO;
        closeButton.hidden = YES;
        showYourHandButton.hidden = NO;
    }else{
        viewHandButton.hidden = YES;
        dealNewHandButton.hidden = YES;
        closeButton.hidden = NO;
        showYourHandButton.hidden = YES;
    }
    
    NSMutableArray *winners = [hand valueForKey:@"winners"];

    if(handsScroll){
        [handsScroll removeFromSuperview]; 
    }
    handsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake((self.bounds.size.width-280)/2, (self.bounds.size.height-415)/2-20,280,415)];
    handsScroll.backgroundColor = [UIColor clearColor];
    handsScroll.pagingEnabled = YES;
    handsScroll.delegate = self;
    [self addSubview:handsScroll];
    handsScroll.contentSize = CGSizeMake(280*[winners count], 210);
    pageControl.numberOfPages = [winners count];
    int scrollViewOffset = 0;
    BOOL isSplitPot = [winners count] > 1;
    for (NSMutableDictionary *winner in winners) {
        HandSummaryView *handSummaryView = [[HandSummaryView alloc] initWithFrame:CGRectMake(280*scrollViewOffset, 0, 280, 210)];
//        handSummaryView.backgroundColor = [UIColor blueColor];
        [handSummaryView setWinnerData:winner hand:hand isSplit:isSplitPot delay:delay];
        [handsScroll addSubview:handSummaryView];
        scrollViewOffset++;
        
    }
    
    [self showWithDelay:delay];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    CGFloat pageWidth = handsScroll.frame.size.width;
    int page = floor((handsScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
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
