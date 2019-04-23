//
//  HomeViewController.h
//  SlowPoker
//
//  Created by Jamie Simpson on 12-03-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFButton;
@class GamesViewController;
@class HandEvaluatorViewController;

@interface HomeViewController : UIViewController{
    MFButton *gamesButton;
    MFButton *proPointsButton;
    MFButton *statsButton;
    MFButton *leaderBoardsButton;
    MFButton *profileButton;
    GamesViewController *gamesViewController;
    HandEvaluatorViewController *handEvaluatorViewController;
    UILabel *userLabel;
}

@property(nonatomic,retain)MFButton *gamesButton;
@property(nonatomic,retain)MFButton *proPointsButton;
@property(nonatomic,retain)MFButton *statsButton;
@property(nonatomic,retain)MFButton *leaderBoardsButton;
@property(nonatomic,retain)MFButton *profileButton;
@property(nonatomic,retain)GamesViewController *gamesViewController;
@property(nonatomic,retain)HandEvaluatorViewController *handEvaluatorViewController;
@property(nonatomic,retain)UILabel *userLabel;

@end
