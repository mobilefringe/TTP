//
//  BetViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TurnSectionHeader;
@class MFButton;

@interface BetViewController : UIViewController{
    TurnSectionHeader *turnSectionHeader;
    NSMutableDictionary *hand;
    UIImageView *cardOne;
    UIImageView *cardTwo;
    
    MFButton *raiseButton;
    MFButton *checkCallButton;
    MFButton *foldButton;
    
    UISlider *raiseSlider;
    double callValue;
    double maxVal;
    double raiseValue;
    UIBarButtonItem *bugButton;
    UIButton *decreaseBuyIn;
    UIButton *increaseBuyIn;
    UILabel *userStackLabel;
}

@property (nonatomic,retain) TurnSectionHeader *turnSectionHeader;
@property (nonatomic,retain) NSMutableDictionary *hand;
@property (nonatomic,retain)UIImageView *cardOne;
@property (nonatomic,retain)UIImageView *cardTwo;
@property (nonatomic,retain)MFButton *raiseButton;
@property (nonatomic,retain)MFButton *checkCallButton;
@property (nonatomic,retain)MFButton *foldButton;
@property (nonatomic,retain)UISlider *raiseSlider;
@property (nonatomic,retain)UIButton *decreaseBuyIn;
@property (nonatomic,retain)UIButton *increaseBuyIn;
@property (nonatomic,retain)UILabel *userStackLabel;
@property (readwrite)double raiseValue;
@property (readwrite)double callValue;
@property (nonatomic,retain)UIBarButtonItem *bugButton;
-(void)doAction:(NSString *)action callAmount:(double)callAmount raiseAmount:(double)raiseAmount;

@end
