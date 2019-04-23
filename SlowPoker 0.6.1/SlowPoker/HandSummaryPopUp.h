//
//  HandSummaryPopUp.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-05-20.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpView.h"

@class Button;

@interface HandSummaryPopUp : PopUpView<UIScrollViewDelegate>{
    Button *viewHandButton;
    Button *dealNewHandButton;
    Button *closeButton;
    UIScrollView *handsScroll;
    UIPageControl *pageControl;
}

@property(nonatomic,retain)Button *viewHandButton;
@property(nonatomic,retain)Button *dealNewHandButton;
@property(nonatomic,retain)Button *closeButton;
@property(nonatomic,retain)UIScrollView *handsScroll;
@property(nonatomic,retain)UIPageControl *pageControl;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand;

@end
