//
//  GiftSelectionView.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@class Button;
@class MFButton;

@interface GiftSelectionView : UIView<UIScrollViewDelegate>{
    Button *buyGiftButton;
    Button *buyForTableButton;
    MFButton *closeButton;
    
    UIScrollView *scroll;
    UIPageControl *pageControl;
    UIImageView *popupBackgroundImage;
    NSMutableArray *buttons;
}

@property(nonatomic,retain)Button *buyGiftButton;
@property(nonatomic,retain)Button *buyForTableButton;
@property(nonatomic,retain)MFButton *closeButton;
@property(nonatomic,retain)UIScrollView *scroll;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,retain) UIImageView *popupBackgroundImage;
@property(nonatomic,retain) NSMutableArray *buttons;
- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
-(void)showHandSummary:(NSMutableDictionary *)hand showNewHand:(BOOL)showNewHand;
-(void)show;
-(void)hide;
-(void)buyGiftForUser;
@end
