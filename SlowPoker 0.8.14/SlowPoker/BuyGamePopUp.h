//
//  BuyGamePopUp.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Button;
@class MFButton;
@class TurnsViewController;

@interface BuyGamePopUp : UIView<UIScrollViewDelegate>{
    Button *buyGiftButton;
    Button *buyForTableButton;
    MFButton *closeButton;
    
    UIScrollView *scroll;
    UIPageControl *pageControl;
    UIImageView *popupBackgroundImage;
    NSMutableArray *buttons;
    TurnsViewController *delegate;
}

@property(nonatomic,retain)Button *buyGiftButton;
@property(nonatomic,retain)Button *buyForTableButton;
@property(nonatomic,retain)MFButton *closeButton;
@property(nonatomic,retain)UIScrollView *scroll;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain) UIImageView *popupBackgroundImage;
@property(nonatomic,retain) NSMutableArray *buttons;
@property(nonatomic,retain) TurnsViewController *delegate;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand;
-(void)show;
-(void)hide;
-(void)buyGiftForUser;
@end
