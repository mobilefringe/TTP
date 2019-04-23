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
        
        self.viewHandButton = [[Button alloc] initWithFrame:CGRectMake(45, 275, 110, 40) title:@"View Hand" red:0.5 green:0.5 blue:0.5 alpha:1];
        [viewHandButton.button addTarget:delegate action:@selector(pressViewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewHandButton];
        
        self.dealNewHandButton = [[Button alloc] initWithFrame:CGRectMake(165, 275, 110, 40) title:@"New Hand" red:0.5 green:0.5 blue:0.5 alpha:1];
        [dealNewHandButton.button addTarget:delegate action:@selector(pressNewHand) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dealNewHandButton];
        
        self.closeButton = [[Button alloc] initWithFrame:CGRectMake(45, 275, 230, 40) title:@"Close Hand Summary" red:0.5 green:0.5 blue:0.5 alpha:1];
        [closeButton.button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(45, 255, 230, 20)];
        pageControl.hidesForSinglePage = YES;
        [self addSubview:pageControl];
        
        
    }
    return self;
}


-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand{
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
    handsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 50,250,210 )];
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
    
    [self show];
    
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
