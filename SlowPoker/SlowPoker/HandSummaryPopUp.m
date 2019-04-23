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
#import "DataManager.h"

@implementation HandSummaryPopUp

@synthesize viewHandButton;
@synthesize dealNewHandButton;
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
        
        self.viewHandButton = [MFButton buttonWithType:UIButtonTypeCustom];
        viewHandButton.frame = CGRectMake(35, 275+15, 120, 40);
        [viewHandButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [viewHandButton addTarget:delegate action:@selector(pressViewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewHandButton];
        
        UILabel *viewHandLabel = [[UILabel alloc] initWithFrame:viewHandButton.bounds];
        viewHandLabel.font = [UIFont boldSystemFontOfSize:18];
        viewHandLabel.textAlignment = UITextAlignmentCenter;
        viewHandLabel.backgroundColor = [UIColor clearColor];
        viewHandLabel.textColor = [UIColor whiteColor];
        viewHandLabel.adjustsFontSizeToFitWidth = YES;
        viewHandLabel.minimumFontSize = 12;
        viewHandLabel.text = @"View Hand";
        [viewHandButton addSubview:viewHandLabel];
        
        
        self.dealNewHandButton = [MFButton buttonWithType:UIButtonTypeCustom];
        dealNewHandButton.frame = CGRectMake(165, 275+15, 120, 40);
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
        [dealNewHandButton addSubview:newHandLabel];

        
        /*
        self.closeButton = [[Button alloc] initWithFrame:CGRectMake(45, 275+35, 230, 40) title:@"Close Hand Summary" red:0.5 green:0.5 blue:0.5 alpha:1];
        [closeButton.button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];*/
        
        
        self.closeButton = [MFButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(75, 275+15, 170, 40);
        [closeButton setImage:[[UIImage imageNamed:@"gray_button.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15] forState:UIControlStateNormal];
        //[canclelButton setTitle:@"Check" forState:UIControlStateNormal];
        //[checkCallButton setBackgroundColor:[UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:1]];
        [closeButton addTarget:delegate action:@selector(pressViewHand) forControlEvents:UIControlEventTouchUpInside];
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
    delay = delay + 0.7;
    pageControl.currentPage = 0;
    if(showNewHand && [[[[DataManager sharedInstance] getPlayerMeForCurrentGame] valueForKey:@"status"] isEqualToString:@"playing"]){
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
    handsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 20,280,271 )];
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
        //handSummaryView.backgroundColor = [UIColor blueColor];
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
