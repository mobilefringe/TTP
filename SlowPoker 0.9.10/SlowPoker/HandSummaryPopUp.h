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
@class MFButton;

@interface HandSummaryPopUp : PopUpView<UIScrollViewDelegate>{
    MFButton *viewHandButton;
    MFButton *dealNewHandButton;
    MFButton *showYourHandButton;
    MFButton *closeButton;
    UIScrollView *handsScroll;
    UIPageControl *pageControl;
}

@property(nonatomic,retain)MFButton *viewHandButton;
@property(nonatomic,retain)MFButton *dealNewHandButton;
@property(nonatomic,retain)MFButton *showYourHandButton;
@property(nonatomic,retain)MFButton *closeButton;
@property(nonatomic,retain)UIScrollView *handsScroll;
@property(nonatomic,retain)UIPageControl *pageControl;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand delay:(double)delay;

@end
